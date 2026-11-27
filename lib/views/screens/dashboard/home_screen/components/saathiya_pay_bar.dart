import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/screens/dashboard/wallet/wallet_screen/wallet_screen.dart';
import 'package:lekra/views/screens/rewards/screen/rewards_screen/rewards_screen.dart';
import 'package:lekra/views/screens/spin_wheel/spin_wheel_screen.dart';
import 'package:lekra/views/screens/subscription_plan/subscription_category/subscription_category_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SaathiyaPayBar extends StatelessWidget {
  const SaathiyaPayBar({super.key});

  Future<void> _openWhatsApp() async {
    const String phone = "919876543210";
    const String message = "Hello Sathiya Pay Support, I need assistance with my account.";
    final Uri url = Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(message)}");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(url, mode: LaunchMode.platformDefault);
      }
    } catch (_) {
      Get.snackbar("Support", "Could not open WhatsApp support.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        final user = authController.userModel;
        final double walletBalance = user?.currentWallet ?? 0.0;
        final double cashbackBalance = user?.cashbackWallet ?? 0.0;
        final int coins = user?.rewardPoint ?? 0;
        final bool isPrime = user?.subscription != null;

        return Container(
          margin: const EdgeInsets.only(top: 14, bottom: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF312E81).withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // Upper Strip: Amazon-style Saathiya Pay & Prime Status
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Saathiya Pay + Balance
                    InkWell(
                      onTap: () => navigate(context: context, page: const WalletScreen()),
                      borderRadius: BorderRadius.circular(10),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade400,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.bolt_rounded,
                              color: Color(0xFF1E1B4B),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 9),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Saathiya Pay",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "₹${walletBalance.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF065F46),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      "Cashback: ₹${cashbackBalance.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Color(0xFFA7F3D0),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  if (coins > 0) ...[
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFB45309),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        "Coins: $coins",
                                        style: const TextStyle(
                                          color: Color(0xFFFEF3C7),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.amber.shade300,
                                    size: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Join Prime or Active VIP Badge
                    InkWell(
                      onTap: () => navigate(
                          context: context,
                          page: const SubscriptionCategoryPlan()),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: isPrime
                              ? const LinearGradient(
                                  colors: [Color(0xFFF59E0B), Color(0xFFD97706)])
                              : LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.18),
                                    Colors.white.withOpacity(0.08),
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isPrime
                                ? Colors.amber.shade300
                                : Colors.amber.shade400,
                            width: 1.2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.workspace_premium_rounded,
                              color: isPrime ? Colors.white : Colors.amber.shade300,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isPrime ? "Prime VIP Active" : "Join Prime",
                              style: TextStyle(
                                color: isPrime ? Colors.white : Colors.amber.shade300,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white12, height: 1, thickness: 1),

              // Bottom 4 Quick Action Pills
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickAction(
                      context,
                      icon: Icons.casino_outlined,
                      label: "Daily Spin",
                      badge: "WIN",
                      badgeColor: Colors.redAccent,
                      onTap: () => navigate(
                          context: context, page: const SpinWheelPage()),
                    ),
                    _buildQuickAction(
                      context,
                      icon: Icons.card_giftcard_rounded,
                      label: "Scratch & Win",
                      badge: "CASH",
                      badgeColor: Colors.amber.shade700,
                      onTap: () => navigate(
                          context: context, page: const RewardsScreen()),
                    ),
                    _buildQuickAction(
                      context,
                      icon: Icons.stars_rounded,
                      label: "Prime Plans",
                      onTap: () => navigate(
                          context: context,
                          page: const SubscriptionCategoryPlan()),
                    ),
                    _buildQuickAction(
                      context,
                      icon: Icons.chat_bubble_outline_rounded,
                      label: "WhatsApp",
                      badge: "HELP",
                      badgeColor: const Color(0xFF22C55E),
                      onTap: _openWhatsApp,
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

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? badge,
    Color? badgeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (badge != null)
                  Positioned(
                    top: -5,
                    right: -7,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: badgeColor ?? Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
