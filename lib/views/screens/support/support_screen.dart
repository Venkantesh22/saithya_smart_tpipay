import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/views/base/custom_refresh_indicator.dart';
import 'package:lekra/views/screens/support/widget/help_med_section.dart';
import 'package:lekra/views/screens/support/widget/help_top_section.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({super.key});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BasicController>().fetchSupport();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar2(title: "Help & Support"),
      body: GetBuilder<BasicController>(builder: (basicController) {
        return CustomRefresh(
          onRefresh: () async {
            await Get.find<BasicController>().fetchSupport();
          },
          child: const SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HelpTopSection(),
                HelpMedSection(),
              ],
            ),
          ),
        );
      }),
    );
  }
}
