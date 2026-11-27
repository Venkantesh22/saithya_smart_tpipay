import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/mobile_recharge_select_no/mobile_recharge_select_no_screen.dart';

class RechargeAndBillsSection extends StatelessWidget {
  const RechargeAndBillsSection({
    super.key,
  });

  void _showDthRechargeBottomSheet(BuildContext context) {
    final dthOperators = [
      {"name": "Tata Play (Tata Sky)", "icon": Icons.tv_rounded, "color": const Color(0xFF0284C7)},
      {"name": "Airtel Digital TV", "icon": Icons.satellite_alt_rounded, "color": const Color(0xFFDC2626)},
      {"name": "Dish TV", "icon": Icons.live_tv_rounded, "color": const Color(0xFFEA580C)},
      {"name": "Sun Direct", "icon": Icons.connected_tv_rounded, "color": const Color(0xFFCA8A04)},
      {"name": "D2H (Videocon)", "icon": Icons.tv_rounded, "color": const Color(0xFF4F46E5)},
    ];

    final vcController = TextEditingController();
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.satellite_alt_rounded, color: primaryColor, size: 22),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "DTH Recharge",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Select DTH Operator",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: dthOperators.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (context, idx) {
                          final op = dthOperators[idx];
                          return Container(
                            width: 100,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(op["icon"] as IconData, color: op["color"] as Color, size: 24),
                                const SizedBox(height: 4),
                                Text(
                                  op["name"] as String,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: vcController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Subscriber / VC Number",
                        hintText: "Enter 10 or 11-digit VC number",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.credit_card_rounded),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Recharge Amount (₹)",
                        hintText: "e.g. 299",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.currency_rupee_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (vcController.text.trim().isEmpty) {
                            Get.snackbar("DTH Recharge", "Please enter your VC / Subscriber Number");
                            return;
                          }
                          Navigator.pop(ctx);
                          Get.snackbar(
                            "DTH Recharge Initiated",
                            "Processing recharge of ₹${amountController.text.trim().isEmpty ? '299' : amountController.text.trim()} for VC ${vcController.text.trim()}",
                            backgroundColor: Colors.white,
                            colorText: Colors.black,
                          );
                        },
                        child: const Text("Proceed to Recharge", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recharge & Bills",
            style: Helper(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Mobile Recharge
              Expanded(
                child: InkWell(
                  onTap: () {
                    navigate(
                        context: context,
                        page: const MobileRechargeSelectNoScreen());
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CustomImage(
                          path: Assets.imagesRechargeDemo,
                          height: 52,
                          width: 52,
                          radius: 100,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Mobile\nRecharge",
                          textAlign: TextAlign.center,
                          style: Helper(context).textTheme.bodySmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // DTH Recharge
              Expanded(
                child: InkWell(
                  onTap: () => _showDthRechargeBottomSheet(context),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.satellite_alt_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "DTH\nRecharge",
                          textAlign: TextAlign.center,
                          style: Helper(context).textTheme.bodySmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),
              // Electricity / Bill Payments (BBPS)
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.snackbar("BBPS Utility", "Electricity bill payment integration ready.",
                        backgroundColor: Colors.white, colorText: Colors.black);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.bolt_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Electricity\nBBPS",
                          textAlign: TextAlign.center,
                          style: Helper(context).textTheme.bodySmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),
              // Fastag / Gas
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.snackbar("BBPS Utility", "Fastag & Gas cylinder payment ready.",
                        backgroundColor: Colors.white, colorText: Colors.black);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF10B981), Color(0xFF047857)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.directions_car_filled_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Fastag\n& Gas",
                          textAlign: TextAlign.center,
                          style: Helper(context).textTheme.bodySmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                height: 1.2,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
