// ignore_for_file: unused_import, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/owner/repository/owner_repository.dart';
import 'package:tenantmgmnt/modal/owner_modal.dart';
import 'package:tenantmgmnt/modal/property_modal.dart';
import '../../components/snack_bar.dart';

final ownerDataProvider = StateProvider<OwnerModal?>((ref) => null);

final ownerControllerProvider = StateNotifierProvider<OwnerController, bool>(
  (ref) => OwnerController(
    ownerRepository: ref.watch(ownerRepositoryProvider),
    ref: ref,
  ),
);

final getOwnerDataProvider = StreamProvider.family((ref, String uid) {
  final ownerController = ref.watch(ownerControllerProvider.notifier);
  return ownerController.getOwnerData(uid);
});

class OwnerController extends StateNotifier<bool> {
  final OwnerRepository _ownerRepository;
  final Ref _ref;
  OwnerController({required OwnerRepository ownerRepository, required Ref ref})
      : _ownerRepository = ownerRepository,
        _ref = ref,
        super(false);


  Stream<OwnerModal> getOwnerData(String uid) {
    return _ownerRepository.getOwnerData(uid);
  }

  void insertOwnerFirstDetails({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String typeofuser,
  }) async {
    final user = await _ownerRepository.insertOwnerFirstDetails(
        context, firstName, lastName, email, phone, typeofuser);
    user.fold((l) => Utils.showSnackBar(l.message), (userModel) {
      _ref.read(ownerDataProvider.notifier).update((state) => userModel);
    });
    Routemaster.of(context).popUntil((routeData) => false);
  }

  void addProperty({
    required BuildContext context,
    required List userpropertylist,
    required String propertyname,
    required String propertyarea,
    required String propertycity,
    required String propertystate,
    required String propertyzipcode,
    required String propertyimage,
  }) {
    final user = _ownerRepository.addProperty(
        context,
        userpropertylist,
        propertyname,
        propertyarea,
        propertycity,
        propertystate,
        propertyzipcode,
        propertyimage);
  }

  Future<List<Property>> getPropertyData(String uid) async {
    var u;
    final user = await _ownerRepository.getPropertyData(uid);
    user.fold((l) => Utils.showSnackBar(l.message), (userModel) {
      u = userModel;
    });
    return u;
  }

  void addFlat({
    required BuildContext context,
    required String flatname,
    required String description,
    required String tenantid,
    required String rent,
    required String deposit,
    required String due,
    required List complaint,
    required List payments,
    required List flatlist,
    required String propertyid,
  }) {
    final user = _ownerRepository.addFlat(
      context,
      flatname,
      description,
      tenantid,
      rent,
      deposit,
      due,
      complaint,
      payments,
      flatlist,
      propertyid,
    );
  }

  void getFlatData({
    required BuildContext context,
    required String pid,
  }) {
    final user = _ownerRepository.getFlatData(context, pid);
  }
}
