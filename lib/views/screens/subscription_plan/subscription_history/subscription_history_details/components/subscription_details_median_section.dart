import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/subscription_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class SubscriptionDetailsMedianSection extends StatelessWidget {
  const SubscriptionDetailsMedianSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(
      builder: (controller) {
        final model = controller.selectSubscriptionHistoryModel;
        final planName = model?.effectivePlanName ?? "VIP Membership";
        final startDate = model?.startDateFormat ?? "";
        final endDate = model?.endDateFormat ?? "";
        final remaining = model?.remainingDays ?? 0;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Subscription Service Period",
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                  ),
                  if (remaining > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "$remaining Days Left",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "$planName for $startDate - $endDate",
                style: Helper(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF64748B),
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}
