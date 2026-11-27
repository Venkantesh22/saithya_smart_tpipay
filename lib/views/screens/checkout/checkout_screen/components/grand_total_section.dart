import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class GrandTotalSection extends StatelessWidget {
  const GrandTotalSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: black.withValues(alpha: 0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: 0)
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Grand Total',
                style: Helper(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
            Text(productController.cardModel?.totalPriceFormat ?? "",
                style: Helper(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 20,
                    color: primaryColor,
                    fontWeight: FontWeight.w800))
          ],
        ),
      );
    });
  }
}
