import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/data/models/service/mobile_recharge_service_models/recharge_plan_model.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_select_payment/mobile_recharge_select_payment_screen.dart';

class RechargePlanContainer extends StatelessWidget {
  final RechargePlan rechargePlan;
  const RechargePlanContainer({
    super.key,
    required this.rechargePlan,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RechargeController>(builder: (rechargeController) {
      return Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 12),
              blurRadius: 32,
              spreadRadius: 0,
              color: const Color(0xFF0B1C300A).withValues(alpha: 0.10),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rechargePlan.planAmount,
                      style: Helper(context).textTheme.displaySmall?.copyWith(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: blackText,
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Validity: ${rechargePlan.validity} Days",
                      style: Helper(context).textTheme.headlineSmall?.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: blackText,
                            letterSpacing: 0.55,
                          ),
                    )
                  ],
                ),
                Text(
                  rechargePlan.lastUpdate ?? "",
                  style: Helper(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: greyText3,
                      ),
                )
              ],
            ),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: BoxDecoration(
                color: appbarBlueLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    Assets.svgsCurrentIcon,
                    width: 14,
                    height: 17,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "BENEFITS : ",
                          style:
                              Helper(context).textTheme.headlineSmall?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: greyText2,
                                    letterSpacing: 0.55,
                                  ),
                        ),
                        Text(
                          rechargePlan.desc ?? "",
                          overflow: TextOverflow.clip,
                          style:
                              Helper(context).textTheme.headlineSmall?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: blackText,
                                  ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            CustomButton(
              onTap: () {
                if (rechargeController.isLoading) {
                  return showToast(
                      message: "Loading..", toastType: ToastType.info);
                }
                rechargeController.updateSelectRechargePlan(rechargePlan);
                navigate(
                    context: context,
                    page: MobileRechargeSelectPaymentScreen());
              },
              height: 60,
              radius: 999,
              color: appbarBlueLight,
              borderColor: appbarBlueLight,
              child: Text(
                "Choose Plan",
                style: Helper(context).textTheme.displaySmall?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: blueDark,
                    ),
              ),
            )
          ],
        ),
      );
    });
  }
}
