//create a stateless widget for side heading

import 'package:flutter/material.dart';

class SideHeading extends StatelessWidget {
  final String heading;
  const SideHeading({super.key, required this.heading});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      child: Text(
        heading,
        style: const TextStyle(
          color: Color(0xFF22215B),
          fontSize: 20,
        ),
      ),
    );
  }
}