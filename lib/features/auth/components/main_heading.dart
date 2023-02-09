// create a main heading widget

import 'package:flutter/material.dart';

class MainHeading extends StatelessWidget {
  final String heading;
  const MainHeading({super.key, required this.heading});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      child: Text(
        heading,
        style: const TextStyle(
          color: Color(0xFF22215B),
          fontSize: 60,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}