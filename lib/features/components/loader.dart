import 'package:flutter/material.dart';
import 'package:tenantmgmnt/themes/colors.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: appBackgroundColor,
        child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                  Center(
                    child: Text('Loading...'),
                  )
                ],
              ),
            ),
      ),
    );
  }
}
