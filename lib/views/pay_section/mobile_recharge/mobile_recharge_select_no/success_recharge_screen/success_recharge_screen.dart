import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/success_recharge_screen/widget/tickat_clip_container.dart';
import 'package:lekra/views/pay_section/pay_home/pay_home_screen.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

import 'widget/recharge_success_top_section.dart';

class SuccessRechargeScreen extends StatelessWidget {
  const SuccessRechargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar2(title: "Transaction Status"),
      bottomNavigationBar: Padding(
        padding: AppConstants.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              height: 60,
              radius: 999,
              onTap: () {
                navigate(context: context, page: PayHomeScreen());
              },
              child: Text(
                "Back to Home",
                style: Helper(context).textTheme.displaySmall?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: white,
                    ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          children: [
            RechargeSuccessTopSection(),
            SizedBox(height: 40),
            SuccessRechargeInfoSection(),
          ],
        ),
      ),
    );
  }
}
