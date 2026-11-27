import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/subscription_plan/subscription_history/subscription_history_details/components/subscription_details_botton_section.dart';
import 'package:lekra/views/screens/subscription_plan/subscription_history/subscription_history_details/components/subscription_details_median_section.dart';
import 'package:lekra/views/screens/subscription_plan/subscription_history/subscription_history_details/components/subscription_details_perks_section.dart';
import 'package:lekra/views/screens/subscription_plan/subscription_history/subscription_history_details/components/subscription_details_top_section.dart';

class SubscriptionHistoryDetailsScreen extends StatelessWidget {
  const SubscriptionHistoryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          "Membership Invoice",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
        ),
        leading: IconButton(
          tooltip: "Back",
          onPressed: () {
            pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF0F172A),
            size: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFE2E8F0),
            height: 1,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            SubscriptionDetailsTopSection(),
            SizedBox(height: 16),
            SubscriptionDetailsMedianSection(),
            SizedBox(height: 16),
            SubscriptionDetailsPerksSection(),
            SizedBox(height: 16),
            SubscriptionDetailsBottonSection(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
