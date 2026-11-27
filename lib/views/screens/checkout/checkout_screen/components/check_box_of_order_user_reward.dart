import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/order_controlller.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';

class CheckBoxOfOrderUserReward extends StatelessWidget {
  const CheckBoxOfOrderUserReward({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return GetBuilder<OrderController>(builder: (orderController) {
        if (productController.cardModel?.rewardPointsBalance == null ||
            productController.cardModel?.rewardPointsBalance == 0.0 &&
                orderController.userRewordCoinsState == false) {
          return SizedBox();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available Reward Coins is = ${productController.cardModel?.rewardPointsBalance}",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Row(
              children: [
                Checkbox(
                    value: orderController.userRewordCoinsState,
                    onChanged: (value) {
                      orderController.updateRewordCoinsState(value: value);
                      productController.fetchCard(isUserRewardCoin: value);
                    }),
                Text(
                  "You can user 10% Coins",
                  style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: greyDark,
                      ),
                ),
              ],
            ),
          ],
        );
      });
    });
  }
}
