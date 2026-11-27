import 'package:flutter/material.dart';
import 'package:lekra/data/models/subscription/subscription_history_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/subscription_plan/subscription_history/subscription_history_screen/components/subscription_status_container.dart';

class SubscriptionHistoryWidget extends StatelessWidget {
  final SubscriptionHistoryModel subscriptionHistoryModel;
  const SubscriptionHistoryWidget({
    super.key,
    required this.subscriptionHistoryModel,
  });

  @override
  Widget build(BuildContext context) {
    final paidText = (subscriptionHistoryModel.pricePaid != null && subscriptionHistoryModel.pricePaid != "0")
        ? subscriptionHistoryModel.pricePaidFormat
        : (subscriptionHistoryModel.discountPrice != null && subscriptionHistoryModel.discountPrice != "0"
            ? subscriptionHistoryModel.discountPriceFormat
            : subscriptionHistoryModel.priceFormat);

    final originalPrice = subscriptionHistoryModel.priceFormat;
    final hasDiscount = subscriptionHistoryModel.hasDiscount;

    final deliveryCount = (subscriptionHistoryModel.freeDeliveryCount != null && subscriptionHistoryModel.freeDeliveryCount! > 0)
        ? subscriptionHistoryModel.freeDeliveryCount!
        : 3;
    final giftWallet = (subscriptionHistoryModel.giftWalletAmount != null && subscriptionHistoryModel.giftWalletAmount! > 0)
        ? subscriptionHistoryModel.giftWalletAmount!
        : 25.0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: white,
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
        borderRadius: BorderRadius.circular(14),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  subscriptionHistoryModel.effectivePlanName,
                  style: Helper(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    paidText,
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                        ),
                  ),
                  if (hasDiscount)
                    Text(
                      originalPrice,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subscriptionHistoryModel.startDateFormat,
                style: Helper(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SubscriptionStatusContainer(
                isActive: subscriptionHistoryModel.isActive,
              ),
            ],
          ),

          const SizedBox(height: 10),
          // Perks chips
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.local_shipping_outlined,
                      size: 13,
                      color: Color(0xFF4F46E5),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$deliveryCount Free Deliveries",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.card_giftcard_rounded,
                      size: 13,
                      color: Color(0xFFD97706),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "₹${giftWallet.toStringAsFixed(0)} Gift Bonus",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD97706),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 8),
          Text(
            "${subscriptionHistoryModel.effectivePlanName} (${subscriptionHistoryModel.startDateFormat} - ${subscriptionHistoryModel.endDateFormat})",
            style: Helper(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 12,
                  color: const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
