import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/subscription_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:share_plus/share_plus.dart';

class SubscriptionDetailsBottonSection extends StatelessWidget {
  const SubscriptionDetailsBottonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(
      builder: (controller) {
        final model = controller.selectSubscriptionHistoryModel;
        final planName = model?.effectivePlanName ?? "VIP Membership";

        // Paid text
        final paidText = (model?.pricePaid != null && model?.pricePaid != "0")
            ? model!.pricePaidFormat
            : (model?.discountPrice != null && model?.discountPrice != "0"
                ? model!.discountPriceFormat
                : (model?.priceFormat ?? "₹0.00"));

        // Original MRP
        final originalPrice = model?.priceFormat ?? paidText;
        final hasDiscount = model?.hasDiscount ?? false;
        final discountAmount = model?.discountAmountFormat ?? "₹0.00";

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 8,
                color: black.withValues(alpha: 0.03),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Plan Subscribed Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Plan Subscribed",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                planName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Plan MRP",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              originalPrice,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: hasDiscount
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF0F172A),
                                decoration: hasDiscount
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    if (hasDiscount) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: Color(0xFFF1F5F9), height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  "SPECIAL OFFER",
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF15803D),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                "Membership Discount",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "- $discountAmount",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Color(0xFFF1F5F9), height: 1),
                    ),

                    // Official GST Breakdown Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "GST TAX INVOICE DETAILS",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF475569),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                "SAC: 998313",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Builder(builder: (context) {
                            final rawPaid = double.tryParse((model?.pricePaid ?? model?.price ?? "0").replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
                            final taxable = (rawPaid / 1.18);
                            final gstTotal = rawPaid - taxable;
                            final halfGst = gstTotal / 2.0;

                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Taxable Amount (Base)", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    Text("₹${taxable.toStringAsFixed(2)}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("CGST (9%)", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    Text("₹${halfGst.toStringAsFixed(2)}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("SGST (9%)", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                                    Text("₹${halfGst.toStringAsFixed(2)}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCFCE7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.verified_rounded, size: 12, color: Color(0xFF16A34A)),
                                      SizedBox(width: 4),
                                      Text(
                                        "18% GST Included in Total Payment",
                                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF15803D)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Color(0xFFF1F5F9), height: 1),
                    ),

                    // Net Payable Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Net Payable",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF334155),
                          ),
                        ),
                        Text(
                          paidText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Total Amount Paid Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount Paid',
                      style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: white,
                          ),
                    ),
                    Text(
                      paidText,
                      style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: white,
                          ),
                    ),
                  ],
                ),
              ),

              // Share / Download GST Invoice Action
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final invoiceText =
                          "=== SATHIYA PAY GST TAX INVOICE ===\n"
                          "Invoice No: ${model?.paymentReference ?? ('INV-SUB-' + (model?.subscriptionId?.toString() ?? '101'))}\n"
                          "Date: ${model?.createdDateFormat ?? ''}\n"
                          "Plan Name: $planName\n"
                          "Total Paid: $paidText\n"
                          "Tax Rate: 18% GST Included (CGST 9% + SGST 9%)\n"
                          "SAC Code: 998313\n"
                          "Status: COMPLETED / VERIFIED\n"
                          "Thank you for being a Sathiya Pay VIP Member!";
                      Share.share(invoiceText, subject: "Sathiya Pay GST Invoice - $planName");
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: primaryColor, width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.receipt_long_rounded, size: 16, color: primaryColor),
                    label: const Text(
                      "Share / Download GST Tax Invoice",
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
