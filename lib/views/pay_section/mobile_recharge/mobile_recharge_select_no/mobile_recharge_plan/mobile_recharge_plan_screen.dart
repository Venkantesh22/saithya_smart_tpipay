import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_plan/widget/recharge_plan_section.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_plan/widget/recharge_plan_top_section.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_plan/widget/recharge_plan_search_bar.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class MobileRechargePlanScreen extends StatefulWidget {
  const MobileRechargePlanScreen({super.key});

  @override
  State<MobileRechargePlanScreen> createState() =>
      _MobileRechargePlanScreenState();
}

class _MobileRechargePlanScreenState extends State<MobileRechargePlanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rechargeController = Get.find<RechargeController>();
      rechargeController.mobileRechargeSearchController.clear();
      rechargeController.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar2(title: "Mobile Recharge plan"),
      body: Padding(
        padding: AppConstants.screenPadding,
        child: Column(
          children: [
            RechargePlanTopSection(),
            RechargePlanSearchBar(),
            Expanded(child: MobileRechargePlanSection())
          ],
        ),
      ),
    );
  }
}
