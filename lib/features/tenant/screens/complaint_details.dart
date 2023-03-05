import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../components/complaints_status_pending.dart';
import '../../components/custom_app_bar.dart';

class ComplaintDetails extends ConsumerStatefulWidget {
  const ComplaintDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ComplaintDetailsState();
}

class _ComplaintDetailsState extends ConsumerState<ComplaintDetails> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var args = Routemaster.of(context).currentRoute.queryParameters;
    return Scaffold(
      appBar: CustomAppBar(title: 'complaint details'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              size.width * 0.05, size.width * 0.1, size.width * 0.05, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Complaint Id:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(args['complaintId']??'',
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
              Row(
                children: [
                  const Text(
                    'Created At:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(args['createdAt']??'',
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
              SizedBox(height: size.width * 0.04),
              const Text(
                'STATUS',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: size.width * 0.01),
              ComplaintStatusControllerComponentPending(
                size: size,
                complaintid: args['complaintId']??'',
                status: args['status']??'',	
              ),
              SizedBox(height: size.width * 0.04),
              const Text(
                'SUBJECT',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(args['subject']??'', style: const TextStyle(fontSize: 20)),
              SizedBox(height: size.width * 0.04),
              const Text(
                'DESCRIPTION',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(args['description']??'', style: const TextStyle(fontSize: 13)),
              SizedBox(height: size.width * 0.04),
              
              SizedBox(height: size.width * 0.01),
              // container for status
            ],
          ),
        ),
      ),
    );
  }
}

