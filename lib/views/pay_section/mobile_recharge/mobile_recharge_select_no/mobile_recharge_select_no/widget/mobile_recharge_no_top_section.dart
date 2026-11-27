import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/permission_controller.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/pay_section/mobile_recharge/contact_list/contact_list_screen.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class MobileRechargeNoTopSection extends StatefulWidget {
  const MobileRechargeNoTopSection({
    super.key,
  });

  @override
  State<MobileRechargeNoTopSection> createState() =>
      _MobileRechargeNoTopSectionState();
}

class _MobileRechargeNoTopSectionState
    extends State<MobileRechargeNoTopSection> {
  void mobileRecharge(RechargeController rechargeController) async {
    final permCtrl = Get.find<PermissionController>();
    final granted = await permCtrl.askWithDialogIfPermanentlyDenied();
    if (!granted) return;

    final selectedNumber = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const ContactsListScreen()),
    );

    if (selectedNumber != null && selectedNumber.isNotEmpty) {
      String clean = selectedNumber.replaceAll(RegExp(r'[^0-9]'), '');

      if (clean.length > 10) {
        clean = clean.substring(clean.length - 10);
      }

      rechargeController.mobileNoController.text = clean;

      if (clean.length == 10) {
        // _triggerRechargeAPIs(clean, rechargeController);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RechargeController>(builder: (rechargeController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Top-Up",
            overflow: TextOverflow.ellipsis,
            style: Helper(context).textTheme.headlineSmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: rustyOrange,
                letterSpacing: 0.6),
          ),
          SizedBox(height: 8.5),
          Text(
            "Recharge Now",
            overflow: TextOverflow.ellipsis,
            style: Helper(context).textTheme.displaySmall?.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: blackText,
                ),
          ),
          SizedBox(height: 8.5),
          Text(
            "Enter your connection details to discover tailored mobile plans.",
            style: Helper(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: greyText2,
                ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
          AppTextFieldWithHeading(
            bgColor: Color(0xFFDCE9FF),
            borderColor: Color(0xFFDCE9FF),
            controller: rechargeController.mobileNoController,
            hindText: "98765 43210",
            preFixWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    top: 16.5,
                    bottom: 16.5,
                  ),
                  child: SvgPicture.asset(
                    Assets.svgsMobile,
                    height: 22,
                    width: 27,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  "+91 ",
                  style: Helper(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF717785),
                      ),
                ),
              ],
            ),
            suffix: GestureDetector(
              onTap: () => mobileRecharge(rechargeController),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: CustomImage(
                  path: Assets.imagesContext,
                  height: 15,
                  width: 14,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Enter a Mobile number";
              }
              if (value.length != 10) {
                return "Enter a 10 Digit number";
              }
              return null;
            },
            headingWidget: Text(
              "ENTER MOBILE NUMBER",
              style: Helper(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: greyText2,
                    letterSpacing: 1,
                  ),
            ),
          ),
        ],
      );
    });
  }
}
