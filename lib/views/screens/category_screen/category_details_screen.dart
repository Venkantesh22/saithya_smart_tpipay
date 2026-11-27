import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/data/models/home/category_model.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/category_screen/components/category_filter_bar.dart';
import 'package:lekra/views/screens/category_screen/components/product_card_category.dart';
import 'package:lekra/views/screens/product_details_screen/product_details_screen.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final CategoryModel categoryModel;
  const CategoryDetailsScreen({super.key, required this.categoryModel});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productController = Get.find<ProductController>();
      productController.fetchCategory(categoryId: widget.categoryModel.id);
      productController.reSetCateFilter();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final c = _scrollController;
    if (!c.hasClients) return;

    final productController = Get.find<ProductController>();
    final st = productController.cateProductListState;

    if (st.isMoreLoading || st.isInitialLoading) return; // already busy
    if (!st.canLoadMore) return;

    // more reliable than pixels/maxScrollExtent
    if (c.position.extentAfter < 400) {
      productController.fetchCategory(
        categoryId: widget.categoryModel.id, // <-- IMPORTANT
        loadMore: true,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () => pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: black)),
        centerTitle: true,
        title: Text(
          capitalize(widget.categoryModel.name ?? ""),
          style: Helper(context).textTheme.titleMedium?.copyWith(
                color: black,
                fontSize: 22,
              ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.find<ProductController>().fetchCategory(
            categoryId: widget.categoryModel.id,
            refresh: true,
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CategoryFilterBar(),
            const SizedBox(height: 10),
            Expanded(
              child: GetBuilder<ProductController>(
                builder: (productController) {
                  final state = productController.cateProductListState;
                  final items = productController
                      .cateProductList; // ✅ This is the list we sorted

                  if (!state.isInitialLoading && items.isEmpty) {
                    return const Center(child: Text("No Product available"));
                  }

                  return SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: AppConstants.screenPadding,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.65,
                      ),
                      // If we are loading the first time, show 4 shimmers
                      itemCount: state.isInitialLoading
                          ? 4
                          : items.length + (state.isMoreLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (state.isInitialLoading ||
                            (state.isMoreLoading && index == items.length)) {
                          return CustomShimmer(
                            isLoading: true,
                            child:
                                ProductCardForCategory(product: ProductModel()),
                          );
                        }

                        // ✅ This will now show the product in the NEW sorted order
                        final product = items[index];
                        return CustomShimmer(
                          isLoading: productController.isLoading,
                          child: GestureDetector(
                            onTap: () => navigate(
                              context: context,
                              page: ProductDetailsScreen(productId: product.id),
                            ),
                            child: ProductCardForCategory(product: product),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
