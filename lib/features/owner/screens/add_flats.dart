import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:selectable_container/selectable_container.dart';
import 'package:tenantmgmnt/features/auth/components/main_button.dart';
import 'package:tenantmgmnt/features/auth/controller/auth_controller.dart';
import 'package:tenantmgmnt/features/components/text_controller.dart';
import 'package:tenantmgmnt/features/components/custom_app_bar.dart';
import 'package:tenantmgmnt/features/owner/controller/owner_controller.dart';

class AddFlats extends ConsumerStatefulWidget {
  var propertyId;
  List propertyList;

  AddFlats({super.key, this.propertyId, required this.propertyList});

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
                hint: 'Flat Description', controller: flatdeposit),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.05, right: size.width * 0.05),
            child: TextController(hint: 'Flat Rent', controller: flatrent),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.05, right: size.width * 0.05),
            child: SizedBox(
                child: TextController(
                    hint: 'Flat Deposit', controller: flatdescription)),
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
                  ref.read(ownerControllerProvider.notifier).addFlat(
                      context: context,
                      flatname: flatname.text,
                      description: flatdescription.text,
                      tenantid: '',
                      rent: flatrent.text,
                      deposit: flatdeposit.text,
                      due: '',
                      complaint: [],
                      payments: [],
                      flatlist: [],
                      propertyid: widget.propertyId);

                  Routemaster.of(context).popUntil((routeData) => false);
                  Routemaster.of(context).push('/propertyhome');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
