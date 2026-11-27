import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/home_controller.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/product_card.dart';

class HotDealTodaySection extends StatelessWidget {
  const HotDealTodaySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (homeController) {
      return homeController.hotDealsTodayProductList.isNotEmpty
          ? CustomShimmer(
              isLoading: homeController.isLoading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Hot Deals Today",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: homeController.isLoading
                        ? 4
                        : homeController.hotDealsTodayProductList.length,
                    itemBuilder: (context, index) {
                      final product = homeController.isLoading
                          ? ProductModel()
                          : homeController.hotDealsTodayProductList[index];

                      return CustomShimmer(
                        isLoading: homeController.isLoading,
                        child: ProductCard(
                          product: product,
                          isLoading: homeController.isLoading,
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          : const SizedBox();
    });
  }
}
