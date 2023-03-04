// ignore_for_file: prefer_const_constructors_in_immutables, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tenantmgmnt/themes/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final title;
  final List<Widget>? actions;
  
  bool showbackbutton  = true;
  CustomAppBar({Key? key, required this.title, this.actions, this.showbackbutton = true}) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appBackgroundColor,
      elevation: 0,
      leading: (showbackbutton)?IconButton(
          icon: const Icon(
            OctIcons.arrow_left_16,
            color: appBlackColor,
            size: 15,
          ),
          onPressed: () {
            Routemaster.of(context).history.back();
          }):Container(),
      title: Text(
        title,
        style: const TextStyle(
          color: appBlackColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: actions,
      centerTitle: true,
    );
  }
}
