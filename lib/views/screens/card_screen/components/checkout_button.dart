import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/checkout/checkout_screen/checkout_screen.dart';

class CheckoutButtonSection extends StatelessWidget {
  const CheckoutButtonSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return GestureDetector(
        onTap: () {
          (productController.cardModel?.products?.isNotEmpty ?? false)
              ? navigate(context: context, page: const CheckoutScreen())
              : showToast(
                  message: "Add Product to Card", toastType: ToastType.info);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: primaryColor, borderRadius: BorderRadius.circular(8)),
          child: Center(
            child: Text(
              "Checkout",
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 16, color: white),
            ),
          ),
        ),
      );
    });
  }
}
