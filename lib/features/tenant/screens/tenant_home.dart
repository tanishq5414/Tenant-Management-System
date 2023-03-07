import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/auth/controller/auth_controller.dart';
import 'package:tenantmgmnt/features/tenant/controller/tenant_user_controller.dart';
import 'package:tenantmgmnt/modal/flats_modal.dart';
import 'package:tenantmgmnt/modal/tenant_modal.dart';
import 'package:tenantmgmnt/themes/colors.dart';

class TenantHome extends ConsumerStatefulWidget {
  const TenantHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TenantHomeState();
}

class _TenantHomeState extends ConsumerState<TenantHome> {
  @override
  Widget build(BuildContext context) {
    var tenantData = ref.watch(tenantDataProvider);
    var size = MediaQuery.of(context).size;
    var flatData = ref.watch(flatDataProvider) ??
        FlatsModal(
          id: '',
          name: '',
          description: '',
          tenantId: '',
          rent: '',
          deposit: '',
          due: '',
          complaints: [],
          payments: [],
          ownerId: '',
          propertyId: '',
          lastPaymentDate: '',
        );

    return (tenantData != null)
        ? Container(
            color: appBackgroundColor,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: appBackgroundColor,
                appBar: AppBar(
                  backgroundColor: appBackgroundColor,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  actions: [
                    IconButton(
                      onPressed: () {
                        ref
                            .read(authControllerProvider.notifier)
                            .signOut();
                      },
                      icon: const Icon(
                        OctIcons.sign_out_24,
                        color: appBlackColor,
                      ),
                    ),
                  ],
                  title: const Text(
                    'manage your account',
                    style: TextStyle(
                        color: appBlackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        size.width * 0.05,
                        size.width * 0.05,
                        size.width * 0.05,
                        size.width * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(size.width * 0.05, 0,
                              size.width * 0.05, size.width * 0.02),
                          child: Row(
                            children: [
                              const Text(
                                'Your tenant id is ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: appBlackColor,
                                    fontSize: 10),
                              ),
                              Text(
                                tenantData.id.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: appDarkGreyColor,
                                    fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        (flatData.id != '')
                            ? RentDueCard(
                                size: size,
                                flatData: flatData,
                                ref: ref,
                                tenantData: tenantData,
                              )
                            : Container(),
                        SizedBox(
                          height: size.width * 0.05,
                        ),
                        //create a poll with black background and add text and two options
                        (flatData.complaints.isNotEmpty)
                            ? ComplaintPoll(size: size)
                            : Container(),
                        SizedBox(
                          height: size.width * 0.05,
                        ),
                        //create a pay now button with black background rectangular and also add pay now text
                        Row(
                          children: [
                            const Spacer(),
                            SmallCard(
                              size: size,
                              title: 'Create Complaint',
                              icon: Icon(OctIcons.issue_draft_16),
                              onPressed: () {
                                Routemaster.of(context).push('/addcomplaint');
                              },
                            ),
                            const Spacer(),
                            SmallCard(
                              size: size,
                              title: 'Transaction',
                              icon: Icon(OctIcons.issue_tracked_by_16),
                              onPressed: () {},
                            ),
                            const Spacer(),
                            SmallCard(
                              size: size,
                              title: 'All Complaints',
                              icon: Icon(OctIcons.issue_draft_16),
                              onPressed: () {
                                Routemaster.of(context).push('/complaintshome');
                              },
                            ),
                            const Spacer(),
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}

class SmallCard extends StatelessWidget {
  const SmallCard({
    super.key,
    required this.size,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  final Size size;
  final title;
  final icon;
  final onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.width * 0.25,
      width: size.width * 0.26,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: appAccentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding:
              EdgeInsets.fromLTRB(0, size.width * 0.01, 0, size.width * 0.01),
          child: Column(
            children: [
              Spacer(),
              icon,
              Spacer(),
              Text(title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: appWhiteColor,
                  )),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class ComplaintPoll extends StatelessWidget {
  const ComplaintPoll({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appOtherGreyColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'POLL ',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: appBlackColor.withOpacity(0.6),
                  fontSize: 10),
            ),
            SizedBox(
              height: size.width * 0.02,
            ),
            const Text(
              'Was your last complaint resolved ??',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: appBlackColor,
                  fontSize: 14),
            ),
            SizedBox(
              height: size.width * 0.02,
            ),
            //create a icon container
            Row(
              children: [
                Container(
                  height: size.width * 0.1,
                  width: size.width * 0.1,
                  decoration: BoxDecoration(
                    color: appAccentColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(
                    OctIcons.check_16,
                    color: appWhiteColor,
                    size: 20,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                const Text(
                  'Yes',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: appBlackColor,
                      fontSize: 14),
                ),
              ],
            ),
            SizedBox(
              height: size.width * 0.04,
            ),
            Row(
              children: [
                Container(
                  height: size.width * 0.1,
                  width: size.width * 0.1,
                  decoration: BoxDecoration(
                    color: appAccentColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(
                    OctIcons.x_16,
                    color: appWhiteColor,
                    size: 20,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                const Text(
                  'No',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: appBlackColor,
                      fontSize: 14),
                ),
              ],
            ),
            //created an elevated button with black bacground rectangular and also add pay now text
          ],
        ),
      ),
    );
  }
}

class RentDueCard extends StatelessWidget {
  const RentDueCard({
    super.key,
    required this.size,
    required this.flatData,
    required this.ref,
    required this.tenantData,
  });

  final Size size;
  final FlatsModal flatData;
  final WidgetRef ref;
  final Tenant tenantData;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appOtherGreyColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'RENT ',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: appBlackColor.withOpacity(0.6),
                  fontSize: 10),
            ),
            SizedBox(
              height: size.width * 0.02,
            ),
            //create a icon container

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: size.width * 0.1,
                  width: size.width * 0.1,
                  decoration: BoxDecoration(
                    color: appAccentColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(
                    OctIcons.note_24,
                    color: appWhiteColor,
                    size: 20,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'money due \u{20B9}',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: appBlackColor,
                              fontSize: 18),
                        ),
                        Text(
                          flatData.due,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: appDarkGreyColor,
                              fontSize: 18),
                        ),
                      ],
                    ),
                    Text(
                      'last paid on ${flatData.lastPaymentDate}',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: appGreyColor,
                          fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: size.width * 0.04,
            ),
            //created an elevated button with black bacground rectangular and also add pay now text
            SizedBox(
              width: size.width * 0.8,
              child: ElevatedButton(
                onPressed: () {
                  Routemaster.of(context).push('/addcomplaint');
                },
                style: ElevatedButton.styleFrom(
                  primary: appAccentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'pay now',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: appWhiteColor,
                      fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
