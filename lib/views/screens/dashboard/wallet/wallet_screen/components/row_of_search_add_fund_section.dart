import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/fund_requent_qr/fund_requent/fund_requent_qr_screen.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class RowOFSearchAndAddFundButtonSection extends StatefulWidget {
  const RowOFSearchAndAddFundButtonSection({
    super.key,
  });

  @override
  State<RowOFSearchAndAddFundButtonSection> createState() =>
      _RowOFSearchAndAddFundButtonSectionState();
}

class _RowOFSearchAndAddFundButtonSectionState
    extends State<RowOFSearchAndAddFundButtonSection> {
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: [
            Expanded(
              child: AppTextFieldWithHeading(
                borderColor: primaryColor,
                controller: walletController.walletSearchController,
                hindText: "Search",
                preFixWidget: const Icon(
                  Icons.search,
                  color: greyBillText,
                ),
                suffix: GestureDetector(
                  onTap: () async {
                    // 1. Open the date picker dialog
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    // 2. Handle the result
                    if (pickedDate != null) {
                      final displayDate =
                          DateFormatters().dMyDash.format(pickedDate); // UI
                      final apiDate =
                          DateFormatters().yMD.format(pickedDate); // API

                      walletController.walletSearchController.text =
                          displayDate;

                      walletController.fetchWalletTransaction(
                        filterType: WalletFilterType.date,
                        filterValue: apiDate,
                      );
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: CustomImage(
                      path: Assets.imagesCalender,
                      height: 24,
                      width: 24,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (timer?.isActive ?? false) timer!.cancel();

                  timer = Timer(const Duration(milliseconds: 500), () {
                    if (value.isEmpty) {
                      walletController.fetchWalletTransaction(
                        filterType: WalletFilterType.none,
                        refresh: true,
                      );
                    } else {
                      walletController.fetchWalletTransaction(
                        filterType: WalletFilterType.amount,
                        filterValue: value.trim(),
                      );
                    }
                  });
                },
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            CustomButton(
              onTap: () {
                navigate(context: context, page: const FundRequestQrScreen());
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    Assets.svgsCheckInCircle,
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Add Fund",
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                          color: white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
