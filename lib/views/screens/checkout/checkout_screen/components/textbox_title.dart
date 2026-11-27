
import 'package:flutter/material.dart';
import 'package:lekra/services/input_decoration.dart';
import 'package:lekra/services/theme.dart';

class CustomTextboxWithTitle extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  const CustomTextboxWithTitle({
    super.key,
    required this.controller,
    required this.validator,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14
              ),
        ),
        const SizedBox(
          height: 6,
        ),
        TextFormField(
          controller: controller,
          decoration: CustomDecoration.inputDecoration(
            hint: "Enter your $title",
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: grey,
                ),
          ),
          validator: validator,
        
        ),
      ],
    );
  }
}
