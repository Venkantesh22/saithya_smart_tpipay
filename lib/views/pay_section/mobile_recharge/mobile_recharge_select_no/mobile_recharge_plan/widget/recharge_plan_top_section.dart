import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class RechargePlanTopSection extends StatelessWidget {
  const RechargePlanTopSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RechargeController>(builder: (rechargeController) {
      return GestureDetector(
        onTap: () => pop(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    "RECHARGE FOR",
                    overflow: TextOverflow.ellipsis,
                    style: Helper(context).textTheme.displaySmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: blueDark,
                        letterSpacing: 0.5),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "+91 ${rechargeController.mobileNoController.text}",
                    overflow: TextOverflow.ellipsis,
                    style: Helper(context).textTheme.displaySmall?.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                  ),
                  SizedBox(height: 3.5),
                  Row(
                    children: [
                      Text(
                        "Telecom Pro • ${rechargeController.selectRechargeStateAreaModel?.areaName}",
                        overflow: TextOverflow.ellipsis,
                        style: Helper(context).textTheme.displaySmall?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: greyText2,
                            ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        Icons.edit,
                        size: 16,
                        color: blueDark,
                      )
                    ],
                  ),
                ],
              ),
            ),
            CustomImage(
              path: rechargeController.selectNetworkOperate?.logo ?? "",
              height: 48,
              width: 48,
            )
          ],
        ),
      );
    });
  }
}
