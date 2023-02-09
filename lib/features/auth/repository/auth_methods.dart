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
import 'package:tenantmgmnt/modal/owner_modal.dart';
import 'package:tenantmgmnt/modal/property_modal.dart';
import 'package:tenantmgmnt/modal/tenant_modal.dart';
import 'package:uuid/uuid.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    supabaseClient: ref.read(supabaseProvider),
    auth: ref.read(authProvider),
  ),
);

class AuthRepository {
  AuthRepository({
    required supabase.SupabaseClient supabaseClient,
    required FirebaseAuth auth,
  })  : _auth = auth,
        _supabaseClient = supabaseClient;

  final FirebaseAuth _auth;
  final supabase.SupabaseClient _supabaseClient;

  User get user => _auth.currentUser!;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  // Phone sign up
  Future<void> phoneSignIn(
    BuildContext context,
    String phoneNumber,
  ) async {
    TextEditingController codeController = TextEditingController();
    if (kIsWeb) {
      // !!! Works only on web !!!
      ConfirmationResult result =
          await _auth.signInWithPhoneNumber(phoneNumber);
      void onPressed() async {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: result.verificationId,
          smsCode: codeController.text.trim(),
        );
        await _auth.signInWithCredential(credential);
        Routemaster.of(context).pop(); // Remove the dialog box
      }

      Routemaster.of(context).push(
          '/otpscreen/?codecontroller=$codeController&onPressed=$onPressed()');
    } else {
      // FOR ANDROID, IOS
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        //  Automatic handling of the SMS code
        verificationCompleted: (PhoneAuthCredential credential) async {
          // !!! works only on android !!!
          await _auth.signInWithCredential(credential);
        },
        // Displays a message when verification fails
        verificationFailed: (e) {
          Utils.showSnackBar(e.message!);
        },
        // Displays a dialog box when OTP is sent
        codeSent: ((String verificationId, int? resendToken) async {
          showOTPDialog(
              codeController: codeController,
              context: context,
              onPressed: () async {
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: codeController.text.trim(),
                );

                // !!! Works only on Android, iOS !!!
                var usercredential =
                    await _auth.signInWithCredential(credential);
                Routemaster.of(context).pop(); // Remove the dialog box
                if (usercredential.additionalUserInfo!.isNewUser) {
                  Routemaster.of(context).push('/signupdata');
                } else {
                  Routemaster.of(context).push('/');
                }
              });
        }),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
    }
  }

  FutureEither<Tenant> insertTenantFirstDetails(
    BuildContext context,
    String firstName,
    String lastName,
    String email,
    String phone,
    String typeofuser,
  ) async {
    final user = _auth.currentUser!;
    user.updateProfile(displayName: firstName + ' ' + lastName);
    // user.updateEmail(email);
    Tenant user1 = Tenant(
      id: user.uid,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: user.phoneNumber,
    );
    var response = await _supabaseClient.from('tenant').insert([
      {
        'id': user.uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': user.phoneNumber,
      }
    ]).execute();
    print(response.data);
    return right(user1);
  }

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

  void signOut() async {
    await _auth.signOut();
    await _supabaseClient.auth.signOut();
  }

  void addProperty(
    BuildContext context,
    List propertyList,
    String propertyName,
    String propertyCity,
    String propertyState,
    String propertyZip,
  ) async {
    final user = _auth.currentUser!;
    var propertyid = Uuid().v4();
    print(propertyid);
    propertyList.add(propertyid);
    var response1 = await _supabaseClient.from('property').insert([
      {
        'id': propertyid,
        'ownerId': user.uid,
        'name': propertyName,
        'city': propertyCity,
        'state': propertyState,
        'zip': propertyZip,
        'tenants': [],
      }
    ]).execute();
    var response = await _supabaseClient
        .from('owner')
        .update({
          'propertyList': propertyList,
        })
        .eq('id', user.uid)
        .execute();

    print(response.data);
  }

  FutureEither<List<Property>> getPropertyData(String uid) async {
    //get full table from supabase
    List<Property> propertyList = [];
    var response = await _supabaseClient
        .from('property')
        .select()
        .eq('ownerId', uid)
        .execute()
        .then((value) {
      for (var i = 0; i < value.data.length; i++) {
        propertyList.add(Property(
          id: value.data[i]['id'],
          ownerId: value.data[i]['ownerId'],
          name: value.data[i]['name'],
          city: value.data[i]['city'],
          state: value.data[i]['state'],
          zip: value.data[i]['zip'],
          tenants: value.data[i]['tenants'],
        ));
      }
    });
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
}
