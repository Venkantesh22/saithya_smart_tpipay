import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/product_details_screen/product_details_screen.dart';
import 'package:lekra/views/screens/widget/add_to_card_button.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.isLoading,
  });

  final ProductModel product;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isLoading) return;
        navigate(
          context: context,
          page: ProductDetailsScreen(productId: product.id),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 125,
                        width: double.infinity,
                        color: const Color(0xFFF7F8FA),
                        child: CustomImage(
                          path: (product.images != null &&
                                  product.images!.isNotEmpty &&
                                  product.images![0].url != null &&
                                  product.images![0].url!.isNotEmpty)
                              ? product.images![0].url!
                              : "",
                          height: 125,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.name ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.discountedPriceFormat,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: primaryColor,
                              ),
                        ),
                        if (product.deliveryTime != null && product.deliveryTime!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.bolt, size: 11, color: Color(0xFF059669)),
                                Text(
                                  product.deliveryTime!,
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                GetBuilder<ProductController>(
                  builder: (productController) {
                    return AddToCardButton(product: product);
                  },
                ),
              ],
            ),
          ),

          // Distance badge on top-left of product image
          if (product.distanceKm != null || product.isNearby == true)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.near_me, size: 9, color: Colors.white),
                    const SizedBox(width: 3),
                    Text(
                      product.distanceKm != null
                          ? (product.distanceKm! < 1
                              ? '${(product.distanceKm! * 1000).toInt()}m'
                              : '${product.distanceKm!.toStringAsFixed(1)}km')
                          : "Nearby",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Offer badge
          Positioned(
            top: 10,
            right: 10,
            child: product.offers != null &&
                    (product.offers?.isNotEmpty ?? false)
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.offersFormat,
                      style: Helper(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: white, fontWeight: FontWeight.w500),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
