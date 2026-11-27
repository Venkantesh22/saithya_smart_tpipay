import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/checkout/apply_coupon.dart/apply_coupon_screen.dart';

class ApplyCouponContainer extends StatelessWidget {
  const ApplyCouponContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigate(context: context, page: const ApplyCouponScreen());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  blurRadius: 4,
                  spreadRadius: 0,
                  color: black.withValues(alpha: 0.1 /*  */),
                  offset: const Offset(0, 4))
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Apply Coupon",
              style: Helper(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const Icon(Icons.arrow_forward_ios_sharp)
          ],
        ),
      ),
    );
  }
}
