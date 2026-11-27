import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BasicController>().fetchTermsConditions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar2(title: "Terms And Conditions"),
      body: GetBuilder<BasicController>(builder: (basicController) {
        if (basicController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final content = basicController.termsConditions.trim().isNotEmpty
            ? basicController.termsConditions
            : "<h2>Terms & Conditions</h2><p>Welcome to Sathiya Smart. By accessing or using our platform, mobile application, and related services, you agree to comply with and be bound by these terms.</p><p>All orders, wallet transactions, memberships, and recharges are subject to platform verification and applicable policies.</p>";

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 2),
                  blurRadius: 10,
                  color: black.withValues(alpha: 0.03),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.description_outlined,
                        size: 20,
                        color: Color(0xFFD97706),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Terms of Service & Usage",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Platform Rules & Guidelines",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFF1F5F9), height: 1),
                const SizedBox(height: 16),
                HtmlWidget(
                  content
                      .replaceAll(r'\r\n', '<br>')
                      .replaceAll(r'\n', '<br>')
                      .replaceAll(r'\/', '/'),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
