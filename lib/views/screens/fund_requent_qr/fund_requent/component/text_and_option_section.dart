// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/dynamic_qr_controller.dart';
import 'package:lekra/controllers/fund_request_controller.dart';
import 'package:lekra/data/models/user_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_select_payment/widget/dynamic_qr_botton_sheet.dart';
import 'package:lekra/views/screens/fund_requent_qr/fund_requent/upi_dynamic_qr_sheet.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class TextBoxAndOptionSection extends StatelessWidget {
  const TextBoxAndOptionSection({
    super.key,
  });

  Future<void> _fetchQRFun({
    required FundRequestController fundRequestController,
    required BuildContext context,
    required AuthController authController,
  }) async {
    await fundRequestController
        .createUPIQR(userModel: authController.userModel ?? UserModel())
        .then((value) async {
      if (value.isSuccess) {
        UPIDynamicQrSheet.show(
          context,
        );

        fundRequestController.startPaymentFlow(context: context);
      } else {
        showToast(message: value.message, typeCheck: value.isBlank);
      }
    });
  }

  Future<void> _fetchDynamicQR({
    required DynamicQRController dynamicQRController,
    required FundRequestController fundRequestController,
    required BuildContext context,
  }) async {
    // 1. Show a loading indicator if needed
    await dynamicQRController
        .fetchDynamicQRForFund(
            amount: fundRequestController.amountController.text.trim())
        .then((value) {
      if (value.isSuccess) {
        Get.find<DynamicQRController>()
            .startPaymentFlow(context: context, isForWalletFundAdd: true);
        DynamicQrSheet.show(
          Get.context ?? context,
        );
      } else {
        // Handle failure
        showToast(message: value.message, typeCheck: value.isSuccess);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DynamicQRController>(builder: (dynamicQRController) {
      return GetBuilder<FundRequestController>(
          builder: (fundRequestController) {
        return Column(
          children: [
            GetBuilder<AuthController>(builder: (authController) {
              return AppTextFieldWithHeading(
                controller: fundRequestController.amountController,
                hindText: "Add Amount",
                borderColor: primaryColor,
                bgColor: white,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus(); // Close keyboard
                  return _fetchDynamicQR(
                      dynamicQRController: dynamicQRController,
                      fundRequestController: fundRequestController,
                      context: context);
                },
                // _fetchQRFun(
                //     authController: authController,
                //     fundRequestController: fundRequestController,
                //     context: context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Amount is required";
                  }
                  return null;
                },
              );
            }),
            const SizedBox(height: 16),
            SizedBox(
              height: 38,
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final amount = amountList[index];
                  return CustomButton(
                    onTap: () {
                      fundRequestController
                          .updateAmountControllerPrice(amount.amount);
                    },
                    color: primaryColor.withValues(alpha: 0.1),
                    child: Text(
                      "₹${amount.amount}",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 18),
                itemCount: amountList.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            GetBuilder<DynamicQRController>(builder: (dynamicQRController) {
              return GetBuilder<AuthController>(builder: (authController) {
                return CustomButton(
                  isLoading: fundRequestController.isLoading,
                  onTap: () => _fetchDynamicQR(
                      dynamicQRController: dynamicQRController,
                      fundRequestController: fundRequestController,
                      context: context),
                  //  _fetchQRFun(
                  //     authController: authController,
                  //     fundRequestController: fundRequestController,
                  //     context: context),
                  height: 49,
                  child: Text(
                    "Fetch QR",
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: white,
                        ),
                  ),
                );
              });
            })
          ],
        );
      });
    });
  }
}

class AmountOptionModel {
  final String amount;

  AmountOptionModel({required this.amount});
}

List<AmountOptionModel> amountList = [
  AmountOptionModel(amount: "100"),
  AmountOptionModel(amount: "200"),
  AmountOptionModel(amount: "500"),
  AmountOptionModel(amount: "1000"),
];
