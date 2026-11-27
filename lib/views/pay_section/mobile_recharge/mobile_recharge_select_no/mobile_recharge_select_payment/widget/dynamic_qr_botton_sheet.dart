// dynamic_qr_sheet.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/dynamic_qr_controller.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class DynamicQrSheet {
  static Future<void> show(BuildContext context) async {
    final controller = Get.find<DynamicQRController>();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return GetBuilder<DynamicQRController>(builder: (dynamicQRController) {
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
                            dynamicQRController.stopAllTimers();
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
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CustomShimmer(
                      isLoading: dynamicQRController.isLoading,
                      child: QrImageView(
                        data: dynamicQRController.dynamicModel?.qrString ?? "",
                        version: QrVersions.auto,
                        size: 300,
                        gapless: true,
                        errorCorrectionLevel: QrErrorCorrectLevel.Q,
                        embeddedImage: const AssetImage(Assets.imagesOnlyLogo),
                        embeddedImageStyle: const QrEmbeddedImageStyle(
                          size: Size(60, 60),
                        ),
                      ),
                    ),
                    Text(
                      "Total Amount",
                      style: Helper(context).textTheme.headlineSmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: greyText2,
                          ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹",
                          style:
                              Helper(context).textTheme.displaySmall?.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: greyText2,
                                  ),
                        ),
                        Text(
                          dynamicQRController.dynamicModel?.formatAmount
                                  .replaceAll("₹", "") ??
                              "",
                          style:
                              Helper(context).textTheme.displaySmall?.copyWith(
                                    fontSize: 48,
                                    fontWeight: FontWeight.w800,
                                    color: greyText2,
                                  ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "QR expires in ${formatMMSS(dynamicQRController.remainingSeconds)}",
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
                      margin: const EdgeInsets.all(16),
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
