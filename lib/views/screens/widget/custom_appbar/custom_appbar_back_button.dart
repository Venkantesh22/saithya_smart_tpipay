// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lekra/views/screens/widget/custom_back_button.dart';

class CustomAppbarBackButton extends StatelessWidget
    implements PreferredSizeWidget {
  bool goHomeScreen;

  final void Function()? onPressed;

  CustomAppbarBackButton(
      {super.key, this.goHomeScreen = false, this.onPressed});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: CustomBackButton(
        onPressed: onPressed,
      ),
    );
  }
}
