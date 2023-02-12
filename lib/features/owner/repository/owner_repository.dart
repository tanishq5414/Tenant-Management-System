// ignore_for_file: depend_on_referenced_packages, unused_import, use_build_context_synchronously, unused_local_variable, deprecated_member_use

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod/riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:tenantmgmnt/core/failure.dart';
import 'package:tenantmgmnt/core/providers/providers.dart';
import 'package:tenantmgmnt/core/type_def.dart';
import 'package:tenantmgmnt/features/auth/showOtp.dart';
import 'package:tenantmgmnt/features/components/snack_bar.dart';
import 'package:tenantmgmnt/modal/flats_modal.dart';
import 'package:tenantmgmnt/modal/owner_modal.dart';
import 'package:tenantmgmnt/modal/property_modal.dart';
import 'package:tenantmgmnt/modal/tenant_modal.dart';
import 'package:uuid/uuid.dart';

final ownerRepositoryProvider = Provider(
  (ref) => OwnerRepository(
    supabaseClient: ref.read(supabaseProvider),
    auth: ref.read(authProvider),
  ),
);

class OwnerRepository {
  OwnerRepository({
    required supabase.SupabaseClient supabaseClient,
    required FirebaseAuth auth,
  })  : _auth = auth,
        _supabaseClient = supabaseClient;

  final FirebaseAuth _auth;
  final supabase.SupabaseClient _supabaseClient;

  User get user => _auth.currentUser!;

  Stream<User?> get authStateChange => _auth.authStateChanges();
  FutureEither<OwnerModal> insertOwnerFirstDetails(
    BuildContext context,
    String firstName,
    String lastName,
    String email,
    String phone,
    String typeofuser,
  ) async {
    final user = _auth.currentUser!;

    user.updateProfile(displayName: firstName + ' ' + lastName);
    OwnerModal user1 = OwnerModal(
      id: user.uid,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: '',
      city: '',
      state: '',
      zip: '',
      country: '',
      propertyList: [],
      tenantList: [],
    );
    var response = await _supabaseClient.from('owner').insert([
      {
        'id': user.uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'address': '',
        'city': '',
        'state': '',
        'zip': '',
        'country': '',
        'propertyList': [],
      }
    ]).execute();
    if (response != null) {
      return left(Failure(response.data));
    }
    return right(user1);
  }

  // add properties
  void addProperty(
    BuildContext context,
    List propertyList,
    String propertyName,
    String propertyArea,
    String propertyCity,
    String propertyState,
    String propertyZip,
    String propertyimage,
  ) async {
    final user = _auth.currentUser!;
    var propertyid = Uuid().v4();
    propertyList.add(propertyid);
    var response1 = await _supabaseClient.from('property').insert([
      {
        'id': propertyid,
        'ownerId': user.uid,
        'name': propertyName,
        'area': propertyArea,
        'city': propertyCity,
        'state': propertyState,
        'zip': propertyZip,
        'tenants': [],
        'image': propertyimage,
        'flats': [],
      }
    ]).execute();
    var response = await _supabaseClient
        .from('owner')
        .update({
          'propertyList': propertyList,
        })
        .eq('id', user.uid)
        .execute();
  }

  FutureEither<List<Property>> getPropertyData(String uid) async {
    //get full table from supabase
    List<Property> propertyList = [];
    print('tanishq');
    var response = await _supabaseClient
        .from('property')
        .select()
        .eq('ownerId', uid)
        .execute()
        .then((value) {
      print(value.data);
      List data = value.data;
      var n = data.length;
      print(n);
      for (int i = 0; i < n; i++) {
        propertyList.add(Property(
          id: value.data[i]['id'],
          ownerId: value.data[i]['ownerId'],
          name: value.data[i]['name'],
          area: value.data[i]['area'],
          city: value.data[i]['city'],
          state: value.data[i]['state'],
          flats: value.data[i]['flats']??[],
          zip: value.data[i]['zip'],
          tenants: value.data[i]['tenants'],
          image: value.data[i]['image'],
        ));
      }
    });
    print('agarwal');
    if (response != null) {
      return left(Failure(response.data));
    }
    // print(propertyList);
    return right(propertyList);
  }

  Stream<OwnerModal> getOwnerData(String uid) {
    Stream<OwnerModal> user;
    user = _supabaseClient
        .from('owner')
        .stream(primaryKey: ['id'])
        .eq('id', uid)
        .map((event) {
          return OwnerModal(
              id: event.elementAt(0)['id'],
              firstName: event.elementAt(0)['firstName'],
              lastName: event.elementAt(0)['lastName'],
              email: event.elementAt(0)['email'],
              phone: event.elementAt(0)['phone'],
              address: event.elementAt(0)['address'],
              city: event.elementAt(0)['city'],
              state: event.elementAt(0)['state'],
              zip: event.elementAt(0)['pincode'],
              country: event.elementAt(0)['country'],
              propertyList: event.elementAt(0)['propertyList'],
              tenantList: event.elementAt(0)['tenantList']);
        });
    return user;
  }

  // add Flats
  void addFlat(
    BuildContext context,
    String name,
    String description,
    String tenantId,
    String rent,
    String deposit,
    String due,
    List complaints,
    List payments,
    List flatlist,
    String propertyid,
  ) {
    var flatid = Uuid().v4();
    flatlist.add(flatid);
    var response = _supabaseClient.from('flats').insert([
      {
        'id': flatid,
        'name': name,
        'description': description,
        'tenantId': tenantId,
        'rent': rent,
        'deposit': deposit,
        'due': due,
        'complaints': complaints,
        'payments': payments,
        'propertyId': propertyid,
      }
    ]).execute();

    var response1 = _supabaseClient
        .from('property')
        .update({
          'flats': flatlist,
        })
        .eq('id', 'propertyid')
        .execute();
  }

  getFlatData(context, String propertyid) {
    // Stream<List<FlatsModal>> flatlist = [];

    var response1 = _supabaseClient
        .from('flats')
        .stream(primaryKey: ['id'])
        .eq('id', propertyid)
        .map(
          (event) => event.map((e) => print(e)),
        );
    // var response = await _supabaseClient
    //     .from('flats')
    //     .select()
    //     .eq('id', 'flatid')
    //     .then((value) => {
    //           for (var i = 0; i < value.data.length; i++)
    //             {
    //               flatlist.add(FlatsModal(
    //                 id: value.data[i]['id'],
    //                 name: value.data[i]['name'],
    //                 description: value.data[i]['description'],
    //                 TenantId: value.data[i]['tenantId'],
    //                 Rent: value.data[i]['rent'],
    //                 Deposit: value.data[i]['deposit'],
    //                 Due: value.data[i]['due'],
    //                 Complaints: value.data[i]['complaints'],
    //                 Payments: value.data[i]['payments'],
    //               ))
    //             }
    //         });
    // if (response != null) {
    //   return left(Failure(response.toString()));
    // }
    // return right(flatlist);
  }
}
