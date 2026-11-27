import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/services/constants.dart';

class OrderSummarySection extends StatelessWidget {
  const OrderSummarySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Summary",
              style: Helper(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            RowOfPrice(
                title: "Subtotal",
                price: productController.cardModel?.subtotalFormat ?? ""),
            const SizedBox(height: 16),
            RowOfPrice(
              title: "Discount",
              price: productController.cardModel?.discountFormat ?? "0.0",
            ),
            const SizedBox(height: 16),
            RowOfPrice(
                title: "Total Amount",
                price: productController.cardModel?.totalPriceFormat ?? ""),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }
}

class RowOfPrice extends StatelessWidget {
  final String title;
  final String price;
  const RowOfPrice({
    super.key,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Helper(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
        ),
        Text(
          price,
          style: Helper(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
        )
      ],
    );
  }
}
