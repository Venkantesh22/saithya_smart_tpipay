import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/controllers/order_controlller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class OrderBillingInforSection extends StatelessWidget {
  const OrderBillingInforSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: greyBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Billing Information",
                style: Helper(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            BuildBillingRow(
              label: "Name :",
              value: capitalize(orderController.selectOrder?.billingName ?? ""),
              color: greyDark,
            ),
            BuildBillingRow(
              label: "Phone :",
              value: "+91 ${orderController.selectOrder?.billingPhone ?? ""}",
              color: greyDark,
            ),
            BuildBillingRow(
              label: "Email :",
              value: orderController.selectOrder?.billingEmail ?? "",
              color: greyDark,
            ),
            GetBuilder<BasicController>(builder: (basicController) {
              final directAddress = orderController.selectOrder?.address?.fullAddress;
              final fetchedAddress = basicController.orderAddress?.fullAddress;
              final displayAddress = (directAddress != null && directAddress.isNotEmpty)
                  ? directAddress
                  : ((fetchedAddress != null && fetchedAddress.isNotEmpty)
                      ? fetchedAddress
                      : "Delivery address verified on file");

              return BuildBillingRow(
                label: "Address :",
                value: displayAddress,
                color: greyDark,
              );
            }),
          ],
        ),
      );
    });
  }
}

class BuildBillingRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const BuildBillingRow({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(label,
              style: Helper(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: color, fontSize: 14)),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Text(value,
                style: Helper(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
