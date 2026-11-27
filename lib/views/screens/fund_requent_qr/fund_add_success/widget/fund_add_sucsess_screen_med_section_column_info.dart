import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lekra/controllers/dynamic_qr_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class FundAddSuccessMedSectionInfoColumn extends StatelessWidget {
  final FundAddSuccessMedSectionInfoColumnModel
      fundAddSuccessMedSectionInfoColumnModel;
  const FundAddSuccessMedSectionInfoColumn({
    super.key,
    required this.fundAddSuccessMedSectionInfoColumnModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fundAddSuccessMedSectionInfoColumnModel.title,
          overflow: TextOverflow.clip,
          textAlign: TextAlign.start,
          style: Helper(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: greyText4,
              ),
        ),
        SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fundAddSuccessMedSectionInfoColumnModel.icon != null
                ? SvgPicture.asset(
                    fundAddSuccessMedSectionInfoColumnModel.icon ?? "",
                    height: 11,
                    width: 11,
                    fit: BoxFit.contain,
                  )
                : SizedBox(),
            SizedBox(width: 5),
            Text(
              fundAddSuccessMedSectionInfoColumnModel.subTitle,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.start,
              style: Helper(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: blackText,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class FundAddSuccessMedSectionInfoColumnModel {
  final String title;
  final String subTitle;
  final String? icon;

  FundAddSuccessMedSectionInfoColumnModel({
    required this.title,
    required this.subTitle,
    this.icon,
  });
}

List<FundAddSuccessMedSectionInfoColumnModel>
    fundAddSuccessMedSectionInfoColumnModelList(
        {required DynamicQRController dynamicQRController}) {
  return [
    FundAddSuccessMedSectionInfoColumnModel(
      title: "Order ID",
      subTitle:
          dynamicQRController.dynamicWalletPaymentDoneModel?.orderId ?? "",
    ),
    FundAddSuccessMedSectionInfoColumnModel(
      title: "Merchant Order ID",
      subTitle:
          dynamicQRController.dynamicWalletPaymentDoneModel?.merchantOrderId ??
              "",
    ),
    FundAddSuccessMedSectionInfoColumnModel(
      title: "UTR Number",
      subTitle: dynamicQRController.dynamicWalletPaymentDoneModel?.utr ?? "",
    ),
    FundAddSuccessMedSectionInfoColumnModel(
      title: "Method",
      subTitle: "Dynamic QR",
      icon: Assets.svgsQr,
    ),
    FundAddSuccessMedSectionInfoColumnModel(
      title: "Transaction Date & Time",
      subTitle:
          "${DateFormatters().mdy.format(dynamicQRController.dynamicWalletPaymentDoneModel?.paidAt ?? getDateTime())} - ${DateFormatters().hMA.format(dynamicQRController.dynamicWalletPaymentDoneModel?.paidAt ?? getDateTime())}",
    ),
  ];
}
