import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/subscription_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class PremiumMediumSection extends StatelessWidget {
  const PremiumMediumSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(
      builder: (subscriptionController) {
        final authSub = Get.find<AuthController>().userModel?.subscription;
        final selectPlan = subscriptionController.selectSubscription;

        List<String> features = [];
        if (selectPlan?.features != null && selectPlan!.features.isNotEmpty) {
          features = selectPlan.features;
        } else if (authSub?.features != null && authSub!.features.isNotEmpty) {
          features = authSub.features;
        }

        final planName = selectPlan?.name ?? authSub?.effectivePlanName ?? "Silver VIP Member Pass";

        final effectiveFeatures = features.isNotEmpty
            ? features
            : [
                "2% Extra Recharge Cashback on all operators",
                "3 Free Deliveries Every Month on grocery & orders",
                "VIP Customer Support with priority resolution",
                "Exclusive Member-Only Deals & Seasonal Offers",
              ];

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          size: 16,
                          color: Color(0xFFD97706),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Plan Privileges",
                        style: Helper(context).textTheme.titleMedium?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${effectiveFeatures.length} Active Perks",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  "Included with your $planName",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Features List
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: effectiveFeatures.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final feature = effectiveFeatures[index];
                  final iconData = _getFeatureIcon(feature);
                  final colorData = _getFeatureColor(index);

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 2),
                          blurRadius: 6,
                          color: black.withValues(alpha: 0.02),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorData['bg'],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            iconData,
                            size: 18,
                            color: colorData['color'],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                              height: 1.35,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.check_circle_rounded,
                          size: 18,
                          color: Color(0xFF10B981),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getFeatureIcon(String feature) {
    final lower = feature.toLowerCase();
    if (lower.contains("cashback") || lower.contains("recharge")) {
      return Icons.bolt_rounded;
    } else if (lower.contains("delivery") || lower.contains("deliveries")) {
      return Icons.local_shipping_rounded;
    } else if (lower.contains("support") || lower.contains("help")) {
      return Icons.support_agent_rounded;
    } else if (lower.contains("wallet") || lower.contains("gift")) {
      return Icons.card_giftcard_rounded;
    } else if (lower.contains("deal") || lower.contains("discount") || lower.contains("exclusive")) {
      return Icons.local_offer_rounded;
    }
    return Icons.star_rounded;
  }

  Map<String, dynamic> _getFeatureColor(int index) {
    final colors = [
      {'color': const Color(0xFF4F46E5), 'bg': const Color(0xFFEEF2FF)},
      {'color': const Color(0xFF059669), 'bg': const Color(0xFFD1FAE5)},
      {'color': const Color(0xFFD97706), 'bg': const Color(0xFFFEF3C7)},
      {'color': const Color(0xFFDC2626), 'bg': const Color(0xFFFEE2E2)},
      {'color': const Color(0xFF7C3AED), 'bg': const Color(0xFFEDE9FE)},
    ];
    return colors[index % colors.length];
  }
}
