// ignore_for_file: depend_on_referenced_packages, unused_import, use_build_context_synchronously, unused_local_variable, deprecated_member_use

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod/riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:tenantmgmnt/core/failure.dart';
import 'package:tenantmgmnt/core/providers/providers.dart';
import 'package:tenantmgmnt/core/type_def.dart';
import 'package:tenantmgmnt/features/auth/controller/auth_controller.dart';
import 'package:tenantmgmnt/features/auth/showOtp.dart';
import 'package:tenantmgmnt/features/components/snack_bar.dart';
import 'package:tenantmgmnt/features/tenant/controller/tenant_user_controller.dart';
import 'package:tenantmgmnt/modal/complaints_modal.dart';
import 'package:tenantmgmnt/modal/flats_modal.dart';
import 'package:tenantmgmnt/modal/owner_modal.dart';
import 'package:tenantmgmnt/modal/property_modal.dart';
import 'package:tenantmgmnt/modal/tenant_modal.dart';
import 'package:uuid/uuid.dart';

final tenantRepositoryProvider = Provider(
  (ref) => TenantRepository(
    supabaseClient: ref.read(supabaseProvider),
    auth: ref.read(authProvider),
  ),
);

class TenantRepository {
  TenantRepository({
    required supabase.SupabaseClient supabaseClient,
    required FirebaseAuth auth,
  })  : _auth = auth,
        _supabaseClient = supabaseClient;

  final FirebaseAuth _auth;
  final supabase.SupabaseClient _supabaseClient;

  User get user => _auth.currentUser!;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  // get tenant details

  Stream<FlatsModal> getFlatDetails(String id) {
    final response = _supabaseClient
        .from('flats')
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map(
          (event) {
            return FlatsModal(
              id: event.elementAt(0)['id'],
              propertyId: event.elementAt(0)['propertyId'],
              ownerId: event.elementAt(0)['ownerId'],
              rent: event.elementAt(0)['rent'],
              deposit: event.elementAt(0)['deposit'],
              tenantId: event.elementAt(0)['tenantId'] ?? "",
              name: event.elementAt(0)['name'],
              description: event.elementAt(0)['description'],
              due: event.elementAt(0)['due'],
              complaints: event.elementAt(0)['complaints'],
              payments: event.elementAt(0)['payments'],
              lastPaymentDate: event.elementAt(0)['lastPaymentDate'],
            );
          },
        );
    return response;
  }

  // add complaints to flat
  void addComplaint({
    required String tenantId,
    required String ownerId,
    required String flatId,
    required String subject,
    required String description,
  }) async {
    final user = _auth.currentUser!;
    var complaintid = const Uuid().v4();
    await _supabaseClient.rpc('add_complaint', params: {
      'complaintid': complaintid,
      'tenantid': tenantId,
      'ownerid': ownerId,
      'flatid': flatId,
      'subject': subject,
      'description': description,
      'createdat': DateTime.now().toString(),
      'status': 'pending',
      'images': '',
    }).then((value) {
      print(value);
      if (value != null) {
        Utils.showSnackBar('Complaint was not added');
      } else {
        Utils.showSnackBar('Complaint added successfully');
      }
    });
  }

  // get Complaints
  Stream<List<Complaint>> getComplaints(String flatId) {
    return _supabaseClient
        .from('complaints')
        .stream(primaryKey: ['id'])
        .eq('flatId', flatId)
        .order('createdAt', ascending: false)
        .execute()
        .map(
          (maps) => maps
              .map(
                (map) => Complaint(
                  id: map['id'],
                  tenantId: map['tenantId'],
                  ownerId: map['ownerId'],
                  flatId: map['flatId'],
                  subject: map['subject'],
                  description: map['description'],
                  createdAt: map['createdAt'],
                  status: map['status'],
                  images: map['images'],
                ),
              )
              .toList(),
        );
  }

  // change complaint status
  void changeComplaintStatus({
    required String complaintId,
    required String changedstatus,
  }) async {
    await _supabaseClient.rpc('change_complaint_status', params: {
      'complaintid': complaintId,
      'changedstatus': changedstatus,
    }).then((value) {
      print(value);
      if (value != null) {
        Utils.showSnackBar('Complaint status was not changed');
      } else {
        Utils.showSnackBar('Complaint status changed successfully');
      }
    });
  }

  Stream<Tenant> getTenantDetails(String uid) {
    //subscribe to the tabl
    return _supabaseClient
        .from('tenant')
        .stream(primaryKey: ['id'])
        .eq('id', uid)
        .map((event) => Tenant(
              id: event.elementAt(0)['id'],
              firstName: event.elementAt(0)['firstName'],
              lastName: event.elementAt(0)['lastName'],
              email: event.elementAt(0)['email'],
              phone: event.elementAt(0)['phone'],
              address: event.elementAt(0)['address'],
              city: event.elementAt(0)['city'],
              state: event.elementAt(0)['state'],
              country: event.elementAt(0)['country'],
              zip: event.elementAt(0)['zip'],
              flatId: event.elementAt(0)['flat_id'],
              transactions: event.elementAt(0)['transactions'] ?? [],
              complaints: event.elementAt(0)['complaints'] ?? [],
            ));
  }

  void signOut(context) async {
    await _auth.signOut();
  }
}
