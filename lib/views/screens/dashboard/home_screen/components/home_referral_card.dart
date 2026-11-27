import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:share_plus/share_plus.dart';

class HomeReferralCard extends StatelessWidget {
  const HomeReferralCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        final referralCode = authController.userModel?.referralCode ?? "";
        if (referralCode.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: const EdgeInsets.only(top: 8, bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF38BDF8).withOpacity(0.4), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Badge & Title Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF38BDF8).withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.card_giftcard_rounded,
                          color: Color(0xFF38BDF8),
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Refer & Earn Lifetime Rewards",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0284C7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      "15 LEVELS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const Text(
                "Invite friends to Sathiya Pay and earn multi-tier residual bonuses on every recharge and purchase they make.",
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11,
                  height: 1.35,
                ),
              ),

              const SizedBox(height: 12),

              // Code Box with Copy & Share Actions
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF020617),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "YOUR REFERRAL CODE",
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          SelectableText(
                            referralCode,
                            style: const TextStyle(
                              color: Color(0xFF38BDF8),
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Copy Button
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: referralCode));
                        HapticFeedback.lightImpact();
                        Get.snackbar(
                          "Copied!",
                          "Referral code $referralCode copied to clipboard.",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.black87,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.copy_rounded, color: Color(0xFFE2E8F0), size: 13),
                            SizedBox(width: 4),
                            Text(
                              "Copy",
                              style: TextStyle(
                                color: Color(0xFFE2E8F0),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 6),

                    // WhatsApp / Share Button
                    InkWell(
                      onTap: () {
                        final shareMessage =
                            "Hey! Join Sathiya Pay using my referral code $referralCode to get instant scratch cards, cashback & recharge rewards.\nDownload now: https://test.sathiyasmart.com/app?ref=$referralCode";
                        Share.share(shareMessage, subject: "Join Sathiya Pay with my Referral Code");
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF16A34A), Color(0xFF15803D)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.share_rounded, color: Colors.white, size: 13),
                            SizedBox(width: 4),
                            Text(
                              "Share",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
