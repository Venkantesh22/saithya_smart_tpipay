import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/subscription_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class SubscriptionDetailsPerksSection extends StatelessWidget {
  const SubscriptionDetailsPerksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(
      builder: (controller) {
        final model = controller.selectSubscriptionHistoryModel;

        final deliveryCount = (model?.freeDeliveryCount != null && model!.freeDeliveryCount! > 0)
            ? model.freeDeliveryCount!
            : 3;
        final maxSubsidy = (model?.maxShippingSubsidy != null && model!.maxShippingSubsidy! > 0)
            ? model.maxShippingSubsidy!
            : 40.0;
        final minOrder = (model?.minOrderValue != null && model!.minOrderValue! > 0)
            ? model.minOrderValue!
            : 199.0;
        final giftWallet = (model?.giftWalletAmount != null && model!.giftWalletAmount! > 0)
            ? model.giftWalletAmount!
            : 25.0;

        List<String> features = model?.features ?? [];
        if (features.isEmpty && model?.plan?.features != null && model!.plan!.features.isNotEmpty) {
          features = model.plan!.features;
        }
        if (features.isEmpty) {
          features = [
            "2% Extra Recharge Cashback",
            "3 Free Deliveries Every Month",
            "VIP Customer Support",
            "Exclusive Member-Only Deals",
          ];
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: white,
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 8,
                color: black.withValues(alpha: 0.03),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.workspace_premium_rounded,
                      color: Color(0xFFD97706),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Member Perks & Benefits",
                          style: Helper(context).textTheme.bodyLarge?.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "All privileges unlocked with this pass",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(color: Color(0xFFF1F5F9), height: 1),
              const SizedBox(height: 14),

              // Highlight Perks Banner
              const Text(
                "MEMBER PERKS",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 10),

              // Free Deliveries Perk
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.local_shipping_rounded,
                        color: Color(0xFF4F46E5),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$deliveryCount Free Deliveries",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Up to ₹${maxSubsidy.toStringAsFixed(0)} shipping subsidy on min order ₹${minOrder.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "ACTIVE",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Gift Wallet Perk
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.card_giftcard_rounded,
                        color: Color(0xFFD97706),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "₹${giftWallet.toStringAsFixed(2)} Gift Wallet Credit",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Credited directly to gift wallet for platform usage",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "CREDITED",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Divider(color: Color(0xFFF1F5F9), height: 1),
              const SizedBox(height: 14),

              // Features Included List
              const Text(
                "FEATURES INCLUDED",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 10),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: features.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final f = features[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFECFDF5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 13,
                          color: Color(0xFF059669),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          f,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
