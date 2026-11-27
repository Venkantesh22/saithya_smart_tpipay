import 'package:flutter/material.dart';

import '../../../../../../services/constants.dart';
import '../../../../../../services/theme.dart';

class CustomSearchTextfeild extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final Function(String)? onChanged;
  final Function()? onFilterTap;
  const CustomSearchTextfeild({
    super.key,
    required this.onChanged,
    this.hintText,
    this.onFilterTap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            style: Helper(context).textTheme.bodyMedium,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              filled: true,
              fillColor: greyDark.withValues(alpha: 0.16),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              prefixIcon: const SizedBox(
                height: 40,
                width: 60,
                child: Center(child: Icon(Icons.search)),
              ),
              hintText: hintText,
              hintStyle: Helper(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: greyDark),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: grey, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: grey, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: primaryColor, width: 0.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: red, width: 0.5),
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
