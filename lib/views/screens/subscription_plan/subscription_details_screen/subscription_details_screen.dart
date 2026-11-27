import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/subscription_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_refresh_indicator.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/seleck_payment/seleck_payment_screen/select_payment_screen.dart';
import 'package:lekra/views/screens/dashboard/account_screen/account_screen.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class SubscriptionDetailsScreen extends StatefulWidget {
  final int? subscriptionId;
  const SubscriptionDetailsScreen({super.key, this.subscriptionId});

  @override
  State<SubscriptionDetailsScreen> createState() =>
      _SubscriptionDetailsScreenState();
}

class _SubscriptionDetailsScreenState extends State<SubscriptionDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SubscriptionController>()
          .fetchSubscriptionPlanDetails(id: widget.subscriptionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar2(title: "Plan Details"),
      body:
          GetBuilder<SubscriptionController>(builder: (subscriptionController) {
        if (subscriptionController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final plan = subscriptionController.selectSubscription;
        final hasDiscount = plan?.hasDiscount ?? false;
        final deliveryCount = (plan?.freeDeliveryCount != null && plan!.freeDeliveryCount! > 0)
            ? plan.freeDeliveryCount!
            : 3;
        final maxSubsidy = (plan?.maxShippingSubsidy != null && plan!.maxShippingSubsidy! > 0)
            ? plan.maxShippingSubsidy!
            : 40.0;
        final minOrder = (plan?.minOrderValue != null && plan!.minOrderValue! > 0)
            ? plan.minOrderValue!
            : 199.0;
        final giftWallet = (plan?.giftWalletAmount != null && plan!.giftWalletAmount! > 0)
            ? plan.giftWalletAmount!
            : 25.0;

        List<String> features = plan?.features ?? [];
        if (features.isEmpty) {
          features = [
            "2% Extra Recharge Cashback",
            "3 Free Deliveries Every Month",
            "VIP Customer Support",
            "Exclusive Member-Only Deals",
          ];
        }

        return CustomRefresh(
          onRefresh: () async {
            Get.find<SubscriptionController>()
                .fetchSubscriptionPlanDetails(id: widget.subscriptionId);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: CustomShimmer(
              isLoading: subscriptionController.isLoading,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 2),
                      blurRadius: 10,
                      color: black.withValues(alpha: 0.04),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plan Name
                    Text(
                      plan?.name ?? "VIP Membership Pass",
                      style: Helper(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 24,
                            color: const Color(0xFF0F172A),
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Unlock exclusive savings, zero delivery fees & platform bonuses.",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: const Color(0xFF64748B),
                          ),
                    ),
                    const SizedBox(height: 20),

                    // Price Section
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (hasDiscount)
                            Row(
                              children: [
                                Text(
                                  plan?.priceFormat ?? "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF94A3B8),
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCFCE7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    "Save ${plan?.discountAmountFormat ?? ''}",
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF15803D),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              text: hasDiscount
                                  ? (plan?.discountPriceFormat ?? "")
                                  : (plan?.priceFormat ?? ""),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 32,
                                color: Color(0xFF0F172A),
                              ),
                              children: [
                                TextSpan(
                                  text: " / ${plan?.validityLabel ?? '365 Days (1 Year)'}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (plan?.packageValue != null && plan!.packageValue! > 0) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFBFDBFE)),
                              ),
                              child: Text(
                                "Package Value: ₹${plan.packageValue!.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1D4ED8),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0FDF4),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFBBF7D0)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.receipt_long_outlined, size: 14, color: Color(0xFF15803D)),
                                const SizedBox(width: 4),
                                Text(
                                  "All Prices inclusive of GST • Instant GST Invoice provided",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Member Perks Highlight Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.workspace_premium_rounded, size: 16, color: Color(0xFFD97706)),
                              SizedBox(width: 6),
                              Text(
                                "MEMBER PERKS INCLUDED",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.local_shipping_outlined, size: 18, color: Color(0xFF4F46E5)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "$deliveryCount Free Deliveries (Up to ₹${maxSubsidy.toStringAsFixed(0)} / Min ₹${minOrder.toStringAsFixed(0)})",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.card_giftcard_rounded, size: 18, color: Color(0xFF059669)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "₹${giftWallet.toStringAsFixed(2)} Gift Wallet Credit Bonus",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (plan?.scratchCardValue != null && plan!.scratchCardValue! > 0) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.confirmation_number_outlined, size: 18, color: Color(0xFFD97706)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "VIP Scratch Card: ₹${plan.scratchCardValue!.toStringAsFixed(2)} Value (Price: ₹${(plan.scratchCardPrice ?? 0).toStringAsFixed(0)})",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (plan?.hasFreeDelivery == true) ...[
                            const SizedBox(height: 8),
                            const Row(
                              children: [
                                Icon(Icons.local_shipping_rounded, size: 18, color: Color(0xFF059669)),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Free Delivery Enabled on all qualifying orders",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF047857),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Activate Plan Button
                    ProfileButton(
                      title: "Activate Plan",
                      onPressed: () {
                        final sub = subscriptionController.selectSubscription;
                        final hasDisc = sub?.hasDiscount ?? false;
                        final displayAmount = hasDisc
                            ? (sub?.discountPriceFormat ?? "0.00")
                            : (sub?.priceFormat ?? "0.00");
                        navigate(
                          context: context,
                          page: SelectPaymentScreen(
                            isMemberShipPayment: true,
                            totalAmount: displayAmount,
                          ),
                        );
                      },
                      color: primaryColor,
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(color: Color(0xFFF1F5F9), height: 1),
                    ),

                    // Benefits Header
                    const Text(
                      "Features Included",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),

                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: features.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
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
                                size: 14,
                                color: Color(0xFF059669),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                f,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
