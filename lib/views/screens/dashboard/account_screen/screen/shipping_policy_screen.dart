import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class ShippingPolicyScreen extends StatefulWidget {
  const ShippingPolicyScreen({super.key});

  @override
  State<ShippingPolicyScreen> createState() => _ShippingPolicyScreenState();
}

class _ShippingPolicyScreenState extends State<ShippingPolicyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BasicController>().fetchShippingPolicy();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: const CustomAppBar2(title: "Shipping & Delivery Policy"),
      body: GetBuilder<BasicController>(builder: (basicController) {
        if (basicController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final content = basicController.shippingPolicy.trim().isNotEmpty
            ? basicController.shippingPolicy
            : "<h3>Shipping and Delivery Policy</h3><p>Sathiya Smart delivers across 19,000+ pincodes in India. Standard delivery timeline is 2 to 7 business days.</p><p>Eligible Scratch Card holders (₹113.28 and ₹226.56) and VIP Members enjoy Free Delivery.</p>";

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
                        color: const Color(0xFFE0E7FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.local_shipping_outlined,
                        size: 20,
                        color: Color(0xFF4338CA),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Shipping & Delivery Policy",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            "Courier Timelines & Free Delivery Terms",
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
                      Icon(Icons.flash_on_outlined,
                          size: 16, color: Color(0xFF4F46E5)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Free Delivery automatically applied for qualifying VIP members",
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
