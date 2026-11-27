import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/data/models/service/mobile_recharge_service_models/recharge_plan_model.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_plan/widget/plan_title_container.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_plan/widget/reacharge_plan_container.dart';

class MobileRechargePlanSection extends StatelessWidget {
  const MobileRechargePlanSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RechargeController>(builder: (rechargeController) {
      return Column(
        children: [
          SizedBox(
            height: 40,
            child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final planTitle = rechargeController.isLoading
                      ? ""
                      : rechargeController.rechargeCategoriesList[index];
                  return CustomShimmer(
                      isLoading: rechargeController.isLoading,
                      child: PlanTitleContainer(
                        title: planTitle,
                        isSelect: planTitle ==
                            rechargeController.selectRechargeCategories,
                        onTap: () {
                          rechargeController
                              .updateSelectRechargeCategories(planTitle);
                        },
                      ));
                },
                separatorBuilder: (_, __) => SizedBox(width: 12),
                itemCount: rechargeController.isLoading
                    ? 4
                    : rechargeController.rechargeCategoriesList.length),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
              itemBuilder: (context, index) {
                final plans = rechargeController.isLoading
                    ? RechargePlan()
                    : rechargeController.selectedPlans[index];

                return CustomShimmer(
                  isLoading: rechargeController.isLoading,
                  child: RechargePlanContainer(
                    rechargePlan: plans,
                  ),
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 24),
              itemCount: rechargeController.isLoading
                  ? 6
                  : rechargeController.selectedPlans.length,
            ),
          )
        ],
      );
    });
  }
}
