import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/controllers/order_controlller.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/order_screem/components/order_billing_infor_section.dart';
import 'package:lekra/views/screens/order_screem/components/order_booking_price_container.dart';
import 'package:lekra/views/screens/order_screem/components/order_product_section.dart';
import 'package:lekra/views/screens/order_screem/screen/order_status_widget.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class OrderDetailsScreen extends StatefulWidget {
  final ProductModel productModel;

  const OrderDetailsScreen({
    super.key,
    required this.productModel,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<BasicController>().fetchAddressId(
          addressId: Get.find<OrderController>().selectOrder?.addressId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar2(
        title: "Order Details",
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: GetBuilder<OrderController>(builder: (orderController) {
          return Column(
            children: [
              OrderStatusWidget(
                widget: widget,
              ),
              OrderBookingPriceDetailsContainer(widget: widget),
              const SizedBox(
                height: 14,
              ),
              Container(
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
                    Text("Payment",
                        style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 6),
                    BuildBillingRow(
                      label: "Payment status:",
                      value: orderController.selectOrder?.paymentStatus ?? "",
                      color: greyDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              OrderProductSection(widget: widget),
              const SizedBox(
                height: 14,
              ),
              const OrderBillingInforSection()
            ],
          );
        }),
      ),
    );
  }
}
