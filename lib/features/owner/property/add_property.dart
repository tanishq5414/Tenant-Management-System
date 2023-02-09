import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/auth/components/main_button.dart';
import 'package:tenantmgmnt/features/auth/controller/auth_controller.dart';
import 'package:tenantmgmnt/features/components/text_controller.dart';
import 'package:tenantmgmnt/features/components/custom_app_bar.dart';

class AddProperty extends ConsumerStatefulWidget {
  const AddProperty({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPropertyState();
}

class _AddPropertyState extends ConsumerState<AddProperty> {
  var propertyname = TextEditingController();
  var propertystate = TextEditingController();
  var propertycity = TextEditingController();
  var propertyzip = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = ref.watch(ownerDataProvider)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'Add Property',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: size.height * 0.05,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.05, right: size.width * 0.05),
            child:
                TextController(hint: 'Property Name', controller: propertyname),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.05, right: size.width * 0.05),
            child:
                TextController(hint: 'Property City', controller: propertycity),
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
            child:
                TextController(hint: 'Property Zip', controller: propertyzip),
          ),
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
                  ref.read(authControllerProvider.notifier).addProperty(
                        context: context,
                        propertyname: propertyname.text,
                        propertycity: propertycity.text,
                        propertystate: propertystate.text,
                        userpropertylist: user.propertyList!,
                        propertyzipcode: propertyzip.text,
                      );
                  Routemaster.of(context).popUntil((routeData) => false);
                  Routemaster.of(context).push('/ownerhome');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
