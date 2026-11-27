// dynamic_qr_sheet.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/fund_request_controller.dart';
import 'package:lekra/services/lanch_helper.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';

class UPIDynamicQrSheet {
  /// Shows the bottom sheet. Returns when sheet is dismissed.
  static Future<void> show(BuildContext context) async {
    // int remainingSeconds = _totalSeconds;
    // Timer? modalTimer;
    final controller = Get.find<FundRequestController>();

    // Start polling AFTER first frame

    // If you want to expose a controller-level timer outside, you can start it before calling this.
    // For now we manage a local modal timer and also ensure we cancel any external timers if present.

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return GetBuilder<FundRequestController>(
            builder: (fundRequestController) {
          return SafeArea(
            child: StatefulBuilder(builder: (modalContext, setModalState) {
              String formatMMSS(int seconds) {
                final m = (seconds ~/ 60).toString().padLeft(2, '0');
                final s = (seconds % 60).toString().padLeft(2, '0');
                return '$m:$s';
              }

              return Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: const BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            fundRequestController.stopAllTimers();
                            Navigator.of(modalContext).pop();
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: secondaryColor,
                            child: const Icon(
                              Icons.arrow_back,
                              color: white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Scan to Pay",
                                style: Helper(modalContext)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Amount: ${fundRequestController.upiQRModel?.amount ?? "0"}",
                                style: Helper(modalContext)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: grey,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    QrImageView(
                      data: fundRequestController.upiQRModel?.qrString ?? "",
                      version: QrVersions.auto,
                      size: 300,
                      gapless: true,
                      errorCorrectionLevel: QrErrorCorrectLevel.Q,
                      embeddedImage: const AssetImage(Assets.imagesOnlyLogo),
                      embeddedImageStyle: const QrEmbeddedImageStyle(
                        size: Size(60, 60),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "QR expires in ${formatMMSS(fundRequestController.remainingSeconds)}",
                        style:
                            Helper(modalContext).textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor,
                                ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: white,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              "Open any UPI or Bank's app to scan this QR code. Then enter your UPI PIN to proceed with the payment.",
                              overflow: TextOverflow.clip,
                              style: Helper(modalContext)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: white,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    CustomButton(
                      radius: 5,
                      height: 50,
                      onTap: () {
                        LaunchHelper.launchUpiViaSystemChooser(
                            fundRequestController.upiQRModel?.qrString ?? "");
                      },
                      child: Text(
                        "Pay with UPI App",
                        style:
                            Helper(modalContext).textTheme.bodyMedium?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: white,
                                ),
                      ),
                    )
                  ],
                ),
              );
            }),
          );
        });
      },
    );

    controller.stopAllTimers();
  }
}
