import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';

class ProdTitleSection extends StatelessWidget {
  const ProdTitleSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (productController) {
        return CustomShimmer(
          isLoading: productController.isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: secondaryColor,
                    ),
                    child: Text(
                      "${productController.productModel?.discountedPrice.toString() ?? ""}% OFF",
                      style: Helper(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            color: white,
                          ),
                    ),
                  )
                ],
              ),
              sizedBoxHeight(height: 4),
              Text(
                capitalize(productController.productModel?.name ?? ""),
                style: Helper(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: blackText),
              ),
              const SizedBox(height: 16),
              productController.productModel?.discountedPrice != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          productController
                                  .productModel?.discountedPriceFormat ??
                              "",
                          style:
                              Helper(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: primaryColor,
                                    fontSize: 36,
                                  ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          productController.productModel?.priceFormat ?? "",
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: greyText2,
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                              ),
                        ),
                      ],
                    )
                  : Text(
                      productController.productModel?.discountedPriceFormat ??
                          "",
                      style: Helper(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: primaryColor,
                            fontSize: 36,
                          ),
                    ),

              // Hyperlocal Delivery Information Card
              if (productController.productModel != null) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.electric_moped_rounded, color: primaryColor, size: 16),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              productController.productModel?.deliveryTime != null
                                  ? "Delivery in ${productController.productModel!.deliveryTime}"
                                  : "Standard Delivery (2-5 Days)",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A)),
                            ),
                          ),
                          if (productController.productModel?.distanceKm != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                "${productController.productModel!.distanceKm!.toStringAsFixed(1)} km",
                                style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.storefront_outlined, size: 13, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "Sold by: ${productController.productModel?.vendorName ?? 'Verified SATHIYA Partner'}${productController.productModel?.vendorPincode != null ? ' (PIN: ${productController.productModel!.vendorPincode})' : ''}",
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            productController.productModel?.deliveryCharge != null
                                ? (productController.productModel!.deliveryCharge! == 0 ? "Free Delivery" : "Fee: ₹${productController.productModel!.deliveryCharge!.toStringAsFixed(0)}")
                                : "Free Delivery",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: productController.productModel?.deliveryCharge == 0 ? Colors.green.shade700 : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
