import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/home_screen/components/home_banner.dart';

class ProductImageSection extends StatefulWidget {
  const ProductImageSection({super.key});

  @override
  State<ProductImageSection> createState() => _ProductImageSectionState();
}

class _ProductImageSectionState extends State<ProductImageSection> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GetBuilder<ProductController>(builder: (categoryController) {
          final imagesList = (categoryController.productModel?.images != null &&
                  categoryController.productModel!.images!.isNotEmpty)
              ? categoryController.productModel!.images!
              : [];
          final int itemCount = categoryController.isLoading
              ? 1
              : (imagesList.isNotEmpty ? imagesList.length : 1);

          return Column(
            children: [
              CarouselSlider(
                items: List.generate(
                  itemCount,
                  (index) => CustomShimmer(
                    isLoading: categoryController.isLoading,
                    child: SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: CustomImage(
                        radius: 12,
                        height: 300,
                        width: double.infinity,
                        path: categoryController.isLoading || imagesList.isEmpty
                            ? ""
                            : (imagesList[index].url ?? ""),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                options: CarouselOptions(
                  height: 300,
                  viewportFraction: 1,
                  autoPlay: imagesList.length > 1,
                  initialPage: 0,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 2000),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.4,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
              if (itemCount > 1 || categoryController.isLoading) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    categoryController.isLoading ? 3 : itemCount,
                    (index) {
                      return CustomShimmer(
                        isLoading: categoryController.isLoading,
                        child: BannerIndicatorWidget(
                          isActive: currentIndex == index,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          );
        }),
      ],
    );
  }
}
