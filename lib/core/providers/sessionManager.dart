import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uber_mobile/core/error/failure.dart';
import 'package:uber_mobile/core/graphql/mutations/createSession.g.dart';
import 'package:uber_mobile/core/graphql/mutations/createUserMetaData.g.dart';
import 'package:uber_mobile/core/models/session.dart';
import 'package:uber_mobile/core/models/session.dart' as u;
import 'package:uber_mobile/core/network/graphql/graphql_client.dart';
import 'package:uber_mobile/core/repository_mixin.dart';
import 'package:uber_mobile/core/services/serviceLocator.dart';
import 'package:uber_mobile/utils/appSharedPref.dart';
import 'package:uber_mobile/utils/extensions.dart';

class CreateUserMetaDataViewModel extends StateNotifier<bool> {
  DateTime? dateOfBirth;
  String? phone;

  CreateUserMetaDataViewModel(super.state);

  bool get isReady => phone != null && dateOfBirth != null;

  setDateTime(DateTime date) {
    dateOfBirth = date;

    state = isReady;
  }

  setPhone(String s) {
    phone = s;
    state = isReady;
  }
}

class SessionManager extends StateNotifier<Session?> with RepositoryMixin {
  SessionManager(super.state);
  final gqlClient = sl<GraphQLClient>();
  final sharedPref = sl<AppSharedPref>();

  Future<void> initialize() async {
    final user = sharedPref.user;
    if (user == null) return;

    final session = Session.fromJson(user);
    state = session;
  }

  Future<void> updateSession(Session session) async {
    state = session;
  }

  Future<void> clear() async {
    state = null;
  }

  Future<void> authenticate(String tokenId, u.User user) async {
    final result =
        await gqlClient.runMutation(CreateSessionRequest(tokenId), resultKey: "createSession");
    final session = Session.fromJson(result!);
    session.user = user;
    sharedPref.setUser(json.encode(session.toJson()));
    updateSession(session);
  }

  Future<void> googleSignIn() async {
    await runOperation(() async {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final user = await FirebaseAuth.instance.signInWithCredential(credential);

      final idToken = await user.user?.getIdToken();
      if (idToken == null) {
        throw OperationFailure(message: "Could not retreive id token");
      }
      sharedPref.setAccessToken(idToken);
      final currentUser = u.User(user.user!.email!, user.user!.displayName!);
      await authenticate(idToken, currentUser);
    });
  }

  Future<void> createUserMetaData(CreateUserMetaDataViewModel model) async {
    await runOperation(() async {
      final idToken = sharedPref.accessToken;

      final result = await gqlClient
          .runMutation(CreateUserMetaDataRequest(model.phone, idToken, model.dateOfBirth!.json()));
      state =
          Session(state!.isSignupComplete, metadata: MetaData.fromJson(result!), user: state!.user);
    });
  }
}

final sessionProvider =
    StateNotifierProvider<SessionManager, Session?>((ref) => SessionManager(null));
