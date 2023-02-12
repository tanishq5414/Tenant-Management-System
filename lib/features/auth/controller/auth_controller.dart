// ignore_for_file: unused_import, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/auth/repository/auth_methods.dart';
import 'package:tenantmgmnt/modal/owner_modal.dart';
import 'package:tenantmgmnt/modal/property_modal.dart';
import '../../components/snack_bar.dart';


final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);
final authStateProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});
final getOwnerDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getOwnerData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);
  Stream<OwnerModal> getOwnerData(String uid) {
    return _authRepository.getOwnerData(uid);
  }

  Stream<User?> get authStateChange => _authRepository.authStateChange;
  void PhoneSignIn(BuildContext context, String phoneNumber) async {
    if (phoneNumber.length != 10)
      Utils.showSnackBar('Please enter a valid phone number');
    else if (phoneNumber[0] == '0') phoneNumber = phoneNumber.substring(1);
    phoneNumber = '+91' + phoneNumber;
    state = true;
    final user = await _authRepository.phoneSignIn(context, phoneNumber);

    state = false;
    // user.fold((l) => Utils.showSnackBar(l.message), (userModel) {
    //   _ref.read(userProvider.notifier).update((state) => userModel);
    // });
  }

  void insertTenantFirstDetails({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String typeofuser,
  }) {
    final user = _authRepository.insertTenantFirstDetails(
        context, firstName, lastName, email, phone, typeofuser);
  }

  // void insertOwnerFirstDetails({
  //   required BuildContext context,
  //   required String firstName,
  //   required String lastName,
  //   required String email,
  //   required String phone,
  //   required String typeofuser,
  // }) async {
  //   final user = await _authRepository.insertOwnerFirstDetails(
  //       context, firstName, lastName, email, phone, typeofuser);
  //   user.fold((l) => Utils.showSnackBar(l.message), (userModel) {
  //     _ref.read(ownerDataProvider.notifier).update((state) => userModel);
  //   });
  //   Routemaster.of(context).popUntil((routeData) => false);
  // }

  // void addProperty({
  //   required BuildContext context,
  //   required List userpropertylist,
  //   required String propertyname,
  //   required String propertyarea,
  //   required String propertycity,
  //   required String propertystate,
  //   required String propertyzipcode,
  //   required String propertyimage,
  // }) {
  //   final user = _authRepository.addProperty(context, userpropertylist,
  //       propertyname, propertyarea,propertycity, propertystate, propertyzipcode, propertyimage);
  // }

  // Future<List<Property>> getPropertyData(String uid) async {
  //   // late List<Property> u = [];
  //   var u;
  //   final user = await _authRepository.getPropertyData(uid);
  //   user.fold((l) => Utils.showSnackBar(l.message), (userModel) {
  //     u = userModel;
  //   });
  //   return u;
  //   // return u;
  // }
  // Stream<User?> get authStateChange => _authRepository.authStateChange;
  // void signInWithGoogle(BuildContext context) async {
  //   state = true;
  //   final user = await _authRepository.signInWithGoogle(context);
  //   state = false;
  //   user.fold((l) => Utils.showSnackBar(l.message), (userModel) {
  //     _ref.read(userProvider.notifier).update((state) => userModel);
  //   });
  // }

  // void bookmarkNotes(BuildContext context, String id, bookmarks) {
  //   final user = _authRepository.bookmarkNotes(id, bookmarks);
  // }

  // void updateUserCourses(BuildContext context, String uid, var cid) {
  //   final user = _authRepository.updateUserCourses(uid, cid);
  // }
  // void incrementNotesOpened(BuildContext context, String uid , String notesid, String notesname, String course, String unit) {
  //   final user = _authRepository.incrementnotesopened(uid , notesid, notesname, course , unit);
  // }

  // void logInWithEmail(
  //     BuildContext context, String email, String password) async {
  //   state = true;
  //   final user = await _authRepository.loginWithEmail(
  //       email: email, password: password, context: context);
  //   state = false;
  //   user.fold((l) => Utils.showSnackBar(l.message), (r) => _ref.read(userProvider.notifier).update((state) => r));

  // }

  // void sendEmailVerification(BuildContext context) async {
  //   final user = _authRepository.sendEmailVerification(context);
  // }

  // void signUpwithEmail(BuildContext context, email, password, fullName) async {
  //   final user = _authRepository.signUpWithEmail(
  //       email: email, password: password, fullName: fullName, context: context);
  // }

  void signOut(BuildContext context) async {
    final user = _authRepository.signOut();
  }

  // void updateName(BuildContext context, fullName, uid) async {
  //   final user = _authRepository.updateName(context, fullName, uid);
  // }

  // void deleteAccount(BuildContext context) async {
  //   final user = _authRepository.deleteAccount(context);
  // }

  // void resetPassword(BuildContext context, email) async {
  //   final user = _authRepository.resetPassword(email: email);
  // }
}
