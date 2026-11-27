import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/subscription_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/premium_screen/components/premium_bottom_section.dart';
import 'package:lekra/views/screens/premium_screen/components/premium_medium_section.dart';
import 'package:lekra/views/screens/premium_screen/components/premium_top_section.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = Get.find<AuthController>();
      final sub = authController.userModel?.subscription;
      Get.find<SubscriptionController>().fetchSubscriptionPlanDetails(
        id: sub?.subscriptionId ?? 0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Color(0xFF0F172A),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "VIP Membership Pass",
          style: Helper(context).textTheme.titleMedium?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
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
      body: const SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            children: [
              PremiumTopSection(),
              PremiumMediumSection(),
              PremiumBottomSection(),
            ],
          ),
        ),
      ),
    );
  }
}
