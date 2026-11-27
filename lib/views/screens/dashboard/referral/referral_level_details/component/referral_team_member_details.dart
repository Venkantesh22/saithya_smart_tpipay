import 'package:flutter/material.dart';
import 'package:lekra/data/models/referral/referral_level_details_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class ReferralTeamMemberDetailContainer extends StatelessWidget {
  final ReferralLevelDetailsModel? referralLevelDetailsModel;
  const ReferralTeamMemberDetailContainer({
    super.key,
    this.referralLevelDetailsModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: white,
          border: Border.all(
              color: primaryColor.withValues(
                alpha: 0.2,
              ),
              width: 0.67),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 6,
              spreadRadius: -4,
              color: black.withValues(alpha: 0.10),
            ),
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 15,
              spreadRadius: -3,
              color: black.withValues(alpha: 0.10),
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capitalize(referralLevelDetailsModel?.name ?? ""),
                      overflow: TextOverflow.clip,
                      style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      capitalize(referralLevelDetailsModel
                              ?.referredLevel?.currentRank ??
                          ""),
                      overflow: TextOverflow.clip,
                      style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: secondaryColor,
                          ),
                    ),
                  ],
                ),
              ),
              RichText(
                overflow: TextOverflow.clip,
                text: TextSpan(
                  text: "Balance : ",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                  children: [
                    TextSpan(
                      text: referralLevelDetailsModel?.walletBalance,
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: secondaryColor),
                    )
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              "Total member: ${referralLevelDetailsModel?.referredLevel?.totalDownline ?? ""}",
              overflow: TextOverflow.clip,
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              "Referral ID: ${referralLevelDetailsModel?.referralCode ?? ""}",
              overflow: TextOverflow.clip,
              style: Helper(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
          Text(
            "Email: ${referralLevelDetailsModel?.email ?? ""}",
            overflow: TextOverflow.clip,
            style: Helper(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
          ),
        ],
      ),
    );
  }
}
