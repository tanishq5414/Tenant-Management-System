import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/features/auth/showOtp.dart';
import 'package:tenantmgmnt/features/auth/signin_main.dart';
import 'package:tenantmgmnt/features/auth/signup/signupdata.dart';
import 'package:tenantmgmnt/features/owner/home/owner_home.dart';
import 'package:tenantmgmnt/features/owner/property/add_property.dart';
import 'package:tenantmgmnt/features/owner/property/properties_home.dart';


final loggedoutpages = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: SignInPage()),

});
final loggedinpages = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: OwnerHomeScreen()),
  '/signupdata': (_) => const MaterialPage(child: SignUpData()),
  '/addproperty': (_) => const MaterialPage(child: AddProperty()),
  '/propertyhome': (_) => const MaterialPage(child: PropertyHome()),
});
