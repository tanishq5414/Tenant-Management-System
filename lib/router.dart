import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
// ignore: unused_import
import 'package:tenantmgmnt/features/auth/showOtp.dart';
import 'package:tenantmgmnt/features/auth/signin_main.dart';
import 'package:tenantmgmnt/features/auth/signup/signupdata.dart';
import 'package:tenantmgmnt/features/home/loading_providers.dart';
import 'package:tenantmgmnt/features/owner/screens/add_flats.dart';
import 'package:tenantmgmnt/features/owner/screens/add_property.dart';
import 'package:tenantmgmnt/features/owner/screens/contact_picker.dart';
import 'package:tenantmgmnt/features/owner/screens/owner_home.dart';
import 'package:tenantmgmnt/features/owner/screens/properties_home.dart';
import 'package:tenantmgmnt/features/owner/screens/property_details.dart';
import 'package:tenantmgmnt/features/owner/screens/tenants_screens.dart';
import 'package:tenantmgmnt/features/tenant/screens/add_complaint.dart';
import 'package:tenantmgmnt/features/tenant/screens/complaint_details.dart';
import 'package:tenantmgmnt/features/tenant/screens/tenant_home.dart';

import 'features/owner/screens/flatdetails.dart';
import 'features/tenant/screens/complaints_home.dart';

final loggedoutpages = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: SignInPage()),
});
final loggedinpages = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoadingPage()),
  '/ownerhome': (_) => const MaterialPage(child: OwnerHomeScreen()),
  '/tenanthome': (_) => const MaterialPage(child: TenantHome()),
  '/signupdata': (_) => const MaterialPage(child: SignUpData()),
  '/addproperty': (_) => const MaterialPage(child: AddProperty()),
  '/propertyhome': (_) => const MaterialPage(child: PropertyHome()),
  '/addcomplaint': (_) => MaterialPage(child: AddComplaints()),
  '/complaintshome': (_) => MaterialPage(child: ComplaintsHome()),
  '/complaintdetails': (q) => MaterialPage(child: ComplaintDetails()),
  '/pickcontact': (_) => MaterialPage(child: ContactPickerPage()),
  '/ownertenantdetails': (_) => MaterialPage(child: OwnertenantScreen()),
  '/propertydetails': (q) => MaterialPage(
          child: PropertyDetails(
        propertyId: q.queryParameters['propertyId']!,
      )),
  '/addflats': (q) => MaterialPage(
          child: AddFlats(
        propertyId: q.queryParameters['propertyId']!,
      )),
  '/flatdetails': (q) => MaterialPage(child: FlatDetails()),
});
