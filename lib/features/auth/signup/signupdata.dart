import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/auth/components/main_button.dart';
import 'package:tenantmgmnt/features/auth/components/main_heading.dart';
import 'package:tenantmgmnt/features/auth/components/side_heading.dart';
import 'package:tenantmgmnt/features/components/text_controller.dart';
import 'package:tenantmgmnt/features/auth/controller/auth_controller.dart';
import 'package:tenantmgmnt/features/auth/signin_main.dart';
import 'package:tenantmgmnt/features/owner/controller/owner_controller.dart';
import 'package:tenantmgmnt/themes/colors.dart';

// create a type of stateful widget

class SignUpData extends ConsumerStatefulWidget {
  const SignUpData({super.key});

  @override
  ConsumerState<SignUpData> createState() => _SignUpDataState();
}

TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController emailController = TextEditingController();

class _SignUpDataState extends ConsumerState<SignUpData> {
  List<String> list = <String>[
    'Choose your user type',
    'I am a tenant',
    'I am a landlord',
  ];
  String dropdownValue = 'Choose your user type';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SideHeading(heading: 'Please fill in your details'),
            SizedBox(
              height: size.height * 0.03,
            ),
            const MainHeading(heading: 'Profile'),
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: size.width * 0.05,
                right: size.width * 0.1,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * 0.4,
                    child: TextController(
                        hint: 'First Name', controller: firstNameController),
                  ),
                  SizedBox(
                    width: size.width * 0.4,
                    child: TextController(
                        hint: 'Last Name', controller: lastNameController),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(size.width * 0.05, 0, 0, 0),
              child: SizedBox(
                width: size.width * 0.85,
                child: TextController(
                    hint: 'youremail@provider.com', controller: emailController),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            // SizedBox(
            //   width: size.width * 0.9,
            //   child:
            //       TextController(hint: 'Password', controller: lastNameController),
            // ),
            // SizedBox(
            //   height: size.height * 0.01,
            // ),
            // SizedBox(
            //   width: size.width * 0.9,
            //   child: TextController(
            //       hint: 'Confirm Password', controller: lastNameController),
            // ),
            SizedBox(
              height: size.height * 0.02,
            ),
            SizedBox(
                width: size.width * 0.9,
                child: Padding(
                  padding: EdgeInsets.only(left: size.width * 0.05),
                  child: const Text(
                    'TYPE OF USER',
                    style: TextStyle(color: appBlackColor, fontSize: 15),
                  ),
                )),
            SizedBox(
              height: size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.1),
              child: Container(
                decoration: BoxDecoration(
                    color: appGreyColor,
                    borderRadius: BorderRadius.circular(10)),
                width: size.width * 0.9,
                height: size.height * 0.07,
                child: Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: dropdownValue,
                        icon: const Visibility(
                            visible: false, child: Icon(Icons.arrow_drop_down)),
                        elevation: 16,
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.black87),
                            ),
                          );
                        }).toList(),
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.1),
              child: SizedBox(
                width: size.width * 0.9,
                height: size.height * 0.07,
                child: MainButton(
                  text: 'Next',
                  onPressed: () {
                    if (dropdownValue == 'Choose your user type') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a user type'),
                        ),
                      );
                    } else if (dropdownValue == 'I am a tenant') {
                      ref
                          .read(authControllerProvider.notifier)
                          .insertTenantFirstDetails(
                              context: context,
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              email: emailController.text,
                              phone: phonecontrller.text,
                              typeofuser: dropdownValue);
                    } else if (dropdownValue == 'I am a landlord') {
                      ref
                          .read(ownerControllerProvider.notifier)
                          .insertOwnerFirstDetails(
                              context: context,
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              email: emailController.text,
                              phone: phonecontrller.text,
                              typeofuser: dropdownValue);
                    }
                    Routemaster.of(context).push('/');

                  },
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
          ],
        ));
  }
}
