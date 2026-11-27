import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/dynamic_qr_controller.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_select_payment/widget/custom_button_pay_section.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_select_payment/widget/dynamic_qr_botton_sheet.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_select_payment/widget/recharge_info_section.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_select_payment/widget/recharge_select_payment_section.dart';
import 'package:lekra/views/screens/dashboard/wallet/wallet_enter_pin_screen/wallet_enter_pin_screen.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class MobileRechargeSelectPaymentScreen extends StatefulWidget {
  const MobileRechargeSelectPaymentScreen({super.key});

  @override
  State<MobileRechargeSelectPaymentScreen> createState() =>
      _MobileRechargeSelectPaymentScreenState();
}

class _MobileRechargeSelectPaymentScreenState
    extends State<MobileRechargeSelectPaymentScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Get.find<WalletController>().fetchWallet();
      final rechargeController = Get.find<RechargeController>();
      rechargeController.selectPaymentMethod(0);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar2(title: "Payment"),
      bottomNavigationBar:
          GetBuilder<RechargeController>(builder: (rechargeController) {
        return Padding(
          padding: AppConstants.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButtonForPaySection(
                isLoading: rechargeController.isLoading,
                title:
                    "Pay Now ${rechargeController.selectRechargePlan?.planAmount ?? ""}",
                onTap: () {
                  if (rechargeController.selectedPaymentIndex == 0) {
                    navigate(
                      context: context,
                      page: WalletEnterPinScreen(
                        isMobileRecharge: true,
                      ),
                    );
                  }
                  if (rechargeController.selectedPaymentIndex == 1) {
                    Get.find<DynamicQRController>()
                        .fetchDynamicForMobileRecharge(
                            mobileNumber: rechargeController
                                .mobileNoController.text
                                .trim(),
                            operatorId: rechargeController.selectNetworkOperate
                                    ?.operatorRechargeCode ??
                                "",
                            amount:
                                rechargeController.selectRechargePlan?.rs ?? "",
                            context: context)
                        .then((value) {
                      if (value.isSuccess) {
                        Get.find<DynamicQRController>()
                            .startPaymentFlow(context: context);
                        DynamicQrSheet.show(
                          context,
                        );
                      }
                    });
                  }
                },
              ),
              SizedBox(height: 12),
              Text(
                "Powered by SecurePay Gateway",
                style: Helper(context).textTheme.displaySmall?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: greyText2,
                    ),
              )
            ],
          ),
        );
      }),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          children: [
            RechargeInfoTopSection(),
            SizedBox(
              height: 32,
            ),
            RechargeSelectPaymentSection()
          ],
        ),
      ),
    );
  }
}
