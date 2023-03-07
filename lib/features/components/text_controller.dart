// create a text controller component

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tenantmgmnt/themes/colors.dart';

class TextController extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obsecureText;
  final inputFormatters;
  final keyboardType;
  final maxlines;
  final minlines;
  bool autofocus;
  TextController(
      {super.key,
      required this.hint,
      this.autofocus = false,
      required this.controller,
      this.obsecureText = false,
      this.inputFormatters,
      this.maxlines = 1,
      this.minlines = 1,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxlines,
      autofocus: autofocus,
      minLines: minlines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: TextCapitalization.sentences,
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
