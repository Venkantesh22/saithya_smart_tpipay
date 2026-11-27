// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/fund_request_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/screens/fund_requent_qr/fund_requent/component/text_and_option_section.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class FundRequestQrScreen extends StatefulWidget {
  const FundRequestQrScreen({super.key});

  @override
  State<FundRequestQrScreen> createState() => _FundRequestQrScreenState();
}

class _FundRequestQrScreenState extends State<FundRequestQrScreen> {
  // Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final fundController = Get.find<FundRequestController>();
      fundController.amountController.clear();
      fundController.update();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar2(title: "Fund Request QR"),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          children: [
            TextBoxAndOptionSection(),
          ],
        ),
      ),
    );
  }
}
