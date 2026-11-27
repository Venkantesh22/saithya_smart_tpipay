import 'package:flutter/material.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class CategoryFilterButton extends StatelessWidget {
  final CategoryFilterModel categoryFilterModel;
  final bool isSelected; // Add this
  final VoidCallback onTap; // Add this

  const CategoryFilterButton({
    super.key,
    required this.categoryFilterModel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          // Logic: Primary color if selected, white/transparent if not
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? primaryColor : greyDark),
        ),
        child: Center(
          // If onlyIcon is provided, show it. Otherwise, show Text + Icon Row
          child: categoryFilterModel.onlyIcon != null
              ? _buildIconOnly()
              : _buildTextWithOptionalIcon(context),
        ),
      ),
    );
  }

  // Helper for Icon-only buttons (like the Filter icon)
  Widget _buildIconOnly() {
    return Icon(
      (categoryFilterModel.onlyIcon as Icon).icon,
      size: 20,
      color: isSelected ? Colors.white : Colors.black,
    );
  }

  // Helper for Text buttons (like "All", "Category", etc.)
  Widget _buildTextWithOptionalIcon(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          categoryFilterModel.title ?? "",
          style: Helper(context).textTheme.bodySmall?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Colors.black,
              ),
        ),
        categoryFilterModel.icon != null
            ? Row(
                children: [
                  SizedBox(width: 4),
                  Icon(
                    categoryFilterModel.icon,
                    size: 20,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ],
              )
            : const SizedBox(),
      ],
    );
  }
}

class CategoryFilterModel {
  final String? title;
  final IconData? icon;
  final Widget? onlyIcon;
  final CateFilterBarEnum filterId;

  CategoryFilterModel({
    required this.filterId,
    this.onlyIcon,
    this.title,
    this.icon,
  });
}

List<CategoryFilterModel> categoryFilterList = [
  CategoryFilterModel(
      filterId: CateFilterBarEnum.all,
      onlyIcon: const Icon(
        Icons.filter_alt,
        size: 20,
      )),
  CategoryFilterModel(
      filterId: CateFilterBarEnum.price,
      title: "Price",
      icon: Icons.keyboard_arrow_down_rounded)
];
