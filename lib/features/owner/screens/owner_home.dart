import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/auth/controller/auth_controller.dart';
import 'package:tenantmgmnt/features/components/custom_app_bar.dart';
import 'package:tenantmgmnt/features/owner/controller/owner_controller.dart';
import 'package:tenantmgmnt/themes/colors.dart';

import '../../components/loader.dart';

class OwnerHomeScreen extends ConsumerStatefulWidget {
  const OwnerHomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OwnerHomeScreenState();
}

class _OwnerHomeScreenState extends ConsumerState<OwnerHomeScreen> {
  bool ciruclar = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var isLoading = ref.watch(ownerControllerProvider);
    var user = ref.watch(ownerDataProvider);
    var complaints = ref.watch(complaintDataProviderOwner) ?? [];
    return isLoading? const Loader(): Container(
      color: appBackgroundColor,
      child: (user==null)?const Loader(): SafeArea(
        child: Scaffold(
          backgroundColor: appBackgroundColor,
          appBar: CustomAppBar(
            actions: [
              IconButton(onPressed: (){
                ref.read(authControllerProvider.notifier).signOut();
              }, icon: const Icon(OctIcons.sign_out_16, color: appBlackColor,)),
            ],
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
                                  user.propertyList?.length.toString() ?? '0',
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
                        Routemaster.of(context).push('/ownertenantdetails');
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
                            Text(
                              user.rentDue.toString(),
                              style: const TextStyle(
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
                            Text(
                              user.rentDue.toString(),
                              style: const TextStyle(
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
              Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.04,
                    right: size.width * 0.04,
                    bottom: size.width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Complaints',
                      style: TextStyle(
                          overflow: TextOverflow.visible,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    InkWell(
                      onTap: () => Routemaster.of(context).push('/complaints'),
                      child: const Text(
                        'View All',
                        style: TextStyle(
                            overflow: TextOverflow.visible,
                            color: appAccentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(size.width * 0.05, 0,
                      size.width * 0.05, size.width * 0.02),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: size.width * 0.005,
                        ),
                        SizedBox(
                          width: size.width * 0.27,
                          child: const Text(
                            'Subject',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: appBlackColor,
                                fontSize: 13),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.43,
                          child: const Text(
                            'Description',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: appBlackColor,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 13),
                          ),
                        ),
                        Container(
                          width: size.width * 0.1,
                          child: const Text(
                            'Status',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: appBlackColor,
                                fontSize: 13),
                          ),
                        ),
                      ]),
                ),
              ),
              //create a listview.builder where complaints are displayed
              Padding(
                padding: EdgeInsets.fromLTRB(
                    size.width * 0.05, 0, size.width * 0.05, 0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Routemaster.of(context).push(
                            '/complaintdetails',
                            queryParameters: {
                              'complaintId': complaints[index].id,
                              'subject': complaints[index].subject,
                              'description': complaints[index].description,
                              'status': complaints[index].status,
                              'createdAt':
                                  complaints[index].createdAt.toString(),
                            },
                          );
                        },
                        child: Container(
                          height: size.width * 0.1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 7,
                                // offset: const Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width * 0.005,
                                ),
                                Container(
                                  width: size.width * 0.27,
                                  child: Text(
                                    complaints[index].subject,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: appBlackColor,
                                        fontSize: 10),
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.43,
                                  child: Text(
                                    complaints[index].description,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: appBlackColor,
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 10),
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.1,
                                  child: Text(
                                    complaints[index].status,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: appBlackColor,
                                        fontSize: 10),
                                  ),
                                ),
                              ]),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
