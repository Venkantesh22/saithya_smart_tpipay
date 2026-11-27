import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/screens/fund_requent_qr/fund_add_success/widget/fund_add_sccess_screen_med_section.dart';
import 'package:lekra/views/screens/fund_requent_qr/fund_add_success/widget/fund_add_sccess_screen_top_section.dart';
import 'package:lekra/views/screens/fund_requent_qr/fund_add_success/widget/fund_add_success_screen_bottom_section.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';
import 'package:screenshot/screenshot.dart';

class FundAddSuccessScreen extends StatefulWidget {
  const FundAddSuccessScreen({super.key});

  @override
  State<FundAddSuccessScreen> createState() => _FundAddSuccessScreenState();
}

class _FundAddSuccessScreenState extends State<FundAddSuccessScreen> {
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: SafeArea(
        child: Scaffold(
          appBar: CustomAppBar2(title: "Success"),
          body: SingleChildScrollView(
            padding: AppConstants.screenPadding,
            child: Column(
              children: [
                Column(
                  children: [
                    FundAddSuccessScreenTopSection(),
                    FundAddSuccessScreenMedSection(screenshotController: screenshotController),
                  ],
                ),
                
                FundAddSuccessScreenBottomSection()
        
              ],
            ),
          ),
        ),
      ),
    );
  }
}
