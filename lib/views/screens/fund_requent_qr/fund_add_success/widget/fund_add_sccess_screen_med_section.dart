

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/dynamic_qr_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/screens/fund_requent_qr/fund_add_success/widget/fund_add_sucsess_screen_med_section_column_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class FundAddSuccessScreenMedSection extends StatefulWidget {
  final ScreenshotController screenshotController;

  const FundAddSuccessScreenMedSection({
    super.key,
    required this.screenshotController,
  });

  @override
  State<FundAddSuccessScreenMedSection> createState() =>
      _FundAddSuccessScreenMedSectionState();
}

class _FundAddSuccessScreenMedSectionState
    extends State<FundAddSuccessScreenMedSection> {

  /// ✅ FIXED SHARE FUNCTION
  Future<void> shareFullReceipt() async {
    try {
      final Uint8List? image = await widget.screenshotController.capture();

      if (image == null) return;

      final directory = await getTemporaryDirectory();
      final File imageFile =
          File('${directory.path}/receipt_${DateTime.now().millisecondsSinceEpoch}.png');

      await imageFile.writeAsBytes(image);

      final params = ShareParams(
        text:
            'Successfully added fund to wallet. Transaction receipt from ${AppConstants.appName}',
        files: [XFile(imageFile.path)],
      );

      final result = await SharePlus.instance.share(params);

      if (result.status == ShareResultStatus.success) {
        debugPrint('Shared successfully');
      }
    } catch (e) {
      debugPrint("Share Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DynamicQRController>(
      builder: (dynamicQRController) {
        final list = fundAddSuccessMedSectionInfoColumnModelList(
          dynamicQRController: dynamicQRController,
        );

        return Container(
          padding: const EdgeInsets.all(32),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 12),
                blurRadius: 32,
                color: blueLight.withValues(alpha: 0.06),
              ),
            ],
          ),
          child: Column(
            children: [
              /// ✅ FIX: NO OVERFLOW
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return FundAddSuccessMedSectionInfoColumn(
                    fundAddSuccessMedSectionInfoColumnModel: list[index],
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 16),
              ),

              const SizedBox(height: 24),

              /// ✅ SHARE BUTTON
              CustomButton(
                radius: 12,
                borderColor: const Color(0xFFEFF4FF),
                color: const Color(0xFFEFF4FF),
                onTap: shareFullReceipt,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.svgsShare,
                      height: 15,
                      width: 13.5,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "SHARE RECEIPT",
                      style: Helper(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: blueDark,
                          ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}