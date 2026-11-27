import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class CateFilterOption extends StatelessWidget {
  const CateFilterOption({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              productController.selectCateFilterBar == CateFilterBarEnum.price
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select type of price range",
                          style: Helper(context).textTheme.bodySmall?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: greyText,
                              ),
                        ),
                        const SizedBox(height: 8),
                        RadioGroup<PriceSortOrder>(
                          groupValue: productController.selectedPriceSort,
                          onChanged: (value) {
                            if (value != null) {
                              productController.updatePriceSort(value);
                            }
                          },
                          child: Column(
                            children: [
                              RadioListTile<PriceSortOrder>(
                                value: PriceSortOrder.lowToHigh,
                                title: const Text("Low to High",
                                    style: TextStyle(fontSize: 14)),
                                activeColor: primaryColor,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              ),
                              RadioListTile<PriceSortOrder>(
                                value: PriceSortOrder.highToLow,
                                title: const Text("High to Low",
                                    style: TextStyle(fontSize: 14)),
                                activeColor: primaryColor,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
        ),
      );
    });
  }
}
