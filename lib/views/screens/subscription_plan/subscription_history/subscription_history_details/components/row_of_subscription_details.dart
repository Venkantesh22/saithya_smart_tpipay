import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';

class RowOfSubscriptionDetails extends StatelessWidget {
  final String label;
  final Widget value;
  const RowOfSubscriptionDetails({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Helper(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        value,
      ],
    );
  }
}
