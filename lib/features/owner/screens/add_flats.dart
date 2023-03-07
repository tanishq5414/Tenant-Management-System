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
import 'package:tenantmgmnt/modal/property_modal.dart';

class AddFlats extends ConsumerStatefulWidget {
  var propertyId;

  AddFlats({super.key, this.propertyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPropertyState();
}

class _AddPropertyState extends ConsumerState<AddFlats> {
  var flatname = TextEditingController();
  var flatdescription = TextEditingController();
  var flatrent = TextEditingController();
  var flatdeposit = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = ref.watch(ownerDataProvider)!;
    final property = ref.watch(propertyDataProvider)!;
    int propertyIndex = property.indexWhere((element) => element.id == widget.propertyId);
    final Property propertyData = property[propertyIndex];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'Add Flats',
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
            child: TextController(hint: 'Flat Name', controller: flatname),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.05, right: size.width * 0.05),
            child: TextController(
                hint: 'Flat Description', controller: flatdescription),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.05, right: size.width * 0.05),
            child: TextController(
              hint: 'Flat Rent',
              controller: flatrent,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.05, right: size.width * 0.05),
            child: SizedBox(
                child: TextController(
                    hint: 'Flat Deposit', controller: flatdeposit, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly],)),
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
                text: 'Add Flat',
                onPressed: () {
                  if(flatname.text.isEmpty || flatdescription.text.isEmpty || flatrent.text.isEmpty || flatdeposit.text.isEmpty){
                    Utils.showSnackBar('Please fill all the fields');
                    return;
                  }
                  ref.read(ownerControllerProvider.notifier).addFlat(
                      context: context,
                      ownerid: user.id!,
                      flatname: flatname.text,
                      description: flatdescription.text,
                      tenantid: '',
                      rent: flatrent.text,
                      deposit: flatdeposit.text,
                      due: '',
                      complaint: [],
                      payments: [],
                      flatlist: propertyData.flats,
                      propertyid: widget.propertyId);

                  Routemaster.of(context).history.back();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
