import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:selectable_container/selectable_container.dart';
import 'package:tenantmgmnt/features/auth/components/main_button.dart';
import 'package:tenantmgmnt/features/auth/controller/auth_controller.dart';
import 'package:tenantmgmnt/features/components/snack_bar.dart';
import 'package:tenantmgmnt/features/components/text_controller.dart';
import 'package:tenantmgmnt/features/components/custom_app_bar.dart';
import 'package:tenantmgmnt/features/owner/controller/owner_controller.dart';

class AddProperty extends ConsumerStatefulWidget {
  const AddProperty({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPropertyState();
}

class _AddPropertyState extends ConsumerState<AddProperty> {
  var propertyname = TextEditingController();
  var propertystate = TextEditingController();
  var propertycity = TextEditingController();
  var propertyarea = TextEditingController();
  var buildingList = [
    'https://firebasestorage.googleapis.com/v0/b/tenantmanagement-8b61d.appspot.com/o/b1.png?alt=media&token=ecfbfe5e-6c19-4b6c-8527-f282da0c13c4',
    'https://firebasestorage.googleapis.com/v0/b/tenantmanagement-8b61d.appspot.com/o/b2.png?alt=media&token=eec7dfd7-ba65-4990-85eb-8aac0e4c3872',
    'https://firebasestorage.googleapis.com/v0/b/tenantmanagement-8b61d.appspot.com/o/b4.png?alt=media&token=dcbcb1f9-97da-43ad-b157-ee6f24047a5f'
  ];
  var propertyzip = TextEditingController();
  var _selected1 = true;
  var _selected2 = false;
  var _selected3 = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = ref.watch(ownerDataProvider)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'Add Property',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.05),
              child: TextController(
                  hint: 'Property Name', controller: propertyname),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.05),
              child: TextController(
                  hint: 'Property Area', controller: propertyarea),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.05),
              child: TextController(
                  hint: 'Property City', controller: propertycity),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.05),
              child: SizedBox(
                  child: TextController(
                      hint: 'Property State', controller: propertystate)),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.05),
              child: TextController(
                hint: 'Property Zip',
                controller: propertyzip,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: size.width * 0.3,
                    child: SelectableContainer(
                        selected: _selected1,
                        onValueChanged: (value) => setState(() {
                              _selected1 = value;
                              _selected2 = false;
                              _selected3 = false;
                            }),
                        child: Image(
                          image: NetworkImage(buildingList[0]),
                        )),
                  ),
                  SizedBox(
                    width: size.width * 0.3,
                    child: SelectableContainer(
                        selected: _selected2,
                        onValueChanged: (value) {
                          setState(() {
                            _selected2 = value;
                            _selected1 = false;
                            _selected3 = false;
                          });
                        },
                        child: Image(
                          image: NetworkImage(buildingList[1]),
                        )),
                  ),
                  SizedBox(
                    width: size.width * 0.3,
                    child: SelectableContainer(
                        selected: _selected3,
                        onValueChanged: (value) => setState(
                              () {
                                _selected3 = value;
                                _selected1 = false;
                                _selected2 = false;
                              },
                            ),
                        child: Image(
                          image: NetworkImage(buildingList[2]),
                        )),
                  ),
                ],
              ),
            ),
            Text('Choose Building Image'),
            SizedBox(
              height: size.height * 0.05,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: size.width * 0.05, right: size.width * 0.05),
              child: SizedBox(
                height: size.height * 0.07,
                width: size.width * 0.9,
                child: MainButton(
                  text: 'Add Property',
                  onPressed: () {
                    if (propertyname.text.isEmpty ||
                        propertyarea.text.isEmpty ||
                        propertycity.text.isEmpty ||
                        propertystate.text.isEmpty ||
                        propertyzip.text.isEmpty) {
                      Utils.showSnackBar('Please fill all the fields');
                    } else {
                      var i;
                      if (_selected1 == true) {
                        i = buildingList[0];
                      } else if (_selected2 == true) {
                        i = buildingList[1];
                      } else if (_selected3 == true) {
                        i = buildingList[2];
                      }
                      ref.read(ownerControllerProvider.notifier).addProperty(
                            context: context,
                            propertyname: propertyname.text,
                            propertyarea: propertyarea.text,
                            propertycity: propertycity.text,
                            propertystate: propertystate.text,
                            userpropertylist: user.propertyList??[],
                            propertyzipcode: propertyzip.text,
                            propertyimage: i,
                          );
                      update() async {
                        var a = await ref
                            .read(ownerControllerProvider.notifier)
                            .getPropertyData(user.id!)
                            .first;
                        ref
                            .read(propertyDataProvider.notifier)
                            .update((state) => a);
                      }

                      update();
                      Routemaster.of(context).history.back();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
