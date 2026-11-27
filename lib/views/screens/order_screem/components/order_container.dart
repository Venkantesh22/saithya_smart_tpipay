import 'package:flutter/material.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/widget/order_status_container.dart';

class OrderContainer extends StatelessWidget {
  final ProductModel productModel;
  const OrderContainer({
    super.key,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: black.withValues(alpha: 0.2),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CustomImage(
            path: productModel.images?[0].url ?? "",
            height: 100,
            width: 100,
            fit: BoxFit.cover,
            radius: 12,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productModel.name ?? "",
                  style: Helper(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Qty: ${productModel.quantity ?? ""}",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: grey.withValues(alpha: 10),
                      fontSize: 14),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "Order ID: #${productModel.orderId ?? "11"} ",
                  style: Helper(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        DateFormatters().dateTime.format(
                            productModel.createdAt?.toLocal() ??
                                DateTime.now()),
                        overflow: TextOverflow.clip,
                        style: Helper(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: secondaryColor,
                            ),
                      ),
                    ),
                    OrderStatusContainer(productModel: productModel)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
