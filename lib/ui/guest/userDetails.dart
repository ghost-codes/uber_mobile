import 'package:flutter/material.dart';
import 'package:uber_mobile/utils/colors.dart';

class UserDetailsPage extends StatelessWidget {
  const UserDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UberColors.bgColor,
      body: ListView(
        children: const [
          Center(
            child: Text("User Details"),
          ),
        ],
      ),
    );
  }
}
