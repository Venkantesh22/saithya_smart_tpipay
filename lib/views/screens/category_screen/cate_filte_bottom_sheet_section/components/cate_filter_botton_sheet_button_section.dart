import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/views/screens/category_screen/cate_filte_bottom_sheet_section/components/categ_filter_button.dart';

class CateFilterBottomSheetButtonSection extends StatelessWidget {
  const CateFilterBottomSheetButtonSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: cateButtonList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final categoryFilterModel = cateButtonList[index];
            return GestureDetector(
              onTap: () {
                productController
                    .updateCateFilterBarEnum(categoryFilterModel.filterId);
              },
              child: CateFilterButton(
                categoryFilterModel: categoryFilterModel,
                isSelected: categoryFilterModel.filterId ==
                    productController.selectCateFilterBar,
              ),
            );
          });
    });
  }
}
