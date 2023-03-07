import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:tenantmgmnt/themes/colors.dart';

void showOTPDialog({
  required BuildContext context,
  required TextEditingController codeController,
  required VoidCallback onPressed,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      title: const Text("Enter OTP"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          OtpTextField(
            numberOfFields: 6,
            borderColor: appAccentColor,
            //set to true to show as box or false to show as dash
            showFieldAsBox: true,
            //runs when a code is typed in
            onCodeChanged: (String code) {
              print(code);
            },
            //runs when every textfield is filled
            onSubmit: (String verificationCode) {
              onPressed();
            }, // end onSubmit
          ),
          //   TextField(
          //     controller: codeController,
          //   ),
        ],
      ),
      // actions: <Widget>[
      //   TextButton(
      //     child: const Text("Done"),
      //     onPressed: onPressed,
      //   )
      // ],
    ),
  );
}
