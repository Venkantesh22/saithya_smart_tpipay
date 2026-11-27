import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class CustomButtonForPaySection extends StatelessWidget {
  final String? title;
  final Widget? titleWidget;
  final bool? isLoading;
  final Function() onTap;
  const CustomButtonForPaySection(
      {super.key,
      this.title,
      required this.onTap,
      this.titleWidget,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RechargeController>(builder: (rechargeController) {
      return SafeArea(
        child: Padding(
          padding: AppConstants.screenPadding,
          child: GestureDetector(
            onTap: isLoading == true ? () {} : onTap,
            child: Container(
              width: double.infinity,
              height: 60,
              padding: EdgeInsets.symmetric(
                vertical: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: LinearGradient(
                  colors: [blueDark, Color(0xFF0073DD)],
                ),
              ),
              child: Center(
                child: isLoading == true
                    ? CircularProgressIndicator(
                        color: grey,
                      )
                    : titleWidget ??
                        Text(
                          title ?? "",
                          style:
                              Helper(context).textTheme.displaySmall?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: white,
                                  ),
                        ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
