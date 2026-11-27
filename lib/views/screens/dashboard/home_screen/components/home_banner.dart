import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controller.dart';

import '../../../../../services/theme.dart';
import '../../../../base/custom_image.dart';
import '../../../../base/shimmer.dart';

// ignore: must_be_immutable
class HomeBanner extends StatefulWidget {
  const HomeBanner({
    super.key,
  });

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<BasicController>(builder: (basicController) {
      return Column(
        children: [
          const SizedBox(height: 10),
          Builder(builder: (context) {
            if (basicController.sliders.isEmpty) {
              return const SizedBox.shrink();
            }
            return CarouselSlider(
              items: List.generate(
                basicController.isLoading ? 1 : basicController.sliders.length,
                (index) => CustomShimmer(
                  isLoading: basicController.isLoading,
                  child: AspectRatio(
                    aspectRatio: 2.2 / 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CustomImage(
                        radius: 12,
                        height: MediaQuery.sizeOf(context).height,
                        width: MediaQuery.sizeOf(context).width,
                        path: basicController.isLoading
                            ? ""
                            : basicController.sliders[index].image ?? "",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
              options: CarouselOptions(
                aspectRatio: 2.2 / 1,
                viewportFraction: 0.95,
                autoPlay: true,
                initialPage: 0,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.15,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
            );
          }),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              basicController.isLoading ? 4 : basicController.sliders.length,
              (index) {
                return CustomShimmer(
                  isLoading: basicController.isLoading,
                  child: BannerIndicatorWidget(
                    isActive: currentIndex == index,
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}

class BannerIndicatorWidget extends StatelessWidget {
  const BannerIndicatorWidget({
    super.key,
    this.isActive = false,
  });
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? primaryColor : grey,
        shape: BoxShape.circle,
      ),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }
}
