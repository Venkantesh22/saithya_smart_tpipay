import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class RechargePlanSearchBar extends StatelessWidget {
  const RechargePlanSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RechargeController>(builder: (rechargeController) {
      return Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.04,
          bottom: MediaQuery.of(context).size.height * 0.02,
        ),
        child: AppTextFieldWithHeading(
          controller: rechargeController.mobileRechargeSearchController,
          borderRadius: 999,
          borderColor: appbarBlueLight,
          bgColor: appbarBlueLight,
          hindText: "Search plan by amount or validity",
          preFixWidget: Icon(
            Icons.search,
            color: blueDark,
          ),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          suffix: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              rechargeController.mobileRechargeSearchController.clear();
              rechargeController.update();
            },
          ),
        ),
      );
    });
  }
}
