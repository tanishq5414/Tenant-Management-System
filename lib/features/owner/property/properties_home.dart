import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tenantmgmnt/features/auth/controller/auth_controller.dart';
import 'package:tenantmgmnt/features/components/custom_app_bar.dart';
import 'package:tenantmgmnt/themes/colors.dart';

class PropertyHome extends ConsumerStatefulWidget {
  const PropertyHome({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PropertyHomeState();
}

class _PropertyHomeState extends ConsumerState<PropertyHome> {
  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    var ownerData = ref.watch(ownerDataProvider)!;

    var propertyData = ref
        .read(authControllerProvider.notifier)
        .getPropertyData(ownerData.id!);
    print(propertyData);
    super.setState(fn);
  }
  Widget build(BuildContext context) {
    var ownerData = ref.watch(ownerDataProvider)!;
    var size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Your properties',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: Container(
              height: size.height * 0.2,
              width: size.width * 0.45,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(child: Image(image: NetworkImage('https://picsum.photos/250?image=9'))),
                  Text('Property Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: appBlackColor),),
                  Text('Property City', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: appBlackColor),),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
