import 'package:flutter/material.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class ProductCardForCategory extends StatelessWidget {
  const ProductCardForCategory({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
                blurRadius: 4,
                spreadRadius: 0,
                offset: const Offset(0, 4),
                color: black.withValues(alpha: 0.1))
          ],
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
            child: Container(
              height: 135,
              width: double.infinity,
              color: const Color(0xFFF7F8FA),
              child: CustomImage(
                path: product.images?[0].url ?? "",
                height: 135,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  capitalize(product.name ?? ""),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                      color: black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  PriceConverter.convertToNumberFormat(
                      product.price ?? 0.00),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: primaryColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
