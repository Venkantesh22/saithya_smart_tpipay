import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/subscription_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/premium_screen/components/premium_benefit_container.dart';
import 'package:lekra/views/screens/subscription_plan/subscription_category/subscription_category_screen.dart';
import 'package:lekra/views/screens/subscription_plan/subscription_history/subscription_history_details/subscription_history_details_screen.dart';

class PremiumBottomSection extends StatelessWidget {
  const PremiumBottomSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(
      builder: (subscriptionController) {
        final authSub = Get.find<AuthController>().userModel?.subscription;
        final selectPlan = subscriptionController.selectSubscription;

        final deliveryCount = selectPlan?.freeDeliveryCount != null && selectPlan!.freeDeliveryCount! > 0
            ? selectPlan.freeDeliveryCount!
            : (authSub?.freeDeliveryCount != null && authSub!.freeDeliveryCount! > 0
                ? authSub.freeDeliveryCount!
                : 3);

        final maxSubsidy = selectPlan?.maxShippingSubsidy != null && selectPlan!.maxShippingSubsidy! > 0
            ? selectPlan.maxShippingSubsidy!
            : (authSub?.maxShippingSubsidy != null && authSub!.maxShippingSubsidy! > 0
                ? authSub.maxShippingSubsidy!
                : 40.0);

        final minOrder = selectPlan?.minOrderValue != null && selectPlan!.minOrderValue! > 0
            ? selectPlan.minOrderValue!
            : (authSub?.minOrderValue != null && authSub!.minOrderValue! > 0
                ? authSub.minOrderValue!
                : 199.0);

        final giftWallet = selectPlan?.giftWalletAmount != null && selectPlan!.giftWalletAmount! > 0
            ? selectPlan.giftWalletAmount!
            : (authSub?.giftWalletAmount != null && authSub!.giftWalletAmount! > 0
                ? authSub.giftWalletAmount!
                : 25.0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    size: 16,
                    color: Color(0xFF059669),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Guaranteed Member Perks",
                  style: Helper(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.only(left: 2),
              child: Text(
                "Exclusive core assurances active on your pass",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // Free Delivery Card
            PremiumBenefitContainer(
              image: Assets.imagesGiftPremium,
              title: "$deliveryCount Free Deliveries Unlocked",
              desc:
                  "Enjoy $deliveryCount free priority deliveries (up to ₹${maxSubsidy.toStringAsFixed(0)} shipping subsidy on eligible orders above ₹${minOrder.toStringAsFixed(0)}) across all platform merchants.",
              badgeText: "UNLOCKED",
              accentColor: const Color(0xFF4F46E5),
            ),

            const SizedBox(height: 12),

            // Gift Wallet Bonus Card
            PremiumBenefitContainer(
              image: Assets.imagesGrowPremium,
              title: "₹${giftWallet.toStringAsFixed(2)} Gift Wallet Credit",
              desc:
                  "Instant credit added to your gift wallet balance, usable for mobile recharges, bill payments, and discounted store purchases.",
              badgeText: "ACTIVE",
              accentColor: const Color(0xFF059669),
            ),

            const SizedBox(height: 12),

            // Priority Support Card
            const PremiumBenefitContainer(
              image: Assets.imagesGrowPremium,
              title: "VIP Priority Support Desk",
              desc:
                  "Direct fast-track resolution via senior account managers. Your support tickets and refund requests receive priority queue status 24/7.",
              badgeText: "24/7 ACTIVE",
              accentColor: Color(0xFFD97706),
            ),

            const SizedBox(height: 20),

            // View Invoice & Receipt Button
            if (authSub != null) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    backgroundColor: white,
                    side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    subscriptionController.updateSubscriptionHistoryModel(value: authSub);
                    navigate(
                      context: context,
                      page: const SubscriptionHistoryDetailsScreen(),
                    );
                  },
                  icon: const Icon(
                    Icons.receipt_long_rounded,
                    color: Color(0xFF0F172A),
                    size: 18,
                  ),
                  label: const Text(
                    "View Membership Invoice & Receipt",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Renew / Explore Plans Button
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor,
                      const Color(0xFF4338CA),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      navigate(
                        context: context,
                        page: const SubscriptionCategoryPlan(),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.card_membership_rounded,
                            color: Color(0xFFFDE68A),
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Upgrade or Renew Membership",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: white,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: white,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Trust Badge & Footer Note
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "All benefits apply automatically during checkout & recharges.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
