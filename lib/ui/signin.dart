import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uber_mobile/core/providers/sessionManager.dart';
import 'package:uber_mobile/ui/widgets/primaryButton.dart';
import 'package:uber_mobile/utils/colors.dart';
import 'package:uber_mobile/utils/typography.dart';

class SignIn extends ConsumerWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    final sessionManager = widgetRef.read(sessionProvider.notifier);
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
                    await sessionManager.googleSignIn();
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
