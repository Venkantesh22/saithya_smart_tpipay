import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class RechargePaymentOptionContainer extends StatelessWidget {
  final RechargeOptionModel rechargeOptionModel;
  const RechargePaymentOptionContainer({
    super.key,
    required this.rechargeOptionModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: rechargeOptionModel.onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(20),
            border: rechargeOptionModel.isSelect
                ? Border.all(
                    width: 2,
                    color: blueDark,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 12),
                blurRadius: 32,
                spreadRadius: 0,
                color: blueLight.withValues(alpha: 0.1),
              ),
            ]),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: appbarBlueLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgPicture.asset(
                rechargeOptionModel.icon,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rechargeOptionModel.title,
                    overflow: TextOverflow.ellipsis,
                    style: Helper(context).textTheme.displaySmall?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: blackText),
                  ),
                  SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${rechargeOptionModel.subTitle}  ",
                          style: Helper(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: greyText2),
                        ),
                        TextSpan(
                          text: rechargeOptionModel.subTitle2 ?? "",
                          style: Helper(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: blueDark),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 2, color: greyText3),
                color: rechargeOptionModel.isSelect
                    ? primaryColor
                    : Colors.transparent,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RechargeOptionModel {
  final String icon;
  final String title;
  final String subTitle;
  final String? subTitle2;
  final bool isSelect;
  final Function()? onTap;

  RechargeOptionModel({
    required this.icon,
    required this.title,
    required this.subTitle,
    this.subTitle2,
    required this.isSelect,
    required this.onTap,
  });
}

List<RechargeOptionModel> rechargeOptionModelList({
  required WalletController walletController,
  required RechargeController rechargeController,
}) {
  return [
    RechargeOptionModel(
      icon: Assets.svgsWallet2,
      title: "Pay by Wallet",
      subTitle: "Available Balance:",
      subTitle2: walletController.walletModel?.walletBalance ?? "0",
      isSelect: rechargeController.selectedPaymentIndex == 0,
      onTap: () {
        rechargeController.selectPaymentMethod(0);
      },
    ),
    // RechargeOptionModel(
    //   icon: Assets.svgsQr,
    //   title: "Dynamic QR Code",
    //   subTitle: "Fast & secure",
    //   isSelect: rechargeController.selectedPaymentIndex == 1,
    //   onTap: () {
    //     rechargeController.selectPaymentMethod(1);
    //   },
    // ),
  ];
}
