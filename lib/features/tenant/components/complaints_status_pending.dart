// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tenantmgmnt/features/tenant/controller/tenant_user_controller.dart';

class ComplaintStatusControllerComponentPending extends ConsumerStatefulWidget {
  const ComplaintStatusControllerComponentPending({
    Key? key,
    required this.size,
    required this.complaintid,
    required this.status,
  }) : super(key: key);

  final Size size;
  final String complaintid;
  final String status;

  @override
  ConsumerState<ComplaintStatusControllerComponentPending> createState() =>
      _ComplaintStatusControllerComponentState();
}

class _ComplaintStatusControllerComponentState
    extends ConsumerState<ComplaintStatusControllerComponentPending> {
  var pendingflag;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.status == 'solved') {
      pendingflag = false;
    }else{
      pendingflag = true;
    }
  }

  //dispose
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // dispose the controller
    pendingflag = null;
  }

  @override
  Widget build(BuildContext context) {
    return (pendingflag == true)?InkWell(
      onTap: () {
        // show a dialog box for changing the status
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Change Status'),
              content:
                  Text('Are you sure you want to change the status to solved?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    ref
                        .read(tenantControllerProvider.notifier)
                        .changeComplaintStatus(
                          complaintid: widget.complaintid,
                          changedstatus: 'solved',
                        );
                    setState(() {
                      pendingflag = false;
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(widget.size.width * 0.02),
        decoration: BoxDecoration(
          color: (pendingflag = true)
              ? Colors.red.withOpacity(0.2)
              : Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          "pending",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    ):InkWell(
      onTap: () {
        // show a dialog box for changing the status
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Change Status'),
              content:
                  const Text('Are you sure you want to change the status to pending?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    ref
                        .read(tenantControllerProvider.notifier)
                        .changeComplaintStatus(
                          complaintid: widget.complaintid,
                          changedstatus: 'pending',
                        );
                    setState(() {
                      pendingflag = false;
                    });
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(widget.size.width * 0.02),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          "solved",
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
