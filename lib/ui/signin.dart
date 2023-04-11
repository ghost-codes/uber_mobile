import 'package:flutter/material.dart';
import 'package:uber_mobile/ui/widgets/primaryButton.dart';
import 'package:uber_mobile/utils/colors.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              child: PrimaryButton(
                title: "Sign in",
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
