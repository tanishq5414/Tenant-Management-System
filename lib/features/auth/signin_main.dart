import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tenantmgmnt/features/auth/components/main_button.dart';
import 'package:tenantmgmnt/features/auth/components/main_heading.dart';
import 'package:tenantmgmnt/features/components/text_controller.dart';
import 'package:tenantmgmnt/features/auth/controller/auth_controller.dart';
import 'package:tenantmgmnt/themes/colors.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';


// import 'package:flutter_riverpod/flutter_riverpod.dart';




class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

var phonecontrller = TextEditingController();
var otpcontroller = TextEditingController();
var error;



dispose() {
  phonecontrller.dispose();
  otpcontroller.dispose();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        print(isKeyboardVisible);
        return Container(
          color: appBackgroundColor,
          child: SafeArea(
              child: Scaffold(
            
            resizeToAvoidBottomInset: false,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (isKeyboardVisible = true)?MainHeading(heading: 'Hola!'): SizedBox(),
                SizedBox(
                  height: size.height * 0.06,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width * 0.05,
                  ),
                  child: const Text('ENTER PHONE NUMBER',
                      style: TextStyle(fontSize: 13)),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                SizedBox(
                  height: size.height * 0.1,
                  width: size.width * 0.9,
                  child: Padding(
                    padding: EdgeInsets.only(left: size.width * 0.05),
                    child: TextController(
                      autofocus: true,
                      hint: '999999999',
                      controller: phonecontrller,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(right: size.width * 0.1),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       SizedBox(
                //         width: size.width * 0.58,
                //         child: TextController(
                //           hint: '0000',
                //           obsecureText: true,
                //           controller: otpcontroller,
                //         ),
                //       ),
                //       // create a button get code
                //       SizedBox(
                //         height: size.height * 0.07,
                //         width: size.width * 0.3,
                //         child: ElevatedButton(
                //           onPressed: () {
                //             print('Get Code');
                //           },
                //           style: ElevatedButton.styleFrom(
                //             primary: appAccentColor,
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(10),
                //             ),
                //           ),
                //           child: const Text('Get Code'),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.05, right: size.width * 0.1),
                  child: SizedBox(
                      height: size.height * 0.07,
                      width: size.width,
                      child: MainButton(
                          text: 'Verify',
                          onPressed: () {
                            print('Verify');
                            ref.read(authControllerProvider.notifier).PhoneSignIn(context, phonecontrller.text);
                            // showSnackBar(context, 'Verify');
                            // Routemaster.of(context).push('/signupdata');
        
                          })),
                ),
                SizedBox(
                  height: size.height * 0.2,
                ),
                Center(
                  child: Text('By continuing, you agree to our',
                      style: TextStyle(fontSize: 13)),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Terms of Service',
                        style: TextStyle(fontSize: 13, color: appAccentColor)),
                    const Text(' and ',
                        style: TextStyle(fontSize: 13, color: Colors.black)),
                    const Text('Privacy Policy',
                        style: TextStyle(fontSize: 13, color: appAccentColor)),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
              ],
            ),
          )),
        );
      }
    );
  }
}
