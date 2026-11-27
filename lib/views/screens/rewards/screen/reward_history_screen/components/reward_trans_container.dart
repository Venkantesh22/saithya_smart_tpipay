import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lekra/data/models/reward_transaction_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class RewardTransContainer extends StatelessWidget {
  final RewardsTransactionModel rewardsTransactionModel;
  const RewardTransContainer({
    super.key,
    required this.rewardsTransactionModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: white,
          boxShadow: [
            BoxShadow(
                color: black.withValues(alpha: 0.1),
                spreadRadius: 0,
                blurRadius: 6,
                offset: const Offset(0, 4))
          ]),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  capitalize(rewardsTransactionModel.description),
                  style: Helper(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat().format(
                      rewardsTransactionModel.createdAt ?? DateTime.now()),
                  style: Helper(context).textTheme.bodySmall?.copyWith(),
                ),
              ],
            ),
          ),
          Text(
            rewardsTransactionModel.isDebit ? "-" : "+",
            style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: rewardsTransactionModel.isDebit ? red : green),
          ),
          Text(
            "${rewardsTransactionModel.points ?? 111} coins",
            style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: rewardsTransactionModel.isDebit ? red : green),
          ),
        ],
      ),
    );
  }
}
