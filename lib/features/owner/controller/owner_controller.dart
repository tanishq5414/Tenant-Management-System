// ignore_for_file: unused_import, unused_local_variable


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/auth/controller/auth_controller.dart';
import 'package:tenantmgmnt/features/auth/repository/auth_methods.dart';
import 'package:tenantmgmnt/features/owner/repository/owner_repository.dart';
import 'package:tenantmgmnt/modal/flats_modal.dart';
import 'package:tenantmgmnt/modal/owner_modal.dart';
import 'package:tenantmgmnt/modal/property_modal.dart';
import 'package:tenantmgmnt/modal/tenant_modal.dart';
import '../../../modal/complaints_modal.dart';
import '../../components/snack_bar.dart';

final ownerDataProvider = StateProvider<OwnerModal?>((ref) => null);
final propertyDataProvider = StateProvider<List<Property>?>((ref) => null);
final complaintDataProviderOwner =
    StateProvider<List<Complaint>?>((ref) => null);
final allflatsDataProviderOwner =
    StateProvider<List<FlatsModal>?>((ref) => null);

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

final getComplaintDataProvider = StreamProvider.family((ref, String fid) {
  final ownerController = ref.watch(ownerControllerProvider.notifier);
  return ownerController.getComplaintData(fid);
});

final getAllFlatDataProvider = FutureProvider.family((ref, String ownerid) {
  final ownerController = ref.watch(ownerControllerProvider.notifier);
  return ownerController.getAllFlatsData(ownerid);
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

  Stream<List<Complaint>> getComplaintData(String fid) {
    return _ownerRepository.getComplaintsData(fid);
  }

  Stream<List<FlatsModal>> getAllFlatsData(String fid) {
    return _ownerRepository.getAllFlatsData(fid);
  }

  void insertOwnerFirstDetails({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String typeofuser,
  }) async {
    state = true;
    final user = await _ownerRepository.insertOwnerFirstDetails(
        context, firstName, lastName, email, phone, typeofuser);
    state = false;
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
  }) async {
    state = true;
    var property = await _ownerRepository.addProperty(
        context,
        userpropertylist,
        propertyname,
        propertyarea,
        propertycity,
        propertystate,
        propertyzipcode,
        propertyimage);
    state = false;
    property.fold((l) => Utils.showSnackBar(l.message), (propertyModel) {
      _ref
          .read(propertyDataProvider.notifier)
          .update((state) => state! + [propertyModel]);
      _ref.read(ownerDataProvider.notifier).update((state) => state!.copyWith(
            propertyList: state.propertyList! + [propertyModel.id],
          ));
    });
  }

  Future<Tenant> getTenantData({
    required BuildContext context,
    required String tenantid,
  }) {
    final user = _ownerRepository.getTenantData(
      tenantid,
    );
    return user;
  }

  void addTenant({
    required BuildContext context,
    required String tenantid,
    required String ownerid,
    required String propertyid,
    required String flatid,
  }) async {
    state = true;
    final user = await _ownerRepository.addTenant(
      context,
      ownerid,
      propertyid,
      tenantid,
      flatid,
    );
    state = false;
    user.fold((l) => Utils.showSnackBar(l.message), (tenantid) {
      _ref.read(ownerDataProvider.notifier).update((state) => state!.copyWith(
            tenantList: state.tenantList ?? [] + [tenantid],
          ));

      _ref.read(propertyDataProvider.notifier).update((state) {
        state!.forEach((element) {
          if (element.id == propertyid) {
            element.tenants = element.tenants + [tenantid];
          }
        });
        return state;
      });

      _ref.read(allflatsDataProviderOwner.notifier).update((state) {
        state!.forEach((element) {
          if (element.id == flatid) {
            element.tenantId = tenantid;
          }
        });
        return state;
      });
    });
  }

  void removeTenant({
    required BuildContext context,
    required String tenantid,
    required String ownerid,
    required String propertyid,
    required String flatid,
  }) async {
    final user = await _ownerRepository.removeTenant(
      context,
      ownerid,
      propertyid,
      tenantid,
      flatid,
    );
    user.fold((l) => Utils.showSnackBar(l.message), (tenantid) {
      _ref.read(ownerDataProvider.notifier).update((state) => state!.copyWith(
            tenantList: state.tenantList!
                .where((element) => element != tenantid)
                .toList(),
          ));

      _ref.read(propertyDataProvider.notifier).update((state) {
        state!.forEach((element) {
          if (element.id == propertyid) {
            element.tenants = element.tenants
                .where((element) => element != tenantid)
                .toList();
          }
        });
        return state;
      });

      _ref.read(allflatsDataProviderOwner.notifier).update((state) {
        state!.forEach((element) {
          if (element.id == flatid) {
            element.tenantId = '';
          }
        });
        return state;
      });
    });
  }

  Future<Tenant> getTenantDataByNumber({required String number}) {
    if (number.startsWith('+91')) {
      number = number.substring(3);
    } else if (number.startsWith('91')) {
      number = number.substring(2);
    }
    if (number.startsWith('0')) {
      number = number.substring(1);
    }
    final user = _ownerRepository.getTenantDataByNumber(
      number.trim(),
    );
    return user;
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
  }) async {
    state = true;
    final user = await _ownerRepository.addFlat(
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
    state = false;
    user.fold((l) => Utils.showSnackBar(l.message), (r) {
      _ref
          .read(allflatsDataProviderOwner.notifier)
          .update((state) => state! + [r]);
      _ref.read(propertyDataProvider.notifier).update((state) {
        state!.forEach((element) {
          if (element.id == propertyid) {
            element.flats.add(r.id);
          }
        });
        return state;
      });
    });
  }
}
