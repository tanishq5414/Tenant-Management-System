import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/auth/controller/auth_controller.dart';
import 'package:tenantmgmnt/features/components/custom_app_bar.dart';
import 'package:tenantmgmnt/features/owner/controller/owner_controller.dart';
import 'package:tenantmgmnt/modal/owner_modal.dart';
import 'package:tenantmgmnt/themes/colors.dart';

class OwnerHomeScreen extends ConsumerStatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends ConsumerState<OwnerHomeScreen> {
  bool ciruclar = true;
  var user;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var user;
    getdata() async {
      user = ref.watch(ownerDataProvider);
    }
    getdata();
    // var a = ref.read(ownerControllerProvider.notifier).listentopropertydata(user.id);
    return (user != null)
        ? Container(
          color: appBackgroundColor,
          child: SafeArea(
              child: Scaffold(
                backgroundColor: appBackgroundColor,
                appBar: CustomAppBar(
                  title: 'Dashboard',
                  showbackbutton: false,
                ),
                body: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: size.width * 0.04,
                        right: size.width * 0.04,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              Routemaster.of(context).push('/propertyhome');
                            },
                            child: Container(
                              height: size.height * 0.1,
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                color: Color(0xff2DB398),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.05,
                                  ),
                                  const Center(
                                    child: Text(
                                      'Properties',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: size.width * 0.09,
                                    width: size.width * 0.09,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Text(
                                        user.propertyList?.length?.toString() ??
                                            '0',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.06,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Spacer(),
                          InkWell(
                            onTap: () {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .signOut(context);
                            },
                            child: Container(
                              height: size.height * 0.1,
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                color: const Color(0xffE65D4A),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: size.width * 0.05,
                                  ),
                                  const Center(
                                    child: Text(
                                      'Tenants',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: size.width * 0.09,
                                    width: size.width * 0.09,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Text(
                                        user.tenantList?.length.toString() ?? '0',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: size.width * 0.06,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    InkWell(
                      onTap: () => Routemaster.of(context).push('/addproperty'),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: size.width * 0.04, right: size.width * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: size.width * 0.4,
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    // offset: const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Spacer(),
                                  const Icon(
                                    Icons.wallet_outlined,
                                    size: 50,
                                    color: Colors.black,
                                  ),
                                  const Spacer(),
                                  const Text(
                                    'Payments Received',
                                    style: TextStyle(
                                        overflow: TextOverflow.visible,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  const Text(
                                    'Rs. 99,99,99,999',
                                    style: TextStyle(
                                        overflow: TextOverflow.visible,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            // const Spacer(),
                            Container(
                              height: size.width * 0.4,
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    // offset: const Offset(0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Spacer(),
                                  const Icon(
                                    Icons.money_off_outlined,
                                    size: 50,
                                    color: Colors.black,
                                  ),
                                  const Spacer(),
                                  const Text(
                                    'Pending Payments',
                                    style: TextStyle(
                                        overflow: TextOverflow.visible,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  const Text(
                                    'Rs. 99,99,99,999',
                                    style: TextStyle(
                                        overflow: TextOverflow.visible,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.025,
                    ),
                    Container(
                      height: size.height * 0.2,
                    ),
                    //create a listview.builder where complaints are displayed
                  ],
                ),
              ),
            ),
        )
        : const Center(child: CircularProgressIndicator());
  }
}
