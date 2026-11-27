import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class RowBillingText extends StatelessWidget {
  final String label;
  final String price;
  const RowBillingText({
    super.key,
    required this.label,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14, fontWeight: FontWeight.w400, color: greyBillText),
          ),
          Text(
            price,
            style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: blackBillingText),
          ),
        ],
      ),
    );
  }
}
