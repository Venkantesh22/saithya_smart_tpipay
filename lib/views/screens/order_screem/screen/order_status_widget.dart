import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/order_controlller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/order_screem/screen/order_details_screen.dart';

class OrderStatusWidget extends StatelessWidget {
  final OrderDetailsScreen widget;

  const OrderStatusWidget({
    super.key,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      final statusStr = (orderController.selectOrder?.status ??
              widget.productModel.orderStatus ??
              "confirmed")
          .toLowerCase();

      final isCancelled = statusStr == 'cancelled';
      int currentStep = 0;
      if (statusStr == 'pending' || statusStr == 'confirmed') {
        currentStep = 1;
      } else if (statusStr == 'processing') {
        currentStep = 2;
      } else if (statusStr == 'shipped') {
        currentStep = 3;
      } else if (statusStr == 'out_for_delivery') {
        currentStep = 4;
      } else if (statusStr == 'delivered') {
        currentStep = 5;
      }

      return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: greyBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order Tracking",
                  style: Helper(context).textTheme.titleLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isCancelled
                        ? const Color(0xFFFEE2E2)
                        : (currentStep == 5
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFEFF6FF)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isCancelled ? "CANCELLED" : statusStr.replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isCancelled
                          ? const Color(0xFFB91C1C)
                          : (currentStep == 5
                              ? const Color(0xFF15803D)
                              : const Color(0xFF1D4ED8)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (isCancelled)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFCA5A5)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.cancel_outlined, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "This order was cancelled. Any debited amount has been refunded to your wallet.",
                        style: TextStyle(fontSize: 12, color: Color(0xFF991B1B)),
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  _buildTrackStep(
                    context,
                    title: "Order Placed",
                    desc: "Your order was received and confirmed.",
                    isPassed: currentStep >= 1,
                    isCurrent: currentStep == 1,
                    isLast: false,
                  ),
                  _buildTrackStep(
                    context,
                    title: "Processing & Packed",
                    desc: "Seller is preparing and packing your package.",
                    isPassed: currentStep >= 2,
                    isCurrent: currentStep == 2,
                    isLast: false,
                  ),
                  _buildTrackStep(
                    context,
                    title: "Shipped & In Transit",
                    desc: "Handed over to courier partner for delivery.",
                    isPassed: currentStep >= 3,
                    isCurrent: currentStep == 3,
                    isLast: false,
                  ),
                  _buildTrackStep(
                    context,
                    title: "Out for Delivery",
                    desc: "Delivery executive is on the way to your address.",
                    isPassed: currentStep >= 4,
                    isCurrent: currentStep == 4,
                    isLast: false,
                  ),
                  _buildTrackStep(
                    context,
                    title: "Delivered",
                    desc: "Order delivered safely to destination.",
                    isPassed: currentStep >= 5,
                    isCurrent: currentStep == 5,
                    isLast: true,
                  ),
                ],
              ),
          ],
        ),
      );
    });
  }

  Widget _buildTrackStep(
    BuildContext context, {
    required String title,
    required String desc,
    required bool isPassed,
    required bool isCurrent,
    required bool isLast,
  }) {
    final activeColor = primaryColor;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPassed ? activeColor : const Color(0xFFE2E8F0),
                border: isCurrent
                    ? Border.all(color: activeColor.withValues(alpha: 0.3), width: 3)
                    : null,
              ),
              child: Icon(
                Icons.check,
                size: 13,
                color: isPassed ? Colors.white : const Color(0xFF94A3B8),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 34,
                color: isPassed ? activeColor : const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isPassed ? FontWeight.bold : FontWeight.w500,
                  color: isPassed ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 11,
                  color: isPassed ? const Color(0xFF64748B) : const Color(0xFFCBD5E1),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
