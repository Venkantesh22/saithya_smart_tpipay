import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/referral_controller.dart';
import 'package:lekra/data/models/referral/referral_level_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/referral/referral_level_details/referral_level_details_screen.dart';
import 'package:lekra/views/screens/dashboard/referral/referral_screen/components/referral_level_container.dart';
import 'package:lekra/views/screens/dashboard/referral/referral_screen/components/referral_tree.dart';

class ReferralLevelSection extends StatelessWidget {
  const ReferralLevelSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        GetBuilder<ReferralController>(builder: (referralController) {
          return Row(
            children: [
              Expanded(
                child: CustomShimmer(
                  isLoading: referralController.isLoading,
                  child: Text(
                    "Team referral Levels : ${referralController.referralLevelModelList.length}",
                    overflow: TextOverflow.clip,
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                  ),
                ),
              ),
              CustomButton(
                onTap: () {
                  if (referralController.isLoading) {
                    return showToast(
                        message: "Loading...", toastType: ToastType.info);
                  }
                  navigate(
                      context: context,
                      page: FullScreenReferralTree(
                        roots: referralController.referralList,
                      ));
                },
                color: secondaryColor,
                borderColor: secondaryColor,
                child: Text(
                  "Graph View",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 14, color: white),
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 12),

        /// Make the list scrollable
        Expanded(
          // This gives ListView a bounded height
          child: GetBuilder<ReferralController>(
            builder: (referralController) {
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 8),
                itemCount: referralController.isLoading
                    ? 4
                    : referralController.referralLevelModelList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final referralLevelModel = referralController.isLoading
                      ? ReferralLevelModel()
                      : referralController.referralLevelModelList[index];
                  return GestureDetector(
                    onTap: () {
                      if (referralController.isLoading) {
                        return showToast(
                            message: "Loading...", toastType: ToastType.info);
                      }
                      navigate(
                        context: context,
                        page: ReferralLevelDetailsScreen(
                            referralLevelModel: referralLevelModel),
                      );
                    },
                    child: CustomShimmer(
                      isLoading: referralController.isLoading,
                      child: ReferralLevelContainer(
                        referralLevelModel: referralLevelModel,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
