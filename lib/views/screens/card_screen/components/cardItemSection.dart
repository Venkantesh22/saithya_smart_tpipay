import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/card_screen/components/card_container.dart';

class CardItemListSection extends StatelessWidget {
  const CardItemListSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GetBuilder<ProductController>(builder: (productController) {
        if (productController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (productController.cardModel?.products?.isEmpty ?? true) {
          return const Center(
            child: Text("Your cart is empty."),
          );
        }
        
        return ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final product = productController.isLoading
                  ? ProductModel()
                  : productController.cardModel?.products?[index];
              return CustomShimmer(
                isLoading: productController.isLoading,
                child: CardContainer(
                  isLoading: productController.isLoading,
                  productModel: product,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 8,
              );
            },
            itemCount: productController.isLoading
                ? 4
                : productController.cardModel?.products?.length ?? 4);
      }),
    );
  }
}
