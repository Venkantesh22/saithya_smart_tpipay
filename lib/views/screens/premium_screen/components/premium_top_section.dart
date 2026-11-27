import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/subscription_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class PremiumTopSection extends StatelessWidget {
  const PremiumTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      final sub = authController.userModel?.subscription;
      final planName = sub?.planName?.isNotEmpty == true
          ? sub!.planName!
          : "VIP Member Pass";
      final endDate = sub?.endDateFormat ?? "Active";
      final remainingDays = sub?.remainingDays ?? 0;
      final totalDays = (sub?.totalDays != null && sub!.totalDays! > 0)
          ? sub.totalDays!
          : (remainingDays > 0 ? remainingDays : 90);
      final progress = totalDays > 0
          ? (remainingDays / totalDays).clamp(0.0, 1.0)
          : 1.0;

      final subCtrl = Get.find<SubscriptionController>();
      final selectPlan = subCtrl.selectSubscription;

      // Pricing
      final paidText = (sub?.pricePaid != null && sub?.pricePaid != "0")
          ? sub!.pricePaidFormat
          : (selectPlan?.discountPriceFormat ?? sub?.pricePaidFormat ?? "₹199.00");
      final mrpText = (sub?.price != null && sub?.price != "0")
          ? sub!.priceFormat
          : (selectPlan?.priceFormat ?? "₹399.00");
      final hasDiscount = sub?.hasDiscount ?? (selectPlan?.hasDiscount ?? true);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Luxury VIP Pass Hero Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF1E1B4B), // Deep Royal Indigo
                  Color(0xFF2E1065), // Deep Purple
                  Color(0xFF3B0764), // Rich Plum
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E1065).withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Crown Tag & Active Chip
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7).withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.workspace_premium_rounded,
                            color: Color(0xFFFFD700),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "VIP EXCLUSIVE PASS",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: Color(0xFFFDE68A),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.6),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "ACTIVE",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF34D399),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Plan Name
                Text(
                  planName,
                  style: Helper(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: white,
                        letterSpacing: 0.2,
                      ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            paidText,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFFDE68A),
                            ),
                          ),
                          if (hasDiscount) ...[
                            const SizedBox(width: 6),
                            Text(
                              mrpText,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.6),
                                decoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "Full premium privileges & auto-applied benefits",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: white.withValues(alpha: 0.75),
                  ),
                ),

                const SizedBox(height: 16),
                Divider(color: white.withValues(alpha: 0.15), height: 1),
                const SizedBox(height: 14),

                // Bottom Meta: Valid Till & Remaining Days
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "VALID TILL",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                            color: white.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          endDate,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFFBBF24).withValues(alpha: 0.4),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            size: 14,
                            color: Color(0xFFFBBF24),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "$remainingDays Days Left",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFDE68A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Sleek Validity Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: white.withValues(alpha: 0.15),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 3 Highlights Quick Stats
          Row(
            children: [
              _buildStatCard(
                context,
                icon: Icons.local_shipping_outlined,
                iconColor: const Color(0xFF4F46E5),
                bgColor: const Color(0xFFEEF2FF),
                title: "Free Delivery",
                subtitle: "On Eligible Orders",
              ),
              const SizedBox(width: 10),
              _buildStatCard(
                context,
                icon: Icons.bolt_rounded,
                iconColor: const Color(0xFFD97706),
                bgColor: const Color(0xFFFEF3C7),
                title: "Extra Bonus",
                subtitle: "Recharge Cashback",
              ),
              const SizedBox(width: 10),
              _buildStatCard(
                context,
                icon: Icons.support_agent_rounded,
                iconColor: const Color(0xFF059669),
                bgColor: const Color(0xFFD1FAE5),
                title: "VIP Support",
                subtitle: "Priority Assistance",
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),
              blurRadius: 8,
              color: black.withValues(alpha: 0.03),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
