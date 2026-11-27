import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/home_controller.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/search_screen/components/custom_search_textfeild.dart';
import 'package:lekra/views/screens/dashboard/search_screen/components/search_product_container.dart';
import 'package:lekra/views/screens/product_details_screen/product_details_screen.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar2(title: "Search Products"),
      body: GetBuilder<HomeController>(builder: (homeController) {
        return Padding(
          padding: AppConstants.screenPadding,
          child: Column(
            children: [
              CustomSearchTextfeild(
                hintText: "Search Products",
                controller: searchController,
                onChanged: (value) {
                  // Cancel the previous timer only if it exists
                  if (timer?.isActive ?? false) {
                    timer!.cancel();
                  }

                  // Start a new debounce timer
                  timer = Timer(const Duration(milliseconds: 500), () {
                    if (value.isNotEmpty) {
                      homeController.fetchSearchProduct(query: value);
                    }
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: homeController.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : homeController.searchProductList.isEmpty
                        ? const Center(child: Text("No products found."))
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: homeController.isLoading
                                ? 2
                                : homeController.searchProductList.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final product = homeController.isLoading
                                  ? ProductModel()
                                  : homeController.searchProductList[index];
                              return GestureDetector(
                                onTap: () {
                                  if (homeController.isLoading) {
                                    return;
                                  }
                                  navigate(
                                      context: context,
                                      page: ProductDetailsScreen(
                                          productId: product.id));
                                },
                                child: CustomShimmer(
                                    isLoading: homeController.isLoading,
                                    child: SearchProductContainer(
                                        product: product)),
                              );
                            },
                          ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
