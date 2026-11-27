import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/rewards/screen/rewards_screen/rewards_screen.dart';

class ProfileBalanceSection extends StatelessWidget {
  const ProfileBalanceSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      final user = authController.userModel;
      final int coins = user?.rewardPoint ?? 0;
      final double coinsInRupees = coins / 10.0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomImage(
            path: user?.image ?? "",
            height: 70,
            width: 70,
            radius: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 8),
          Text(
            capitalize(user?.fullName ?? ""),
            style: Helper(context).textTheme.titleSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),

          // 3-Wallet Layout: Main Wallet, Cashback Wallet, and Coin Wallet
          GetBuilder<WalletController>(builder: (walletController) {
            final mainWalletBal = walletController.walletModel?.walletBalance ?? "₹0.00";
            final cashbackBal = walletController.walletModel?.cashbackBalance ?? "₹0.00";

            return Column(
              children: [
                // Row 1: Dual Wallets - Main Wallet & Cashback Wallet
                Row(
                  children: [
                    // 1. Main Wallet Card
                    Expanded(
                      child: _buildWalletCard(
                        context: context,
                        title: "Main Wallet",
                        badge: "MAIN",
                        balance: mainWalletBal,
                        icon: Icons.account_balance_wallet_rounded,
                        gradientColors: const [Color(0xFF1E1B4B), Color(0xFF312E81)],
                        iconBgColor: Colors.amber.shade400,
                        iconColor: const Color(0xFF1E1B4B),
                        badgeColor: Colors.amberAccent,
                      ),
                    ),
                    const SizedBox(width: 10),

                    // 2. Cashback Wallet Card
                    Expanded(
                      child: _buildWalletCard(
                        context: context,
                        title: "Cashback Wallet",
                        badge: "CASHBACK",
                        balance: cashbackBal,
                        icon: Icons.savings_rounded,
                        gradientColors: const [Color(0xFF047857), Color(0xFF065F46)],
                        iconBgColor: const Color(0xFFA7F3D0),
                        iconColor: const Color(0xFF065F46),
                        badgeColor: const Color(0xFFA7F3D0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Row 2: 3. Coin Wallet Card (Reward Points from Scratch / Spin)
                InkWell(
                  onTap: () {
                    navigate(context: context, page: const RewardsScreen());
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF92400E), Color(0xFFD97706), Color(0xFFF59E0B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD97706).withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFEF3C7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.generating_tokens_rounded, size: 20, color: Color(0xFF92400E)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "$coins Coins",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "≈ ₹${coinsInRupees.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                "Coin Wallet • 10 Coins = ₹1 Cashback",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Convert",
                            style: TextStyle(
                              color: Color(0xFF92400E),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      );
    });
  }

  Widget _buildWalletCard({
    required BuildContext context,
    required String title,
    required String badge,
    required String balance,
    required IconData icon,
    required List<Color> gradientColors,
    required Color iconBgColor,
    required Color iconColor,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: iconColor),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            balance,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
