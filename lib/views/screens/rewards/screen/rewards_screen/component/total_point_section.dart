import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/reward_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/rewards/screen/reward_history_screen/reward_history_screen.dart';

class TotalPointSection extends StatelessWidget {
  const TotalPointSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: black.withValues(alpha: 0.1),
                blurRadius: 6,
                spreadRadius: 0,
                offset: const Offset(0, 6))
          ]),
      child: Column(
        children: [
          GetBuilder<AuthController>(builder: (authController) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Coins",
                        style: Helper(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 14, color: grey)),
                    const SizedBox(height: 4),
                    Text(
                      "${authController.userModel?.rewardPoint ?? ""} coins",
                      style: Helper(context).textTheme.titleSmall?.copyWith(
                          color: primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Icon(
                  Icons.military_tech,
                  size: 50,
                  color: greyBorder,
                )
              ],
            );
          }),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () {
              navigate(context: context, page: const RewardHistoryScreen());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "10 coins = ₹ 1",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: secondaryColor,
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Text(
                      "View Rewards History",
                      overflow: TextOverflow.clip,
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          color: secondaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showConvertDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 11),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              icon: const Icon(Icons.currency_rupee_rounded, size: 16, color: Colors.white),
              label: const Text(
                "Convert Coins to Cashback Wallet",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConvertDialog(BuildContext context) {
    final authController = Get.find<AuthController>();
    final currentCoins = authController.userModel?.rewardPoint ?? 0;
    final textController = TextEditingController(text: currentCoins >= 10 ? "50" : "0");
    double estimatedCash = (int.tryParse(textController.text) ?? 0) / 10.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Convert Coins to Cashback",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Balance: $currentCoins Coins",
                        style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  "Rate: 10 Reward Coins = ₹1.00 Cashback Wallet Money",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: textController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Coins to Convert (Min 10)",
                    prefixIcon: const Icon(Icons.generating_tokens_rounded, color: primaryColor),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (val) {
                    final pts = int.tryParse(val) ?? 0;
                    setModalState(() {
                      estimatedCash = pts / 10.0;
                    });
                  },
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: [50, 100, 200, 500].map((preset) {
                    return ActionChip(
                      label: Text("$preset Coins", style: const TextStyle(fontSize: 11)),
                      onPressed: () {
                        textController.text = preset.toString();
                        setModalState(() {
                          estimatedCash = preset / 10.0;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF86EFAC)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        "You will receive ₹${estimatedCash.toStringAsFixed(2)} in Cashback Wallet",
                        style: const TextStyle(
                          color: Color(0xFF15803D),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GetBuilder<RewardsController>(builder: (rewardsController) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: rewardsController.isConverting
                          ? null
                          : () async {
                              final pts = int.tryParse(textController.text.trim()) ?? 0;
                              if (pts < 10) {
                                Get.snackbar("Invalid Coins", "Minimum conversion is 10 coins.",
                                    snackPosition: SnackPosition.BOTTOM);
                                return;
                              }
                              if (pts > currentCoins) {
                                Get.snackbar("Insufficient Coins", "You only have $currentCoins coins available.",
                                    snackPosition: SnackPosition.BOTTOM);
                                return;
                              }
                              final res = await rewardsController.convertRewardPoints(points: pts);
                              if (res.isSuccess) {
                                Navigator.pop(ctx);
                                Get.snackbar(
                                  "Success!",
                                  "₹${(pts / 10.0).toStringAsFixed(2)} credited to your Main Wallet!",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: const Color(0xFF16A34A),
                                  colorText: Colors.white,
                                );
                              } else {
                                Get.snackbar("Failed", res.message, snackPosition: SnackPosition.BOTTOM);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: rewardsController.isConverting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text(
                              "Confirm Conversion",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                    ),
                  );
                }),
              ],
            ),
          );
        });
      },
    );
  }
}
