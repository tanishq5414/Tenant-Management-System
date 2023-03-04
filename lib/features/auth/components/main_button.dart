//create a text button widget component

import 'package:flutter/material.dart';
import 'package:tenantmgmnt/themes/colors.dart';

class MainButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  const MainButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: appAccentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text,
          ),
    );
  }
}
