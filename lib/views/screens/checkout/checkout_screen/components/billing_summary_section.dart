import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/order_controlller.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/checkout/checkout_screen/components/row_billing_text.dart';

class BillingSummarySection extends StatelessWidget {
  const BillingSummarySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Text(
              "Billing Summary",
              style: Helper(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
          RowBillingText(
            label: "Subtotal",
            price: productController.cardModel?.subtotalFormat ?? "",
          ),
          productController.cardModel?.discountFormat != null ||
                  productController.cardModel?.discountFormat != "0.00"
              ? RowBillingText(
                  label: "Discount",
                  price: productController.cardModel?.discountFormat ?? "",
                )
              : const SizedBox(),
          productController.cardModel?.couponDiscount != "0.00"
              ? RowBillingText(
                  label:
                      "Coupon Discount  ${productController.cardModel?.couponValue}",
                  price:
                      productController.cardModel?.couponDiscountFormat ?? "",
                )
              : const SizedBox(),
          GetBuilder<OrderController>(builder: (orderController) {
            return orderController.userRewordCoinsState
                ? CustomShimmer(
                    isLoading: orderController.isLoading,
                    child: RowBillingText(
                      label: "Reward Coin",
                      price:
                          productController.cardModel?.rewardDiscountFormat ??
                              "",
                    ),
                  )
                : const SizedBox();
          }),
          const Divider(
            color: grey,
          ),
          const SizedBox(
            height: 14,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Grand Total",
                style: Helper(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                productController.cardModel?.totalPriceFormat ?? "",
                style: Helper(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
