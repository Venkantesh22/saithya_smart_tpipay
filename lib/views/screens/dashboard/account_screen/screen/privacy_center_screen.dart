import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class PrivacyCenterScreen extends StatefulWidget {
  const PrivacyCenterScreen({super.key});

  @override
  State<PrivacyCenterScreen> createState() => _PrivacyCenterScreenState();
}

class _PrivacyCenterScreenState extends State<PrivacyCenterScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BasicController>().fetchPrivacyPolicy();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar2(
        title: "Privacy Policy",
      ),
      body: GetBuilder<BasicController>(builder: (basicController) {
        if (basicController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final content = basicController.privacyPolicy.trim().isNotEmpty
            ? basicController.privacyPolicy
            : "<h3>Privacy Policy</h3><p>Sathiya Smart values your privacy. We securely store and encrypt your sensitive personal data and payment records.</p><p>We collect essential information to process orders, manage wallet balances, and provide high-quality services.</p>";

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
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        size: 20,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Privacy & Data Protection",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Official Sathiya Smart Policy",
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
