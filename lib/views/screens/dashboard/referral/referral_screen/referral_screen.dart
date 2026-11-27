import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/referral_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/base/custom_refresh_indicator.dart';
import 'package:lekra/views/screens/dashboard/referral/referral_screen/components/referral_level_section.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';
import 'package:share_plus/share_plus.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ReferralController>().fetchReferral();
      Get.find<ReferralController>().fetchReferralLevel();
    });
  }

  bool useLevelView = false;

  void copyReferralCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
  }

  void shareReferralCode(String code, String? link) {
    final downloadLink = (link != null && link.isNotEmpty && !link.contains("saathiyapay.com"))
        ? link
        : "https://test.sathiyasmart.com/app?ref=$code";
    String message =
        "Hey! Join Sathiya Pay using my referral code $code to get instant scratch cards, cashback & recharge rewards.\n\nDownload now: $downloadLink";

    // Pass the combined message to the text parameter
    SharePlus.instance.share(
      ShareParams(
        text: message,
        subject: "Join Sathiya Pay with my Referral Code",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefresh(
      onRefresh: () async {
        Get.find<ReferralController>().fetchReferral();
        Get.find<ReferralController>().fetchReferralLevel();
      },
      child: Scaffold(
        appBar: const CustomAppBar2(
          title: "Referral Structure",
          showBackButton: false,
        ),
        body: Padding(
          padding: AppConstants.screenPadding,
          child: Column(
            children: [
              // Top user info card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: GetBuilder<AuthController>(builder: (authController) {
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        child: CustomImage(
                          width: 90,
                          height: 90,
                          radius: 45,
                          path: authController.userModel?.image ?? "",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    capitalize(
                                        authController.userModel?.fullName ??
                                            ""),
                                    overflow: TextOverflow.clip,
                                    style: Helper(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    capitalize(authController.userModel
                                            ?.referredLevel?.currentRank ??
                                        ""),
                                    overflow: TextOverflow.clip,
                                    style: Helper(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: secondaryColor,
                                            fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authController.userModel?.referralCode ?? "",
                        style: Helper(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.grey),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => copyReferralCode(context,
                                authController.userModel?.referralCode ?? ""),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            icon: const Icon(Icons.copy, size: 18),
                            label: const Text("Copy"),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () => shareReferralCode(
                                authController.userModel?.referralCode ?? "",
                                authController.userModel?.referralLinks?.app ??
                                    ""),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            icon:
                                const Icon(Icons.share, size: 18, color: white),
                            label: Text(
                              "Share",
                              style: Helper(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 16),
              Expanded(child: ReferralLevelSection())
            ],
          ),
        ),
      ),
    );
  }
}
