import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/tenant/components/complaints_status_pending.dart';
import 'package:tenantmgmnt/features/tenant/controller/tenant_user_controller.dart';
import 'package:tenantmgmnt/themes/colors.dart';

import '../../components/custom_app_bar.dart';

class ComplaintsHome extends ConsumerStatefulWidget {
  const ComplaintsHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ComplaintsHomeState();
}

class _ComplaintsHomeState extends ConsumerState<ComplaintsHome> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var user = ref.watch(tenantDataProvider)!;
    if(user.flatId == ''){
      return Scaffold(
        backgroundColor: appBackgroundColor,
        appBar: CustomAppBar(
          title: 'all complaints'
        ),
        body: Center(
          child: Text('Flat is not assinged yet'),
        ),
      );
    }
    var complaints = ref.watch(complaintDataProvider)!;
    return Scaffold(
      backgroundColor: appBackgroundColor,
      appBar: CustomAppBar(
        title: 'all complaints'
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // create a list builder of all complaints and display them in a status list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: complaints.length,
              itemBuilder: (context, index) {
              return ListTile(
                onTap: (){
                  Routemaster.of(context).push('/complaintdetails', queryParameters: {
                    'complaintId': complaints[index].id,
                    'subject': complaints[index].subject,
                    'description': complaints[index].description,
                    'status': complaints[index].status,
                    'createdAt': complaints[index].createdAt.toString(),
                  });
                },
                title: Text(complaints[index].subject),
                subtitle: Text(complaints[index].description, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: ComplaintStatusControllerComponentPending(
                  size: size,
                  complaintid: complaints[index].id,
                  status: complaints[index].status,
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}