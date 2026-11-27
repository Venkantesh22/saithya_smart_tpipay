import 'package:flutter/material.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class OrderStatusContainer extends StatelessWidget {
  const OrderStatusContainer({
    super.key,
    required this.productModel,
  });

  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: getStatusColor(productModel.status).withValues(alpha: 0.1),
      ),
      child: Text(
        capitalize(productModel.status ?? ""),
        style: Helper(context).textTheme.bodySmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: getStatusColor(productModel.status),
            ),
      ),
    );
  }
}
