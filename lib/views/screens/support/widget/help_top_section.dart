import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/services/theme.dart';

class HelpTopSection extends StatelessWidget {
  const HelpTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BasicController>(builder: (basicController) {
      final hours = basicController.supportModel?.hours?.isNotEmpty == true
          ? basicController.supportModel!.hours!
          : "24/7 Dedicated Support Desk";

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0F172A), // Slate 900
              Color(0xFF1E293B), // Slate 800
              Color(0xFF334155), // Slate 700
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Active status & Support badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.headset_mic_rounded,
                        color: Color(0xFF38BDF8),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "CUSTOMER CARE",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Color(0xFF7DD3FC),
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
                      color: const Color(0xFF10B981).withValues(alpha: 0.5),
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
                        "ONLINE",
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

            const SizedBox(height: 16),

            // Headline
            const Text(
              "How can we help you today?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: white,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Connect directly with our dedicated concierge team for orders, payments, refunds, and technical assistance.",
              style: TextStyle(
                fontSize: 12,
                height: 1.45,
                fontWeight: FontWeight.w400,
                color: white.withValues(alpha: 0.8),
              ),
            ),

            const SizedBox(height: 16),
            Divider(color: white.withValues(alpha: 0.15), height: 1),
            const SizedBox(height: 12),

            // Timings row
            Row(
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: Color(0xFFFDE68A),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    hours,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFEF3C7),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
