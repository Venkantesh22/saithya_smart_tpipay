import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/reward_controller.dart';
import 'package:lekra/data/models/scratch_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/base/custom_refresh_indicator.dart';
import 'package:lekra/views/screens/rewards/screen/reward_details_screen/reward_details_screen.dart';
import 'package:lekra/views/screens/rewards/screen/rewards_screen/component/scratch_card_widget.dart';
import 'package:lekra/views/screens/rewards/screen/rewards_screen/component/total_point_section.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';
import 'package:scratcher/scratcher.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<RewardsController>().fetchScratchCard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefresh(
      onRefresh: () async {
        Get.find<RewardsController>().fetchScratchCard();
      },
      child: Scaffold(
        appBar: const CustomAppBar2(title: "Rewards"),
        body: SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TotalPointSection(),

              // How to Use Reward Points & Coins Guide Card (Checklist A19)
              Container(
                margin: const EdgeInsets.only(top: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb_outline, size: 18, color: Color(0xFFB45309)),
                        SizedBox(width: 6),
                        Text(
                          "How to Use Your Reward Points & Coins",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _rewardTip(
                      icon: Icons.currency_rupee,
                      title: "Convert Coins to Main Wallet Cash",
                      desc: "10 Coins = ₹1 Cash. Instantly convert points into spendable wallet balance.",
                    ),
                    const SizedBox(height: 6),
                    _rewardTip(
                      icon: Icons.all_inclusive,
                      title: "Coins Never Expire",
                      desc: "Reward coins credited to your account remain valid forever without expiring.",
                    ),
                    const SizedBox(height: 6),
                    _rewardTip(
                      icon: Icons.timelapse,
                      title: "Cashback Vouchers",
                      desc: "Cashback & discount coupons expire in 1 month from the date of scratching.",
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Scratch & Win",
                  style: Helper(context).textTheme.titleSmall,
                ),
              ),
              GetBuilder<RewardsController>(builder: (rewardController) {
                if (rewardController.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (rewardController.scratchCardList.isEmpty) {
                  return const Center(
                      child: Text("No scratch cards available."));
                }
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rewardController.scratchCardList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12),
                  itemBuilder: (context, index) {
                    final scratchCardModel = rewardController.isLoading
                        ? const ScratchCardModel()
                        : rewardController.scratchCardList[index];
                    final isCardClaimed = scratchCardModel.isScratch;
                    return GestureDetector(
                      onTap: () {
                        if (rewardController.isLoading) {
                          showToast(
                              message: "Please Wait....",
                              toastType: ToastType.info);
                          return;
                        } else if (!isCardClaimed) {
                          scratchFun(context, scratchCardModel);
                        } else if (scratchCardModel.isDiscount) {
                          // Allow viewing/copying claimed discount voucher
                          navigate(
                            context: context,
                            page: RewardDetailsScreen(
                              scratchCardModel: scratchCardModel,
                            ),
                          );
                        } else {
                          // Already scratched coins card is disabled
                          showToast(
                            message: "This card has already been claimed and credited to your wallet.",
                            toastType: ToastType.info,
                          );
                        }
                      },
                      child: ScratchCardWidget(
                        scratchCardModel: scratchCardModel,
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> scratchFun(
      BuildContext context, ScratchCardModel scratchCardModel) {
    final scratchKey = GlobalKey<ScratcherState>();
    bool isRedeemed = false;
    bool isRedeeming = false;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return GetBuilder<RewardsController>(builder: (rewardsController) {
            return Dialog(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Scratcher(
                key: scratchKey,
                image: Image.asset(
                  Assets.imagesScratch,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.44,
                ),
                accuracy: ScratchAccuracy.medium,
                brushSize: 50,
                threshold: 35,
                onThreshold: () {
                  scratchKey.currentState?.reveal(duration: const Duration(milliseconds: 600));

                  if (!isRedeemed && !isRedeeming) {
                    isRedeemed = true;
                    isRedeeming = true;
                    setDialogState(() {});

                    // Immediately mark as scratched locally in the active list so it's disabled
                    final idx = rewardsController.scratchCardList.indexWhere((c) => c.id == scratchCardModel.id);
                    if (idx != -1) {
                      rewardsController.scratchCardList[idx] = rewardsController.scratchCardList[idx].copyWith(
                        isRedeemed: 1,
                        isScratched: true,
                      );
                      rewardsController.update();
                    }

                    rewardsController
                        .postScratchCardRedeem(scratchId: scratchCardModel.id)
                        .then((value) {
                      isRedeeming = false;
                      rewardsController.fetchScratchCard();
                      Get.find<AuthController>().fetchUserProfile();
                    });

                    Get.snackbar(
                      "🎉 Revealed!",
                      scratchCardModel.isDiscount
                          ? "You’ve unlocked ${scratchCardModel.rewardPoints} OFF Cashback Voucher!"
                          : "You’ve won ${scratchCardModel.rewardPoints} Coins credited to wallet!",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.black87,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 3),
                    );
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.44,
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade400.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          scratchCardModel.isDiscount
                              ? Icons.local_offer_rounded
                              : Icons.stars_rounded,
                          color: Colors.amber.shade400,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        scratchCardModel.isDiscount
                            ? "🎉 Congratulations! Voucher Won"
                            : "🎁 Congratulations! Coins Won",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        scratchCardModel.isDiscount
                            ? "${scratchCardModel.rewardPoints} OFF"
                            : "${scratchCardModel.rewardPoints} Coins",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                          color: Color(0xFFFBBF24),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        scratchCardModel.isDiscount
                            ? "Expires in 1 Month • Redeemable on Orders"
                            : "Credited to Wallet • Coins Never Expire",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(dialogCtx);
                            rewardsController.fetchScratchCard();
                            Get.find<AuthController>().fetchUserProfile();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade500,
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            "Collect Reward",
                            style: TextStyle(
                              color: Color(0xFF0F172A),
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
      },
    );
  }

  Widget _rewardTip({required IconData icon, required String title, required String desc}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: const Color(0xFFD97706)),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: "$title: ",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: Color(0xFF78350F),
              ),
              children: [
                TextSpan(
                  text: desc,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 11,
                    color: Color(0xFF92400E),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
