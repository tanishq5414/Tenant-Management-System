import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
// ignore: unused_import
import 'package:tenantmgmnt/features/auth/showOtp.dart';
import 'package:tenantmgmnt/features/auth/signin_main.dart';
import 'package:tenantmgmnt/features/auth/signup/signupdata.dart';
import 'package:tenantmgmnt/features/owner/screens/add_flats.dart';
import 'package:tenantmgmnt/features/owner/screens/add_property.dart';
import 'package:tenantmgmnt/features/owner/screens/owner_home.dart';
import 'package:tenantmgmnt/features/owner/screens/properties_home.dart';
import 'package:tenantmgmnt/features/owner/screens/property_details.dart';

final loggedoutpages = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: SignInPage()),
});
final loggedinpages = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: OwnerHomeScreen()),
  '/signupdata': (_) => const MaterialPage(child: SignUpData()),
  '/addproperty': (_) => const MaterialPage(child: AddProperty()),
  '/propertyhome': (_) => const MaterialPage(child: PropertyHome()),
  '/propertydetails': (q) => MaterialPage(
          child: PropertyDetails(
        propertyId: q.queryParameters['propertyId']!,
      )),
});
