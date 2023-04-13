import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uber_mobile/core/models/session.dart';
import 'package:uber_mobile/ui/widgets/primaryButton.dart';
import 'package:uber_mobile/utils/colors.dart';
import 'package:uber_mobile/utils/typography.dart';

final googleSiginProvider = FutureProvider<String?>((ref) async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  final user = await FirebaseAuth.instance.signInWithCredential(credential);

  return user.credential?.accessToken;
});

final siginProvider = FutureProvider<Session?>((ref) async {
  final googleSigin = ref.read(googleSiginProvider);

  return Session(false);
});

class SignIn extends ConsumerWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    return Scaffold(
      backgroundColor: UberColors.bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: UberColors.primary,
                gradient: LinearGradient(
                  colors: [
                    UberColors.secondary,
                    UberColors.primary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SafeArea(
            top: false,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final ss = widgetRef.read(googleSiginProvider);
                    print(ss);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: UberColors.primary),
                    ),
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.all(15),
                    child: Center(child: UberText.button("Signin with Google")),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  child: PrimaryButton(
                    title: "Sign In",
                    onPressed: () async {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
