import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uber_mobile/utils/colors.dart';

class UberBackButton extends StatelessWidget {
  const UberBackButton({super.key, this.onTap});
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            context.pop();
          },
      child: CircleAvatar(
        backgroundColor: UberColors.primary,
        foregroundColor: UberColors.bgColor,
        radius: 20,
        child: const Center(
          child: Icon(
            Icons.chevron_left_outlined,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
