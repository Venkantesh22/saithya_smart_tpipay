import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/home_controller.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/category_screen/cate_filte_bottom_sheet_section/components/cate_filter_botton_sheet_button_section.dart';
import 'package:lekra/views/screens/category_screen/cate_filte_bottom_sheet_section/components/cate_filter_option_section.dart';

class CateFilterBottomSheet extends StatelessWidget {
  const CateFilterBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        height: MediaQuery.of(context).size.height * 0.50,
        decoration: const BoxDecoration(
          color: white,
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(24),
            left: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filter",
                    style: Helper(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => pop(context),
                    child: const CircleAvatar(
                        radius: 12,
                        child: Icon(
                          Icons.close,
                          size: 16,
                        )),
                  )
                ],
              ),
            ),
            const Divider(
              color: grey,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Expanded(
                    child: CateFilterBottomSheetButtonSection(),
                  ),
                  Container(
                    color: grey,
                    width: 2,
                  ),
                  CateFilterOption()
                ],
              ),
            ),
            const Divider(color: grey),
            GetBuilder<HomeController>(builder: (homeController) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Expanded(
                        child: CustomButton(
                      color: white,
                      onTap: () {
                        productController.reSetCateFilter();
                      },
                      child: Text(
                        "Clear all",
                        style: Helper(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                      ),
                    )),
                    const SizedBox(width: 6),
                    Expanded(
                        child: CustomButton(
                      color: primaryColor,
                      onTap: () async {
                        await productController.fetchCategory(
                          categoryId: homeController.selectCategoryModel?.id,
                          lowToHight: productController.selectedPriceSort ==
                              PriceSortOrder.lowToHigh,
                          hightToLow: productController.selectedPriceSort ==
                              PriceSortOrder.highToLow,
                        );
                      },
                      child: Text(
                        "Apply",
                        style: Helper(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                      ),
                    ))
                  ],
                ),
              );
            })
          ],
        ),
      );
    });
  }
}
