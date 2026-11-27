import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/order_controlller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/theme.dart' as Colors;
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/order_screem/screen/order_details_screen.dart';

class OrderBookingPriceDetailsContainer extends StatelessWidget {
  const OrderBookingPriceDetailsContainer({
    super.key,
    required this.widget,
  });

  final OrderDetailsScreen widget;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.greyBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormatters().dateTime.format(
                          orderController.selectOrder?.createdAt?.toLocal() ??
                              DateTime.now()),
                      style: Helper(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.secondaryColor,
                          ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text("Order ID",
                        style: Helper(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text("#${orderController.selectOrder?.id ?? "11"}",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                // OrderStatusContainer(productModel: widget.productModel)
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 10),
              child: Divider(
                color: grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Subtotal",
                    style: Helper(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: greyDark, fontSize: 14)),
                Text(
                  PriceConverter.convertToNumberFormat(
                      orderController.selectOrder?.subtotal ?? 0.0),
                  style: Helper(context).textTheme.bodyLarge?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("discount",
                    style: Helper(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: greyDark, fontSize: 14)),
                Text(
                  PriceConverter.convertToNumberFormat(
                      orderController.selectOrder?.discount ?? 0.0),
                  style: Helper(context).textTheme.bodyLarge?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total",
                    style: Helper(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(
                  PriceConverter.convertToNumberFormat(
                      orderController.selectOrder?.totalPrice ?? 0.0),
                  style: Helper(context).textTheme.bodyLarge?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
