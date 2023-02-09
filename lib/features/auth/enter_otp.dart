import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class showOtpDialog extends StatefulWidget {
  var codecontroller;
  
  var onPressed;

  showOtpDialog({super.key,required this.codecontroller, required this.onPressed});

  @override
  State<showOtpDialog> createState() => _showOtpDialogState();
}

class _showOtpDialogState extends State<showOtpDialog> {
  // query parameters

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Enter OTP'),
        ),
        body: Column(
          children: [
            TextField(
              controller: widget.codecontroller,
            ),
            ElevatedButton(
              onPressed: () {
                widget.onPressed();
              },
              child: const Text('Done'),
            )
          ],
        ));
  }
}
