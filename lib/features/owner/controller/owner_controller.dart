// ignore_for_file: unused_import, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/owner/repository/owner_repository.dart';
import 'package:tenantmgmnt/modal/flats_modal.dart';
import 'package:tenantmgmnt/modal/owner_modal.dart';
import 'package:tenantmgmnt/modal/property_modal.dart';
import 'package:tenantmgmnt/modal/tenant_modal.dart';
import '../../components/snack_bar.dart';

final ownerDataProvider = StateProvider<OwnerModal?>((ref) => null);
final propertyDataProvider = StateProvider<List<Property>?>((ref) => null);

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

final getPropertyDataProvider = StreamProvider.family((ref, String uid) {
  final ownerController = ref.watch(ownerControllerProvider.notifier);
  return ownerController.getPropertyData(uid);
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

  Stream<List<Property>> getPropertyData(String uid) {
    return _ownerRepository.getPropertyData(uid);
  }

  Future<FlatsModal> getSingleFlatData(String fid) async {
    var FlatsData1;
    var a = await _ownerRepository.getSingleFlatData(fid);
    a.fold((l) => Utils.showSnackBar(l.message), (FlatsData) {
      FlatsData1 = FlatsData;
    });
    return FlatsData1;
  }

  Future<List<dynamic>> getFlatData(pid){
    print("getFlatData");
    var a = _ownerRepository.getFlatData(pid);
    return a;
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

  Future<Tenant> getTenantData({
    required BuildContext context,
    required String tenantid,
  }) {
    final user = _ownerRepository.getTenantData(
      tenantid,
    );
    print(user.toString());
    return user;
  }

  void addTenant({
    required BuildContext context,
    required String tenantid,
    required String ownerid,
    required String propertyid,
    required String flatid,
  }) {
    final user = _ownerRepository.addTenant(
      context,
      ownerid,
      propertyid,
      tenantid,
      flatid,
    );
  }

  void removeTenant({
    required BuildContext context,
    required String tenantid,
    required String ownerid,
    required String propertyid,
    required String flatid,
  }) {
    final user = _ownerRepository.removeTenant(
      context,
      ownerid,
      propertyid,
      tenantid,
      flatid,
    );
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
    required String ownerid,
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
      ownerid,
    );
  }
}
