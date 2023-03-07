import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/auth/controller/auth_controller.dart';
import 'package:tenantmgmnt/features/components/custom_app_bar.dart';
import 'package:tenantmgmnt/features/components/loader.dart';
import 'package:tenantmgmnt/features/owner/controller/owner_controller.dart';
import 'package:tenantmgmnt/modal/property_modal.dart';
import 'package:tenantmgmnt/themes/colors.dart';

class PropertyHome extends ConsumerStatefulWidget {
  const PropertyHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PropertyHomeState();
}

class _PropertyHomeState extends ConsumerState<PropertyHome> {
  @override
  Widget build(BuildContext context) {
    var isLoading = ref.watch(ownerControllerProvider);
    var data = ref.watch(propertyDataProvider) ?? [];    
    var size = MediaQuery.of(context).size;
    return isLoading ? Loader(): Container(
      color: appBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: appBackgroundColor,
          appBar: CustomAppBar(
            title: 'Your properties',
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),
                Container(
                  height: size.height * 0.07,
                  width: size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.03),
                        child: const Icon(
                          OctIcons.search_16,
                          color: Colors.black45,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.03),
                        child: const Text(
                          'Search',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black45),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: size.height * 0.02, right: size.height * 0.03),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.84,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Routemaster.of(context)
                              .push('/propertydetails', queryParameters: {
                            'propertyId': data[index].id,
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: size.height * 0.028,
                              top: size.height * 0.01),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            height: size.width * 0.47,
                            width: size.width * 0.47,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: size.height * 0.01),
                                  child: SizedBox(
                                    height: size.width * 0.3,
                                    child: Center(
                                      child: Image(
                                        image: NetworkImage(
                                          data[index].image,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: size.width * 0.02,
                                      left: size.width * 0.03),
                                  child: Text(
                                    data[index].name,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: appBlackColor),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: size.width * 0.03,
                                      top: size.width * 0.02),
                                  child: Text(
                                    data[index].area +
                                        ', ' +
                                        data[index].city.substring(0, 3),
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black45),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: SizedBox(
            // height: size.height * 0.07,
            child: FittedBox(
              child: FloatingActionButton.extended(
                backgroundColor: appAccentColor,
                label: const Text('Add Property'),
                materialTapTargetSize: size.width > 600
                    ? MaterialTapTargetSize.padded
                    : MaterialTapTargetSize.shrinkWrap,
                onPressed: () {
                  Routemaster.of(context).push('/addproperty');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
