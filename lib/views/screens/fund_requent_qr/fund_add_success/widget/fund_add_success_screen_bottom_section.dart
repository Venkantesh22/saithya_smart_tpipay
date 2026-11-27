import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/controllers/dynamic_qr_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_select_payment/widget/custom_button_pay_section.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/dashboard/wallet/wallet_screen/wallet_screen.dart';

class FundAddSuccessScreenBottomSection extends StatelessWidget {
  const FundAddSuccessScreenBottomSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DynamicQRController>(
      builder: (dynamicQRController) {
        return Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            CustomButtonForPaySection(
              onTap: () {
                Get.find<DashBoardController>().dashPage = 0;
                navigate(
                  context: context,
                  page: DashboardScreen(),
                );
              },
              title: "Back to Home",
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:  12.0),
              child: CustomButton(
                onTap: () {
                  Get.find<DashBoardController>().dashPage = 1;
                  navigate(context: context, page: WalletScreen());
                },
                height: 60,
                color: secondaryColor,
                borderColor: secondaryColor,
                radius: 999,
                child: Text(
                  "View Wallet Balance",
                  style: Helper(context).textTheme.displaySmall?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: white,
                      ),
                ),
              ),
            ),  SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Row(
              children: [
                Icon(Icons.info_outline,color: blueDark,),SizedBox(width: 12),
                Expanded(
                  child: Text(
        
                    "Your transaction is being processed and will reflect in your balance shortly. For any issues, quote UTR: ${dynamicQRController.dynamicWalletPaymentDoneModel?.utr ?? ""}.",
                    textAlign: TextAlign.start,
                    style: Helper(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: greyText2,
                        ),
                  ),
                ),
              ],
            )
          ],
        );
      }
    );
  }
}
