import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/components/custom_app_bar.dart';
import 'package:tenantmgmnt/features/owner/controller/owner_controller.dart';
import 'package:tenantmgmnt/modal/flats_modal.dart';
import 'package:tenantmgmnt/modal/property_modal.dart';
import 'package:tenantmgmnt/themes/colors.dart';

class PropertyDetails extends ConsumerStatefulWidget {
  final String propertyId;
  const PropertyDetails({super.key, required this.propertyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PropertyDetailsState();
}

class _PropertyDetailsState extends ConsumerState<PropertyDetails> {
  bool cirular = true;
  late Property propertyData;

  @override
  Widget build(BuildContext context) {
    var ownerData = ref.watch(ownerDataProvider)!;
    var propertydata = ref.watch(propertyDataProvider)!;
    var flatsdata = ref.watch(allflatsDataProviderOwner)!;
    List<FlatsModal> flatslist = [];
    var size = MediaQuery.of(context).size;
    getList() {
      for (var i = 0; i < propertydata.length; i++) {
        if (propertydata[i].id == widget.propertyId) {
          propertyData = propertydata[i];
        }
      }
      for (var i = 0; i < flatsdata.length; i++) {
        if (flatsdata[i].propertyId == widget.propertyId) {
          flatslist.add(flatsdata[i]);
        }
      }
      setState(() {
        cirular = false;
      });
    }

    getList();
    return (!cirular)
        ? SafeArea(
            child: Scaffold(
              backgroundColor: appBackgroundColor,
              appBar: CustomAppBar(title: propertyData.name),
              body: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.width * 0.1,
                      ),
                      SizedBox(
                        height: size.width * 0.3,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: size.width * 0.05,
                              right: size.width * 0.05),
                          child: PropertyMainDetails(
                              size: size, propertyData: propertyData),
                        ),
                      ),
                      SizedBox(
                        height: size.width * 0.1,
                      ),
                      const Text(
                        'Flats',
                        style: TextStyle(
                          color: appAccentColor,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: size.width * 0.08,
                      ),
                      (flatslist.isEmpty)
                          ? const Center(
                              child: Text(
                                'No Flats Added',
                                style: TextStyle(
                                  color: appAccentColor,
                                  fontSize: 20,
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: flatslist.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Routemaster.of(context)
                                        .push('/flatdetails', queryParameters: {
                                      'propertyId': widget.propertyId,
                                      'flatId': flatslist[index].id,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                flatslist[index].name,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                              const Spacer(),
                                              const Text(
                                                'Due ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                '\u{20B9}' +
                                                    flatslist[index].rent,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'Tenant Name ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 10),
                                              ),
                                              const Spacer(),
                                              const Text(
                                                'Rent ',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 10),
                                              ),
                                              Text(
                                                '\u{20B9}' +
                                                    flatslist[index].rent,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                      SizedBox(
                        height: size.width * 0.2,
                      )
                    ],
                  ),
                ),
              ),
              floatingActionButton: Container(
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Routemaster.of(context).push('/addflats', queryParameters: {
                      'propertyId': widget.propertyId,
                    });
                  },
                  label: const Text('Add Flats'),
                  backgroundColor: appAccentColor,
                ),
              ),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}

class PropertyMainDetails extends StatelessWidget {
  const PropertyMainDetails({
    super.key,
    required this.size,
    required this.propertyData,
  });

  final Size size;
  final Property propertyData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DetailsRow(
          heading: 'Area',
          value: propertyData.area.trim(),
        ),
        SizedBox(
          height: size.width * 0.02,
        ),
        DetailsRow(
          heading: 'City',
          value: propertyData.city.trim(),
        ),
        SizedBox(
          height: size.width * 0.02,
        ),
        DetailsRow(
          heading: 'State',
          value: propertyData.state.trim(),
        ),
        SizedBox(
          height: size.width * 0.02,
        ),
        DetailsRow(
          heading: 'No of Flats',
          value: propertyData.flats.length.toString(),
        ),
      ],
    );
  }
}

class DetailsRow extends StatelessWidget {
  const DetailsRow({
    super.key,
    required this.heading,
    required this.value,
  });

  final String heading;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          heading,
          style: const TextStyle(
            color: appAccentColor,
            fontSize: 20,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: appAccentColor,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
