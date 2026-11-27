import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class PlanTitleContainer extends StatelessWidget {
  final String? title;
  final bool isSelect;
  final Function() onTap;
  const PlanTitleContainer({
    super.key,
    required this.title,
    required this.isSelect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: isSelect ? blueDark : appbarBlueLight,
        ),
        child: Text(
          title ?? "Loading..",
          style: Helper(context).textTheme.displaySmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isSelect ? white : black),
        ),
      ),
    );
  }
}
