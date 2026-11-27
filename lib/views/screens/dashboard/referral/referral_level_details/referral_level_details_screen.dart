import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/referral_controller.dart';
import 'package:lekra/data/models/referral/referral_level_details_model.dart';
import 'package:lekra/data/models/referral/referral_level_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/referral/referral_level_details/component/referral_team_member_details.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

class ReferralLevelDetailsScreen extends StatefulWidget {
  final ReferralLevelModel? referralLevelModel;
  const ReferralLevelDetailsScreen(
      {super.key, required this.referralLevelModel});

  @override
  State<ReferralLevelDetailsScreen> createState() =>
      _ReferralLevelDetailsScreenState();
}

class _ReferralLevelDetailsScreenState
    extends State<ReferralLevelDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ReferralController>().fetchReferralLevelDataByID(
          levelId: widget.referralLevelModel?.levelNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar2(
        title: "Level ${widget.referralLevelModel?.levelNumber} Team",
        centerTitle: false,
      ),
      body: Padding(
        padding: AppConstants.screenPadding,
        child: GetBuilder<ReferralController>(builder: (referralController) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextFieldWithHeading(
                controller: referralController.searchReferralTeamController,
                hindText: "Search by name or Email...",
                preFixWidget: const Icon(Icons.search),
                onChanged: (value) {
                  referralController.searchReferralTeam(value);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: RichText(
                  overflow: TextOverflow.clip,
                  text: TextSpan(
                    text: "Total Members: ",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                    children: [
                      TextSpan(
                        text: widget.referralLevelModel?.currentPeopleInLevel
                            .toString(),
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: secondaryColor),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final referralMemberDetails = referralController.isLoading
                        ? ReferralLevelDetailsModel()
                        : referralController
                            .referralLevelDetailsModelFilterList[index];
                    return CustomShimmer(
                      isLoading: referralController.isLoading,
                      child: ReferralTeamMemberDetailContainer(
                        referralLevelDetailsModel: referralMemberDetails,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(height: 12),
                  itemCount: referralController.isLoading
                      ? 4
                      : referralController
                          .referralLevelDetailsModelFilterList.length,
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
