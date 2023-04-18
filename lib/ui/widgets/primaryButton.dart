import 'package:flutter/material.dart';
import 'package:uber_mobile/utils/colors.dart';
import 'package:uber_mobile/utils/typography.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.title, required this.onPressed});

  final String title;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(onPressed == null ? UberColors.gray : UberColors.primary),
          foregroundColor: const MaterialStatePropertyAll(Colors.white),
          padding: const MaterialStatePropertyAll(EdgeInsets.all(15)),
          textStyle: MaterialStatePropertyAll(UberTypography.buttonStyle()),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(title));
  }
}
