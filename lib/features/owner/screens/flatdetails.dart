import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/components/custom_app_bar.dart';
import 'package:tenantmgmnt/features/owner/controller/owner_controller.dart';
import 'package:tenantmgmnt/modal/flats_modal.dart';
import 'package:tenantmgmnt/modal/property_modal.dart';
import 'package:tenantmgmnt/themes/colors.dart';

class FlatDetails extends ConsumerStatefulWidget {
  const FlatDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PropertyDetailsState();
}

class _PropertyDetailsState extends ConsumerState<FlatDetails> {
  bool cirular = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ownerData = ref.watch(ownerDataProvider)!;
    final flatdata = ref.watch(allflatsDataProviderOwner)!;
    var args = Routemaster.of(context).currentRoute.queryParameters;
    final flatId = args['flatId']!;
    getflatdetails() {
      int index = flatdata.indexWhere((element) => element.id == flatId);
      return flatdata[index];
    }

    FlatsModal flat = getflatdetails();

    final propetyId = args['propertyId']!;
    return SafeArea(
      child: Scaffold(
        backgroundColor: appBackgroundColor,
        appBar: CustomAppBar(title: 'Flat details'),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FlatDetailsName(
                    size: size, title: 'Flat Name', subtitle: flat.name),
                FlatDetailsName(
                    size: size, title: 'Rent', subtitle: flat.rent.toString()),
                FlatDetailsName(
                    size: size,
                    title: 'Deposit',
                    subtitle: flat.deposit.toString()),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, size.width * 0.05, 0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.05,
                      ),
                      const Text(
                        'Status',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary:
                              flat.tenantId == null ? Colors.green : Colors.red,
                        ),
                        onPressed: () {},
                        child: (flat.tenantId == null || flat.tenantId == '')
                            ? const Text('Vacant')
                            : const Text('Occupied'),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(flat.name),
                  subtitle: Text(flat.rent.toString()),
                ),
                const Center(
                  child: Text(
                    'Tenant Details',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: appAccentColor),
                  ),
                ),
                (flat.tenantId != '')
                    ? TenantDetails(
                        ref: ref, size: size, tenantId: flat.tenantId)
                    : Container(),

                // create an elevated button for remove or add tenant
                (flat.tenantId != '')
                    ? ElevatedButton(
                        onPressed: () {
                          ref
                              .read(ownerControllerProvider.notifier)
                              .removeTenant(
                                context: context,
                                tenantid: flat.tenantId,
                                ownerid: ownerData.id!,
                                propertyid: propetyId,
                                flatid: flat.id,
                              );
                        },
                        child: const Text('Remove Tenant'),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Routemaster.of(context).push('/pickcontact', queryParameters: {
                            'propertyId': propetyId,
                            'flatId': flat.id,
                          });
                        },
                        child: const Text('Add Tenant'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TenantDetails extends StatefulWidget {
  const TenantDetails({
    super.key,
    required this.ref,
    required this.size,
    required this.tenantId,
  });

  final WidgetRef ref;
  final Size size;
  final String tenantId;

  @override
  State<TenantDetails> createState() => _TenantDetailsState();
}

class _TenantDetailsState extends State<TenantDetails> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.ref
            .read(ownerControllerProvider.notifier)
            .getTenantData(context: context, tenantid: widget.tenantId),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.hasData) {
            return Column(
              children: [
                FlatDetailsName(
                    size: widget.size,
                    title: 'Name',
                    subtitle: snapshot.data!.firstName +
                        ' ' +
                        snapshot.data!.lastName),
                FlatDetailsName(
                    size: widget.size, title: 'Phone', subtitle: snapshot.data!.phone),
              ],
            );
          } else {
            return Container();
          }
        });
  }
}

class FlatDetailsName extends StatelessWidget {
  var title;

  var subtitle;

  FlatDetailsName({
    super.key,
    required this.size,
    required this.title,
    required this.subtitle,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05, vertical: size.width * 0.05),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
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
