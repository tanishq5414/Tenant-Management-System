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

import '../../../modal/complaints_modal.dart';

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
      flatList: [],
      complaintList: [],
      rentDue: '',
      rentRecieved: '',
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
  FutureEither<Property> addProperty(
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
    var propertyid = const Uuid().v4();
    propertyList.add(propertyid);
    Property property = Property(
      id: propertyid,
      ownerId: user.uid,
      name: propertyName,
      area: propertyArea,
      city: propertyCity,
      state: propertyState,
      zip: propertyZip,
      tenants: [],
      image: propertyimage,
      flats: [],
    );
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
    if (response.status != 204) {
      print('error in adding property');
      return left(Failure(response.data));
    }
    print('response status' + response.status.toString());
    return right(property);
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
  FutureEither<String> removeTenant(
    BuildContext context,
    ownerid,
    propertyid,
    tenantid,
    flatid,
  ) async {
    var response = await _supabaseClient.rpc('remove_tenant', params: {
      'ownerid': ownerid,
      'propertyid': propertyid,
      'tenantid': tenantid,
      'flatid': flatid,
    }).then((value) {
    });
    if(response == null){
      return right(tenantid);
    }
    else{
      return left(Failure('error in removing tenant'));
    }
  }

  // add tenant
  FutureEither<String> addTenant(
    BuildContext context,
    ownerid,
    propertyid,
    tenantid,
    flatid,
  ) async {
    
    var response = await _supabaseClient.rpc('add_tenant', params: {
      'ownerid': ownerid,
      'propertyid': propertyid,
      'tenantid': tenantid,
      'flatid': flatid,
    }).then((value) {
    });
    if(response == null){
      return right(tenantid);
    }
    else{
      return left(Failure('error in adding tenant'));
    }
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
    return a;
  }

  Stream<List<Complaint>> getComplaintsData(String uid) {
    //get full table from supabase
    return _supabaseClient
        .from('complaints')
        .stream(primaryKey: ['id'])
        .eq('ownerId', uid)
        .order('createdAt', ascending: false)
        .limit(10)
        .execute()
        .map(
          (maps) => maps
              .map(
                (map) => Complaint(
                  id: map['id'],
                  ownerId: map['ownerId'],
                  subject: map['subject'],
                  images: map['images'] ?? '',
                  flatId: map['flatId'],
                  tenantId: map['tenantId'],
                  description: map['description'],
                  status: map['status'],
                  createdAt: map['createdAt'],
                ),
              )
              .toList(),
        );
  }

  Stream<OwnerModal> getOwnerData(String uid) {
    print('get owner data called');
    Stream<OwnerModal> user;
    print(uid);
    user = _supabaseClient
        .from('owner')
        .stream(primaryKey: ['id'])
        .eq('id', uid)
        .map((event) {
          print(event);
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
              flatList: event.elementAt(0)['flatList'],
              complaintList: event.elementAt(0)['complaintList'],
              rentDue: event.elementAt(0)['rentDue'],
              rentRecieved: event.elementAt(0)['rentRecieved'],
              tenantList: event.elementAt(0)['tenantList']);
        });
    return user;
  }

  // add Flats
  FutureEither<FlatsModal> addFlat(
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
  ) async {
    var flatid = Uuid().v4();
    print('flatid' + flatid);
    var flat = FlatsModal(
        id: flatid,
        name: name,
        description: description,
        tenantId: tenantId,
        rent: rent,
        deposit: deposit,
        due: due,
        complaints: complaints,
        payments: payments,
        propertyId: propertyid,
        ownerId: ownerid,
        lastPaymentDate: '');
    var response = await _supabaseClient.from('flats').insert([
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
    print(flatlist);
    print('flatlist' + flatlist.toString());

    var response1 = await _supabaseClient
        .from('property')
        .update({
          'flats': flatlist,
        })
        .eq('id', propertyid)
        .execute();
    print(response1.data);
    print(response.status);
    print(response1.status);
    if (response.status == 201 && response1.status == 204) {
      return right(flat);
    } else {
      return left(Failure('Something went wrong'));
    }
  }

  //get tenant data
  Future<Tenant> getTenantDataByNumber(String tenantnumber) async {
    //get full table from supabase
    var a = await _supabaseClient
        .from('tenant')
        .select()
        .eq('phone', tenantnumber)
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
    return a;
  }

  Stream<List<FlatsModal>> getAllFlatsData(String ownerid) {
    //get full table from supabase
    return _supabaseClient
        .from('flats')
        .stream(primaryKey: ['id'])
        .eq('ownerId', ownerid)
        .execute()
        .map(
          (maps) => maps
              .map(
                (map) => FlatsModal(
                  id: map['id'],
                  name: map['name'],
                  description: map['description'],
                  tenantId: map['tenantId'] ?? "",
                  rent: map['rent'],
                  deposit: map['deposit'],
                  due: map['due'] ?? "",
                  lastPaymentDate: map['lastPaymentDate'] ?? "",
                  complaints: map['complaints'],
                  payments: map['payments'],
                  propertyId: map['propertyId'],
                  ownerId: map['ownerId'],
                ),
              )
              .toList(),
        );
  }

  
}
