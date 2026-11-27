import 'package:flutter/material.dart';
import 'package:lekra/controllers/order_controlller.dart';
import 'package:lekra/services/theme.dart';

class OrderStatusButton extends StatelessWidget {
  final bool isSelect;
  final OrderStatusButtonModel orderStatusButtonModel;
  final VoidCallback onTap;

  const OrderStatusButton({
    super.key,
    required this.isSelect,
    required this.orderStatusButtonModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelect ? primaryColor : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelect ? primaryColor : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            orderStatusButtonModel.title,
            style: TextStyle(
              color: isSelect ? Colors.white : Colors.black87,
              fontWeight: isSelect ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class OrderStatusButtonModel {
  final String title;
  final OrderStatus orderStatus;

  OrderStatusButtonModel({
    required this.orderStatus,
    required this.title,
  });
}

List<OrderStatusButtonModel> orderStatusButtonList = [
  OrderStatusButtonModel(title: "All", orderStatus: OrderStatus.all),
  OrderStatusButtonModel(title: "Pending", orderStatus: OrderStatus.pending),
  OrderStatusButtonModel(
      title: "Processing", orderStatus: OrderStatus.processing),
  OrderStatusButtonModel(
      title: "Completed", orderStatus: OrderStatus.completed),
  OrderStatusButtonModel(
      title: "Cancelled", orderStatus: OrderStatus.cancelled),
];
