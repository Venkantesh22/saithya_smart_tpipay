import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/order_controlller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/order_screem/screen/order_details_screen.dart';
import 'package:lekra/views/screens/product_details_screen/product_details_screen.dart';

class OrderProductSection extends StatelessWidget {
  const OrderProductSection({
    super.key,
    required this.widget,
  });

  final OrderDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      return GestureDetector(
        onTap: () {
          if (orderController.isLoading) {
            showToast(message: "Please waiting...", toastType: ToastType.info);
            return;
          }
          navigate(
              context: context,
              page: ProductDetailsScreen(
                productId: widget.productModel.id,
              ));
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: greyBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Products",
                  style: Helper(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  CustomImage(
                    path: widget.productModel.images?[0].url ?? "",
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    radius: 12,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capitalize(widget.productModel.name ?? ""),
                          style: Helper(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          PriceConverter.convertToNumberFormat(
                              widget.productModel.discountedPrice ?? 0.00),
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                fontSize: 14,
                              ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Qty: ${widget.productModel.quantity ?? ""}",
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: grey.withValues(alpha: 10),
                              fontSize: 14),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
