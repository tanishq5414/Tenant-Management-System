// create a text controller component

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tenantmgmnt/themes/colors.dart';

class TextController extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obsecureText;
  const TextController(
      {super.key,
      required this.hint,
      required this.controller,
      this.obsecureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // keyboardType: TextInputType.none,
      // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      controller: controller,
      obscureText: obsecureText,
      decoration: InputDecoration(
        hintText: hint,
        fillColor: appGreyColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
