import 'package:flutter/material.dart';
import 'package:lekra/data/models/referral/referral_level_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class ReferralLevelContainer extends StatelessWidget {
  final ReferralLevelModel referralLevelModel;
  const ReferralLevelContainer({
    super.key,
    required this.referralLevelModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 11, 19, 21),
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(
              color: secondaryColor,
              width: 4,
            ),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 6,
              spreadRadius: -4,
              color: black.withValues(alpha: 0.1),
            ),
            BoxShadow(
              offset: const Offset(0, 10),
              blurRadius: 15,
              spreadRadius: -3,
              color: black.withValues(alpha: 0.1),
            )
          ]),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Referral Level ${referralLevelModel.levelNumber}",
                  overflow: TextOverflow.clip,
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 9),
                Text(
                  "Total Member: ${referralLevelModel.currentPeopleInLevel}",
                  overflow: TextOverflow.clip,
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: primaryColor.withValues(
              alpha: 0.20,
            ),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
