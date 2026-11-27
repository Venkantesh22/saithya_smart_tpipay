import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_select_payment/widget/recharge_payment_option_container.dart';

class RechargeSelectPaymentSection extends StatelessWidget {
  const RechargeSelectPaymentSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      builder: (walletController) {
        return GetBuilder<RechargeController>(
          builder: (rechargeController) {
            final rechargeOptionList = rechargeOptionModelList(
              walletController: Get.find<WalletController>(),
              rechargeController: rechargeController,
            );
        
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Select Payment Method"),
                SizedBox(height: 24),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final rechargeOptionModel = rechargeOptionList[index];
        
                    return CustomShimmer(
                      isLoading: walletController.isLoading,
                      child: RechargePaymentOptionContainer(
                        rechargeOptionModel: rechargeOptionModel,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(height: 16),
                  itemCount: rechargeOptionList.length,
                )
              ],
            );
          },
        );
      }
    );
  }
}
