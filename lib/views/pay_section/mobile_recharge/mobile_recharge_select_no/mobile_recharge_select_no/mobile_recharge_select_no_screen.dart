import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_plan/mobile_recharge_plan_screen.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_select_no/widget/mobile_recharge_no_top_section.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_select_no/widget/moble_recharge_no_mid_section.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_select_payment/widget/custom_button_pay_section.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class MobileRechargeSelectNoScreen extends StatefulWidget {
  const MobileRechargeSelectNoScreen({super.key});

  @override
  State<MobileRechargeSelectNoScreen> createState() =>
      _MobileRechargeSelectNoScreenState();
}

class _MobileRechargeSelectNoScreenState
    extends State<MobileRechargeSelectNoScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rechargeController = Get.find<RechargeController>();
      rechargeController.mobileNoController.clear();
      rechargeController.selectNetworkOperate = null;
      rechargeController.selectRechargeStateAreaModel = null;
      rechargeController.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar2(
        title: "Mobile Recharge",
      ),
      bottomNavigationBar:
          GetBuilder<RechargeController>(builder: (rechargeController) {
        return SafeArea(
          child: Padding(
            padding: AppConstants.screenPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButtonForPaySection(
                  titleWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "See Plans",
                        style: Helper(context).textTheme.displaySmall?.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: white,
                            ),
                      ),
                      SizedBox(width: 8),
                      SvgPicture.asset(Assets.svgsArrowForward)
                    ],
                  ),
                  onTap: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      rechargeController
                          .fetchMobileRechargePlan()
                          .then((value) {});
                      navigate(
                        context: context,
                        page: MobileRechargePlanScreen(),
                      );
                    }
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF717785),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Note: Please select properly and carefully your Mobile number, operator, and location.",
                        style:
                            Helper(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: greyText2,
                                ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
      body: GetBuilder<RechargeController>(builder: (rechargeController) {
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MobileRechargeNoTopSection(),
                MobileRechargeNoMidSection()
              ],
            ),
          ),
        );
      }),
    );
  }
}
