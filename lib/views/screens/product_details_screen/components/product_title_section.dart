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
            ],
          ),
        );
      },
    );
  }
}
