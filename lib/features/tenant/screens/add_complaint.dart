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
import 'package:tenantmgmnt/features/tenant/controller/tenant_user_controller.dart';
import 'package:tenantmgmnt/themes/colors.dart';

class AddComplaints extends ConsumerStatefulWidget {
  AddComplaints({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddComplaints();
}

class _AddComplaints extends ConsumerState<AddComplaints> {
  var complaintsubject = TextEditingController();
  var complaintdescription = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = ref.watch(tenantDataProvider)!;
    final flatsdata = ref.watch(flatDataProvider);
    return (flatsdata != null)?Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'add a complaint',
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
            child: TextController(
                hint: 'Enter subject', controller: complaintsubject),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.05, right: size.width * 0.05),
            child: TextController(
                maxlines: null,
                minlines: 8,
                hint: 'Complaint Description',
                controller: complaintdescription),
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.05, right: size.width * 0.05),
            child: SizedBox(
              height: size.height * 0.07,
              width: size.width * 0.9,
              child: MainButton(
                text: 'Add Complaint',
                onPressed: () {
                  ref.read(tenantControllerProvider.notifier).addComplaint(
                      subject: complaintsubject.text.trim(),
                      description: complaintdescription.text.trim(),
                      flatId: user.flatId,
                      tenantId: user.id,
                      ownerId: flatsdata.ownerId);
                    setState(() {
                      
                    });
                  // var a = ref
                  //     .read(tenantControllerProvider.notifier)
                  //     .getComplaintDetails(flatsdata.id).first;
                  // ref.read(complaintDataProvider.notifier).update((state) => a);
                  Routemaster.of(context).history.back();
                },
              ),
            ),
          ),
        ],
      ),
    ):Scaffold(
        backgroundColor: appBackgroundColor,
        appBar: CustomAppBar(
          title: 'add a complaint'
        ),
        body: const Center(
          child: Text('Flat is not assigned yet'),
        ),
      );
  }
}
