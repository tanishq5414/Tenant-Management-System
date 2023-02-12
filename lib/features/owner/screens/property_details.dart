import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/components/custom_app_bar.dart';
import 'package:tenantmgmnt/features/owner/controller/owner_controller.dart';
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
  @override
  late Property propertyData;

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // TODO: implement initState
      var ownerData = ref.watch(ownerDataProvider)!;
      var size = MediaQuery.of(context).size;
      getData() async {
        var propertyData1 = await ref
            .read(ownerControllerProvider.notifier)
            .getPropertyData(ownerData.id!);
        return propertyData1;
      }

      print(getData());

      getList() async {
        print('1');
        var data = await getData();
        print('data: $data');
        for (var i = 0; i < data.length; i++) {
          if (data[i].id == widget.propertyId) {
            print(data[i]);
            propertyData = data[i];

            print(i);
            print(data[i].id == widget.propertyId);
          }
        }
      }

      getList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: appBackgroundColor,
        appBar: CustomAppBar(title: propertyData.name),
        body: Center(
          child: Column(
            children: [],
          ),
        ),
        floatingActionButton: Container(
            child: FloatingActionButton.extended(
          onPressed: () {
            Routemaster.of(context).push('/addflats',
                queryParameters: {'propertyId': widget.propertyId, 'propertyList': ''});
          },
          label: const Text('Add Flats'),
          backgroundColor: appAccentColor,
        )));
  }
}
