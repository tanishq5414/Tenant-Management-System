
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/owner/repository/owner_repository.dart';
import 'package:tenantmgmnt/features/tenant/repository/tenant_user_repository.dart';
import 'package:tenantmgmnt/modal/complaints_modal.dart';
import 'package:tenantmgmnt/modal/flats_modal.dart';
import 'package:tenantmgmnt/modal/owner_modal.dart';
import 'package:tenantmgmnt/modal/property_modal.dart';
import 'package:tenantmgmnt/modal/tenant_modal.dart';
import '../../components/snack_bar.dart';

final tenantDataProvider = StateProvider<Tenant?>((ref) => null);
final flatDataProvider = StateProvider<FlatsModal?>((ref) => null);
final complaintDataProvider = StateProvider<List<Complaint>?>((ref) => null);


final tenantControllerProvider = StateNotifierProvider<TenantController, bool>(
  (ref) => TenantController(
    tenantRepository: ref.watch(tenantRepositoryProvider),
    ref: ref,
  ),
);


final getTenantDataProvider = StreamProvider.family((ref, String uid) {
  final tenantController = ref.watch(tenantControllerProvider.notifier);
  return tenantController.getTenantDetails(uid);
});
final getFlatDataProvider = StreamProvider.family((ref, String uid) {
  final tenantController = ref.watch(tenantControllerProvider.notifier);
  return tenantController.getFlatDetails(uid);
});
final getComplaintDataProvider = StreamProvider.family((ref, String uid) {
  final tenantController = ref.watch(tenantControllerProvider.notifier);
  return tenantController.getComplaintDetails(uid);
});

class TenantController extends StateNotifier<bool> {
  final TenantRepository _tenantRepository;
  final Ref _ref;
  TenantController(
      {required TenantRepository tenantRepository, required Ref ref})
      : _tenantRepository = tenantRepository,
        _ref = ref,
        super(
          false,);



  Stream<Tenant> getTenantDetails(uid) {
    return _tenantRepository.getTenantDetails(uid);
  }

  Stream<FlatsModal> getFlatDetails(id) {
    return _tenantRepository.getFlatDetails(id);
  }

  Stream<List<Complaint>> getComplaintDetails(id) {
    return _tenantRepository.getComplaints(id);
  }

  void addComplaint({
    required String subject,
    required String description,
    required String flatId,
    required String tenantId,
    required String ownerId,
  }) {
    _tenantRepository.addComplaint(
      subject: subject,
      description: description,
      flatId: flatId,
      tenantId: tenantId,
      ownerId: ownerId,
    );
  }

  // change status
  void changeComplaintStatus({
    required String complaintid,
    required String changedstatus,
  }) {
    _tenantRepository.changeComplaintStatus(
      complaintId: complaintid,
      changedstatus: changedstatus,
    );
  }
}
