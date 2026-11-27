import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class SubscriptionStatusContainer extends StatelessWidget {
  final bool isActive;
  const SubscriptionStatusContainer({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
          color: isActive ? primaryColor : greyExpired,
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        isActive ? "Active" : "Expired",
        style: Helper(context).textTheme.bodyLarge?.copyWith(
              fontSize: 12,
              color: white,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
