import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lekra/controllers/order_controlller.dart';
import 'package:lekra/views/screens/order_screem/components/order_status_button.dart';

class OrderStatusSection extends StatelessWidget {
  const OrderStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: orderStatusButtonList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final model = orderStatusButtonList[index];

              return OrderStatusButton(
                isSelect:
                    orderController.selectedOrderStatus == model.orderStatus,
                orderStatusButtonModel: model,
                onTap: () {
                  orderController.updateOrderStatus(model.orderStatus);
                },
              );
            },
          ),
        ),
      );
    });
  }
}
