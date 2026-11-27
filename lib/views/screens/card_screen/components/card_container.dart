import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/base/shimmer.dart';

class CardContainer extends StatelessWidget {
  final ProductModel? productModel;
  final bool isLoading;
  const CardContainer({
    super.key,
    required this.productModel,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      isLoading: isLoading,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  blurRadius: 6,
                  spreadRadius: 0,
                  offset: const Offset(4, 4),
                  color: black.withValues(alpha: 0.1))
            ]),
        child: Row(
          children: [
            CustomImage(
              path: (productModel?.images != null &&
                      productModel!.images!.isNotEmpty)
                  ? (productModel!.images![0].url?.toString() ?? " ")
                  : " ",
              height: 56,
              width: 56,
              radius: 6,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    capitalize(productModel?.name ?? ""),
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(productModel?.discountedPriceFormat ?? "")
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.find<ProductController>()
                          .postRemoveToCard(product: productModel)
                          .then((value) {
                        if (value.isSuccess) {
                          showToast(
                              message: value.message,
                              typeCheck: value.isSuccess);
                        } else {
                          showToast(
                              message: value.message,
                              typeCheck: value.isSuccess);
                        }
                      });
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                        decoration: BoxDecoration(
                            color: grey.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(16)),
                        child: const Icon(
                          Icons.remove,
                          size: 24,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      productModel?.quantity.toString() ?? "",
                      style: Helper(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.find<ProductController>()
                          .postAddToCard(product: productModel)
                          .then((value) {
                        if (value.isSuccess) {
                          showToast(
                              message: value.message,
                              typeCheck: value.isSuccess);
                        } else {
                          showToast(
                              message: value.message,
                              typeCheck: value.isSuccess);
                        }
                      });
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 8),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(16)),
                        child: const Icon(
                          Icons.add,
                          size: 24,
                          color: white,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
