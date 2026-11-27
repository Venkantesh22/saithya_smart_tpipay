import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/views/base/shimmer.dart';

class KeyFeaturesSection extends StatelessWidget {
  const KeyFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  "Key Features",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: productController.isLoading
                  ? 2
                  : (productController.productModel?.features?.length ?? 0),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final featureText = productController.isLoading
                    ? ""
                    : productController.productModel?.features?[index];
                return CustomShimmer(
                  isLoading: productController.isLoading,
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.black),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          featureText ?? "",
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }
}

// class FeatureChip extends StatelessWidget {
//   final String text;
//   const FeatureChip({required this.text});

//   @override
//   Widget build(BuildContext context) {
//     return Chip(
//       label: Text(text, style: Theme.of(context).textTheme.bodyMedium),
//       backgroundColor: Theme.of(context).cardColor,
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//     );
//   }
// }
