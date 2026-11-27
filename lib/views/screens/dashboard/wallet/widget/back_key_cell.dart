import 'package:flutter/material.dart';
import 'package:lekra/services/theme.dart';

class BackKeyCell extends StatelessWidget {
  final Function() onPressed;
  const BackKeyCell({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 102,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Icons.backspace_outlined,
          size: 28,
          color: greyBillText,
        ),
      ),
    );
  }
}
