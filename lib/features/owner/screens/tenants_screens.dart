import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/owner/controller/owner_controller.dart';
import 'package:tenantmgmnt/modal/flats_modal.dart';
import 'package:tenantmgmnt/themes/colors.dart';

import '../../components/custom_app_bar.dart';

class OwnertenantScreen extends ConsumerStatefulWidget {
  @override
  _OwnertenantScreenState createState() => _OwnertenantScreenState();
}

class _OwnertenantScreenState extends ConsumerState<OwnertenantScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var flatsData = ref.watch(allflatsDataProviderOwner)!;

    var occupiedFlatsData = flatsData.filter((flat) => flat.tenantId != "").toList();
    var vacantFlatsData = flatsData.filter((flat) => flat.tenantId == "").toList();


    return Scaffold(
      appBar: CustomAppBar(
        title: 'Tenants',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // give the tab bar a height [can change hheight to preferred height]
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: appAccentColor,
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: const [
                  // first tab [you can add an icon using the icon property]
                  Tab(
                    text: 'Occupied flats',
                  ),

                  // second tab [you can add an icon using the icon property]
                  Tab(
                    text: 'Vacant Flats',
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // first tab bar view widget
                  FlatsBuilder(
                    size,
                    occupiedFlatsData,
                  ),

                  // second tab bar view widget
                  FlatsBuilder(
                    size,
                    vacantFlatsData,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class FlatsBuilder extends StatelessWidget {
  var size;
  List<FlatsModal> flatsData;
  FlatsBuilder(
    this.size,
    this.flatsData, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.02, vertical: size.width * 0.05),
      child: ListView.builder(
          itemCount: flatsData.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Routemaster.of(context).push('/flatdetails', queryParameters: {
                  'propertyId': flatsData[index].propertyId,
                  'flatId': flatsData[index].id,
                });
              },
              child: Container(
                height: size.width * 0.3,
                width: size.width * 0.9,
                margin: EdgeInsets.only(
                    left: size.width * 0.05,
                    right: size.width * 0.05,
                    bottom: size.width * 0.02),
                decoration: BoxDecoration(
                  color: appGreyColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: size.width * 0.05,
                          right: size.width * 0.05,
                          top: size.width * 0.02),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            flatsData[index].name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const Spacer(),
                          const Text(
                            'Due ',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                          ),
                          Text(
                            '\u{20B9}' + flatsData[index].rent,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(
                          left: size.width * 0.05,
                          right: size.width * 0.05,
                          bottom: size.width * 0.02),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Tenant Name ',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 10),
                          ),
                          const Spacer(),
                          const Text(
                            'Rent ',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 10),
                          ),
                          Text(
                            '\u{20B9}' + flatsData[index].rent,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
