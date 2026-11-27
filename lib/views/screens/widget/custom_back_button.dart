import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class CustomBackButton extends StatelessWidget {
  final void Function()? onPressed;
  const CustomBackButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: onPressed ?? () => pop(context),
      color: black,
    );
  }
}
