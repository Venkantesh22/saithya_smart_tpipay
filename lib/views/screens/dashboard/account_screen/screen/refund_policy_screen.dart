import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class RefundPolicyScreen extends StatefulWidget {
  const RefundPolicyScreen({super.key});

  @override
  State<RefundPolicyScreen> createState() => _RefundPolicyScreenState();
}

class _RefundPolicyScreenState extends State<RefundPolicyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BasicController>().fetchRefundPolicy();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar2(title: "Return & Refund Policy"),
      body: GetBuilder<BasicController>(builder: (basicController) {
        if (basicController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final content = basicController.refundPolicy.trim().isNotEmpty
            ? basicController.refundPolicy
            : "<h3>Return, Refund and Cancellation Policy</h3><p>Sathiya Smart offers a transparent 7-day return and replacement policy for eligible damaged or defective products.</p><p>Wallet refunds are processed within 24-48 hours of return verification.</p>";

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
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.assignment_return_outlined,
                        size: 20,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Return, Refund & Cancellation",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Consumer Protection (E-Commerce) Rules 2020",
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
                  content,
                  textStyle: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF334155),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_user_outlined,
                          size: 16, color: Color(0xFF475569)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Compliant with Indian Consumer Protection Regulations",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF475569),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
