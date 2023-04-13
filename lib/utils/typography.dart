import 'package:flutter/material.dart';

class UberText {
  static Text paragraphRegular(String text, {Color color = Colors.white}) {
    return Text(
      text,
      style: TextStyle(
        color: color,
      ),
    );
  }

  static Text button(String text, {Color color = Colors.white}) {
    return Text(
      text,
      style: UberTypography.buttonStyle(color: color),
    );
  }
}

class UberTypography {
  static TextStyle buttonStyle({Color color = Colors.white}) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.w700,
      fontSize: 15,
    );
  }
}
