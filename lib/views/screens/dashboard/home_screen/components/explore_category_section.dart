import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/home_controller.dart';
import 'package:lekra/data/models/home/category_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/pay_section/pay_home/pay_home_screen.dart';
import 'package:lekra/views/screens/category_screen/category_details_screen.dart';

class ExploreCategorySection extends StatelessWidget {
  const ExploreCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GetBuilder<HomeController>(builder: (homeController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "Explore Categories",
                  overflow: TextOverflow.clip,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 110,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: homeController.categoryList.length + 1,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          navigate(context: context, page: PayHomeScreen());
                        },
                        child: const CircleAvatar(
                            radius: 32,
                            backgroundColor: white,
                            child: CustomImage(
                              path: Assets.imagesOnlyLogo,
                              width: 56,
                              height: 56,
                              fit: BoxFit.contain,
                            )),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppConstants.payAppName,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                }
                final category = homeController.isLoading
                    ? CategoryModel()
                    : homeController.categoryList[index - 1];

                return _CategoryCard(category: category);
              },
            ),
          ),
        ],
      );
    });
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            Get.find<HomeController>().updateSelectCategoryModel(category);
            navigate(
                context: context,
                page: CategoryDetailsScreen(
                  categoryModel: category,
                ));
          },
          child: CircleAvatar(
              radius: 32,
              backgroundColor: white,
              child: CustomImage(
                path: category.icon ?? "",
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              )),
        ),
        const SizedBox(height: 8),
        Text(
          category.name ?? "",
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
