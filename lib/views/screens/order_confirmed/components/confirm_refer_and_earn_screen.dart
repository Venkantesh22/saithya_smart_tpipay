import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:share_plus/share_plus.dart';

class ConfirmReferAndEarnScreen extends StatelessWidget {
  const ConfirmReferAndEarnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 6),
              blurRadius: 6,
              spreadRadius: 0,
              color: black.withValues(alpha: 0.10),
            ),
            BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 0,
              color: black.withValues(alpha: 0.10),
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Refer and Earn",
            style: Helper(context).textTheme.titleLarge?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            "Earn on you friend's first order.",
            style: Helper(context).textTheme.titleLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          GetBuilder<AuthController>(builder: (authController) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  onTap: () {
                    String message =
                        "Use my referral code: ${authController.userModel?.referralCode}";

                    // If there's a referral link, append it to the message
                    if (authController.userModel?.referralLink != null) {
                      message += "\n${authController.userModel?.referralLink} ";
                    }

                    SharePlus.instance.share(ShareParams(
                      text: message,
                    ));
                  },
                  color: secondaryColor,
                  radius: 100,
                  child: Text(
                    "Refer Now",
                    style: Helper(context).textTheme.titleLarge?.copyWith(
                          fontSize: 16,
                          color: white,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const Icon(
                  Icons.emoji_emotions_outlined,
                  size: 40,
                )
              ],
            );
          })
        ],
      ),
    );
  }
}
