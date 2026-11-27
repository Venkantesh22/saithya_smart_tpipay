import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/controllers/order_controlller.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/order_screem/components/order_container.dart';
import 'package:lekra/views/screens/order_screem/components/order_status_section.dart';
import 'package:lekra/views/screens/order_screem/screen/order_details_screen.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<OrderController>().fetchOrder();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: primaryColor,
      backgroundColor: white,
      onRefresh: () async {
        Get.find<OrderController>().fetchOrder();
      },
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          Get.find<DashBoardController>().dashPage = 0;

          navigate(
              context: context,
              page: const DashboardScreen(),
              isRemoveUntil: true);
        },
        child: Scaffold(
          appBar: const CustomAppBar2(
            showBackButton: false,
            title: "Order",
          ),
          body: SingleChildScrollView(
            padding: AppConstants.screenPadding,
            child: Column(
              children: [
                const OrderStatusSection(),
                GetBuilder<OrderController>(builder: (orderController) {
                  if (orderController.orderFilterList.isEmpty) {
                    return const Center(child: Text("No Order"));
                  }
                  return Column(
                    children: [
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final product = orderController.isLoading
                              ? ProductModel()
                              : orderController.orderFilterList[index];
                          return CustomShimmer(
                            isLoading: orderController.isLoading,
                            child: GestureDetector(
                                onTap: () {
                                  if (orderController.isLoading) {
                                    showToast(
                                        message: "Please waiting...",
                                        toastType: ToastType.info);
                                    return;
                                  }
                                  orderController
                                      .updateSelectOrder(product.orderId);
                                  navigate(
                                      context: context,
                                      page: OrderDetailsScreen(
                                        productModel: product,
                                      ));
                                },
                                child: OrderContainer(productModel: product)),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 12,
                          );
                        },
                        itemCount: orderController.isLoading
                            ? 2
                            : orderController.orderFilterList.length,
                      )
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
