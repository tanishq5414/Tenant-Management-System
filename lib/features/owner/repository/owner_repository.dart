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
    var response = await _supabaseClient.rpc('insertownerdetails', params: {
      'id': user.uid,
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'phone': phone,
      'address': ' ',
      'city': ' ',
      'state': ' ',
      'zip': ' ',
      'country': ' ',
    }).execute();
    print(response.data);
    if (response.data != null) {
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

  Stream<List<Property>> getPropertyData(String uid) {
    //get full table from supabase
    return _supabaseClient
        .from('property')
        .stream(primaryKey: ['id'])
        .eq('ownerId', uid)
        .order('createdAt', ascending: false)
        .execute()
        .map(
          (maps) => maps
              .map(
                (map) => Property(
                  id: map['id'],
                  ownerId: map['ownerId'],
                  name: map['name'],
                  area: map['area'],
                  city: map['city'],
                  state: map['state'],
                  zip: map['zip'],
                  tenants: map['tenants'],
                  image: map['image'],
                  flats: map['flats'],
                ),
              )
              .toList(),
        );
  }

  // remove tenant
  void removeTenant(
    BuildContext context,
    ownerid,
    propertyid,
    tenantid,
    flatid,
  ) async {
    _supabaseClient.rpc('remove_tenant', params: {
      'ownerid': ownerid,
      'propertyid': propertyid,
      'tenantid': tenantid,
      'flatid': flatid,
    }).then((value) {
      if (value.error != null) {
        print(value.error!.message);
      } else {
        print(value.data);
      }
    });
  }

  // add tenant
  void addTenant(
    BuildContext context,
    ownerid,
    propertyid,
    tenantid,
    flatid,
  ) async {
    _supabaseClient.rpc('add_tenant', params: {
      'ownerid': ownerid,
      'propertyid': propertyid,
      'tenantid': tenantid,
      'flatid': flatid,
    }).then((value) {
      if (value.error != null) {
        print(value.error!.message);
      } else {
        print(value.data);
      }
    });
  }

  //get tenant data
  Future<Tenant> getTenantData(String tenantid) async {
    //get full table from supabase

    var a = await _supabaseClient
        .from('tenant')
        .select()
        .eq('id', tenantid)
        .execute()
        .then((value) => Tenant(
              id: value.data[0]['id'],
              firstName: value.data[0]['firstName'],
              lastName: value.data[0]['lastName'],
              email: value.data[0]['email'],
              phone: value.data[0]['phone'],
              address: value.data[0]['address'],
              city: value.data[0]['city'],
              state: value.data[0]['state'],
              zip: value.data[0]['zip'],
              country: value.data[0]['country'],
              transactions: value.data[0]['transactions'],
              complaints: value.data[0]['complaints'],
              flatId: value.data[0]['flat_id'],
            ));
    print(a.runtimeType);
    return a;
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
    String ownerid,
  ) {
    var flatid = Uuid().v4();
    print('flatid' + flatid);
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
        'ownerId': ownerid,
      }
    ]).execute();
    flatlist.add(flatid);
    print('flatlist' + flatlist.toString());

    var response1 = _supabaseClient
        .from('property')
        .update({
          'flats': flatlist,
        })
        .eq('id', propertyid)
        .execute();
  }

  FutureEither<FlatsModal> getSingleFlatData(String flatid) async {
    var response1 =
        await _supabaseClient.from('flats').select().eq('id', flatid).execute();
    if (response1.data == null) {
      return left(Failure(response1.data));
    }
    return right(FlatsModal(
        id: response1.data.elementAt(0)['id'],
        name: response1.data.elementAt(0)['name'],
        description: response1.data.elementAt(0)['description'],
        tenantId: response1.data.elementAt(0)['tenantId'],
        rent: response1.data.elementAt(0)['rent'],
        deposit: response1.data.elementAt(0)['deposit'],
        due: response1.data.elementAt(0)['due'],
        lastPaymentDate: response1.data.elementAt(0)['lastPaymentDate'],
        complaints: response1.data.elementAt(0)['complaints'],
        payments: response1.data.elementAt(0)['payments'],
        propertyId: response1.data.elementAt(0)['propertyId'],
        ownerId: response1.data.elementAt(0)['ownerId']));
  }

  Future<List<FlatsModal>> getFlatData(String propertyid) async {
    List<FlatsModal> flatlist = [];
    var a = await _supabaseClient
        .from('flats')
        .select()
        .eq('propertyId', propertyid)
        .execute()
        .then((value) => value.data);
    for (var i = 0; i < a.length; i++) {
      flatlist.add(
        FlatsModal(
          id: a.elementAt(i)['id'],
          name: a.elementAt(i)['name'],
          description: a.elementAt(i)['description'],
          tenantId: a.elementAt(i)['tenantId'],
          rent: a.elementAt(i)['rent'],
          deposit: a.elementAt(i)['deposit'],
          due: a.elementAt(i)['due'],
          lastPaymentDate: a.elementAt(i)['lastPaymentDate'],
          complaints: a.elementAt(i)['complaints'],
          payments: a.elementAt(i)['payments'],
          propertyId: a.elementAt(i)['propertyId'],
          ownerId: a.elementAt(i)['ownerId'],
        ),
      );
    }
    print(flatlist);
    return flatlist;
  }
}
