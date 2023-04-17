import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uber_mobile/core/error/failure.dart';
import 'package:uber_mobile/core/graphql/mutations/createSession.g.dart';
import 'package:uber_mobile/core/models/session.dart';
import 'package:uber_mobile/core/network/graphql/graphql_client.dart';
import 'package:uber_mobile/core/repository_mixin.dart';
import 'package:uber_mobile/core/services/serviceLocator.dart';
import 'package:uber_mobile/utils/appSharedPref.dart';

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

  Future<void> authenticate(String tokenId) async {
    final result =
        await gqlClient.runMutation(CreateSessionRequest(tokenId), resultKey: "createSession");
    sharedPref.setUser(json.encode(result));
    final session = Session.fromJson(result!);
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
      await authenticate(idToken);
    });
  }
}

final sessionProvider =
    StateNotifierProvider<SessionManager, Session?>((ref) => SessionManager(null));
