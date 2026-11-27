import 'package:flutter/material.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class SearchProductContainer extends StatelessWidget {
  const SearchProductContainer({
    super.key,
    required this.product,
  });

  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImage(
            path: (product?.images != null)
                ? product?.images?.first.url ?? ""
                : "",
            height: 110,
            width: 100,
            fit: BoxFit.cover,
            radius: 12,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  capitalize(product?.name ?? "Unnamed product"),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 6,
                ),
                Card(
                  color: greyBorder,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text(
                      capitalize(product?.categoryName ?? "Unnamed product"),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: 10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                product?.discountedPrice != null
                    ? Row(
                        children: [
                          Text(
                            product?.priceFormat ?? "",
                            style:
                                Helper(context).textTheme.bodyMedium?.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            product?.discountedPriceFormat ?? "",
                            style:
                                Helper(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                      fontSize: 16,
                                    ),
                          ),
                        ],
                      )
                    : Text(
                        product?.priceFormat ?? "",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              fontSize: 16,
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
