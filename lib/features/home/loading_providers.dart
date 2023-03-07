import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/auth/controller/auth_controller.dart';
import 'package:tenantmgmnt/features/components/loader.dart';
import 'package:tenantmgmnt/features/owner/controller/owner_controller.dart';
import 'package:tenantmgmnt/features/owner/screens/owner_home.dart';
import 'package:tenantmgmnt/features/tenant/controller/tenant_user_controller.dart';
import 'package:tenantmgmnt/features/tenant/screens/tenant_home.dart';
import 'package:tenantmgmnt/modal/user_type_modal.dart';
import 'package:tenantmgmnt/themes/colors.dart';

class LoadingPage extends ConsumerStatefulWidget {
  const LoadingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoadingPageState();
}

class _LoadingPageState extends ConsumerState<LoadingPage> {
  UserType? user;
  var flag = -1;
  loading(UserType user) async {
    if (user != null) {
      print('user type is ${user!.user_type}');
      if (user!.user_type == 'tenant') {
        if (kDebugMode) {
          print('user type is tenant and id is ${user!.id}');
        }
        flag = 1;
        print(flag);
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
          var b = await ref
              .read(tenantControllerProvider.notifier)
              .getComplaintDetails(t.flatId)
              .first;
          ref.read(complaintDataProvider.notifier).update((state) => b);
          if (kDebugMode) print('loaded all the required providers');
        }
      } else {
        print('owner');
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
        var u2 = await ref
            .read(ownerControllerProvider.notifier)
            .getComplaintData(user!.id)
            .first;
        ref.read(complaintDataProviderOwner.notifier).update((state) => u2);
        var u3 = await ref
            .read(ownerControllerProvider.notifier)
            .getAllFlatsData(user!.id)
            .first;
        ref.read(allflatsDataProviderOwner.notifier).update((state) => u3);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      user = ref.watch(userTypeProvider);
      loading(user!);
// your code goes here
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ref.watch(userTypeProvider);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    var user = ref.watch(userTypeProvider);
    (user== null) ?Loader():{
    loading(user)
    };
    if (user!.user_type == 'tenant') {
      return const TenantHome();
    } else {
      return const OwnerHomeScreen();
    }
  }
}
