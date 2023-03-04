import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/auth/controller/auth_controller.dart';
import 'package:tenantmgmnt/features/owner/controller/owner_controller.dart';
import 'package:tenantmgmnt/features/owner/screens/owner_home.dart';
import 'package:tenantmgmnt/features/tenant/controller/tenant_controller.dart';
import 'package:tenantmgmnt/features/tenant/screens/tenant_home.dart';
import 'package:tenantmgmnt/modal/user_type_modal.dart';
import 'package:tenantmgmnt/themes/colors.dart';

class LoadingPage extends ConsumerStatefulWidget {
  const LoadingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoadingPageState();
}

class _LoadingPageState extends ConsumerState<LoadingPage> {
  @override
  UserType? user;
  var flag = -1;
  Widget build(BuildContext context) {
    loading() async {
      user = ref.watch(userTypeProvider);
      if (user != null) {
        if (user!.user_type == 'tenant') {
          flag = 1;
          print(user!.user_type);
          ref.read(tenantDataProvider.notifier).update((state) => null);
          var t = await ref
              .read(tenantControllerProvider.notifier)
              .getTenantDetails(user!.id)
              .first;
          ref.read(tenantDataProvider.notifier).update((state) => t);
          print(t.flatId);
          if (t.flatId != '') {
            var a = await ref
                .read(tenantControllerProvider.notifier)
                .getFlatDetails(t.flatId)
                .first;
            ref.read(flatDataProvider.notifier).update((state) => a);
            print('a');
            var b = await ref
                .read(tenantControllerProvider.notifier)
                .getComplaintDetails(t.flatId)
                .first;
            print('b');
            print(b);
            ref.read(complaintDataProvider.notifier).update((state) => b);
          }
        } else {
          print('owner');
          flag = 0;
          var u = await ref
              .read(ownerControllerProvider.notifier)
              .getOwnerData(user!.id)
              .first;
          ref.read(ownerDataProvider.notifier).update((state) => u);
          var u1 = await ref
              .read(ownerControllerProvider.notifier)
              .getPropertyData(user!.id)
              .first;
          ref.read(propertyDataProvider.notifier).update((state) => u1);
        }
      }
    }

    loading();
    if (flag == 0) {
      print('owner screen returned');
      return const OwnerHomeScreen();
    } else if (flag == 1) {
      print('home screen returned');
      return const TenantHome();
    } else {
      print("home screen not returned");
      return Container(
        color: appBackgroundColor,
        child: Scaffold(
          body: Center(
            child: Column(
              children: const [
                Center(
                  child: CircularProgressIndicator(),
                ),
                Center(
                  child: Text('Loading...'),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
