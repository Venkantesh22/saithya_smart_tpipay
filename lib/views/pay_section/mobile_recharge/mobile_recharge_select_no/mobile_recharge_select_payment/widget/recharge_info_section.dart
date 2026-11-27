import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class RechargeInfoTopSection extends StatelessWidget {
  const RechargeInfoTopSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RechargeController>(builder: (rechargeController) {
      return Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: white,
            border: Border.all(
              width: 1,
              color: Color(0xFFC1C6D61A).withValues(alpha: 0.10),
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 12),
                blurRadius: 32,
                spreadRadius: 0,
                color: Color(0xFF0B1C300F).withValues(alpha: 0.10),
              )
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "RECHARGING FOR",
              overflow: TextOverflow.ellipsis,
              style: Helper(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: greyText2),
            ),
            SizedBox(height: 4),
            Text(
              "+91 ${rechargeController.mobileNoController.text}",
              overflow: TextOverflow.ellipsis,
              style: Helper(context).textTheme.displaySmall?.copyWith(
                  fontSize: 18, fontWeight: FontWeight.w800, color: blackText),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(
                color: appbarBlueLight,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Plan Amount",
                        overflow: TextOverflow.ellipsis,
                        style: Helper(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: greyText2),
                      ),
                      SizedBox(height: 4),
                      Text(
                        rechargeController.selectRechargePlan?.planAmount ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: Helper(context).textTheme.displaySmall?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: blackText),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  width: 1,
                  height: 40,
                  decoration: BoxDecoration(
                    color: appbarBlueLight,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Validity",
                        overflow: TextOverflow.ellipsis,
                        style: Helper(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: greyText2),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "${rechargeController.selectRechargePlan?.validity ?? ""} Days",
                        overflow: TextOverflow.ellipsis,
                        style: Helper(context).textTheme.displaySmall?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: blackText),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      );
    });
  }
}
