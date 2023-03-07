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
import 'package:tenantmgmnt/modal/user_type_modal.dart';
import 'package:tenantmgmnt/themes/colors.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

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
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.zero,
            elevation: 0,
            title: const Text("Enter OTP"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                OtpTextField(
                  numberOfFields: 6,
                  borderColor: appAccentColor,
                  //set to true to show as box or false to show as dash
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                  },
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) async {
                    try{
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: verificationCode,
                    );
                    var usercredential =
                        await _auth.signInWithCredential(credential);
                    Routemaster.of(context).pop(); // Remove the dialog box
                    if (usercredential.additionalUserInfo!.isNewUser) {
                      Routemaster.of(context).push('/signupdata');
                    } else {
                      Routemaster.of(context).push('/');
                    }
                    }catch(e){
                      Utils.showSnackBar('Invalid OTP');
                    }
                  }, 
                  // end onSubmit
                ),
              ],
            ),
          ),
        );
      }),
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-resolution timed out...
      },
    );
  }

  //tenant or owner sign up
  Future<UserType> tenantorowner(uid) async {
    var response = await _supabaseClient
        .from('user_details')
        .select()
        .eq('id', uid)
        .execute();
    var data = response.data as List;
    var user = data.first;
    UserType user1 = UserType(
      id: user['id'],
      user_type: user['user_type'],
    );
    return user1;
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
      phone: user.phoneNumber!,
      address: '',
      city: '',
      state: '',
      zip: '',
      country: '',
      flatId: '',
      transactions: [],
      complaints: [],
    );
    var response = await _supabaseClient.rpc('inserttenantdetails', params: {
      'id': user.uid,
      'firstname': firstName,
      'lastname': lastName,
      'email': email,
      'phone': phone,
    }).execute();
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
      flatList: [],
      complaintList: [],
      rentDue: '',
      rentRecieved: '',
    );
    // var response = await _supabaseClient.from('owner').insert([
    //   {
    //     'id': user.uid,
    //     'firstName': firstName,
    //     'lastName': lastName,
    //     'email': email,
    //     'phone': phone,
    //     'address': '',
    //     'city': '',
    //     'state': '',
    //     'zip': '',
    //     'country': '',
    //     'propertyList': [],
    //   }
    // ]).execute();
    var response = await _supabaseClient.rpc('insertownerdetails', params: {
      'id': user.uid,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': ' ',
      'city': ' ',
      'state': ' ',
      'zip': ' ',
      'country': ' ',
    }).execute();
    print(response.data);
    if (response != null) {
      return left(Failure(response.data));
    }
    return right(user1);
  }

  void signOut() async {
    await _auth.signOut();
  }
}
