// ignore_for_file: unused_import, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/auth/repository/auth_methods.dart';
import 'package:tenantmgmnt/features/tenant/controller/tenant_controller.dart';
import 'package:tenantmgmnt/modal/owner_modal.dart';
import 'package:tenantmgmnt/modal/property_modal.dart';
import 'package:tenantmgmnt/modal/user_type_modal.dart';
import '../../components/snack_bar.dart';
import '../../owner/controller/owner_controller.dart';

final userTypeProvider = StateProvider<UserType?>((ref) => null);
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
final getUserTypeProvider = StreamProvider.family((ref, String uid) {
  final ownerController = ref.watch(authControllerProvider.notifier);
  return ownerController.tenantorowner(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);
  Stream<User?> get authStateChange => _authRepository.authStateChange;
  void PhoneSignIn(BuildContext context, String phoneNumber) async {
    if (phoneNumber.length != 10)
      Utils.showSnackBar('Please enter a valid phone number');
    else if (phoneNumber[0] == '0') phoneNumber = phoneNumber.substring(1);
    phoneNumber = '+91' + phoneNumber;
    state = true;
    final user = await _authRepository.phoneSignIn(context, phoneNumber);
    state = false;
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

  Stream<UserType> tenantorowner(uid) {
    return _authRepository.tenantorowner(uid);
  }

  void signOut(BuildContext context) async {
    _ref.read(userTypeProvider.notifier).state = null;
    _ref.read(tenantDataProvider.notifier).state = null;
    _ref.read(ownerDataProvider.notifier).state = null;
    _ref.read(propertyDataProvider.notifier).state = null;
    _ref.read(flatDataProvider.notifier).state = null;
    _ref.read(complaintDataProvider.notifier).state = null;
    final user = _authRepository.signOut();
  }
}
