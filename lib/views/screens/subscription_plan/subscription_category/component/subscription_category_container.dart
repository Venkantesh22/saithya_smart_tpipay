import 'package:flutter/material.dart';
import 'package:lekra/data/models/subscription_cate_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/dashboard/account_screen/account_screen.dart';

class SubscriptionCategoryContainer extends StatelessWidget {
  final Function() onPressed;
  const SubscriptionCategoryContainer({
    super.key,
    required this.subscriptionCategoryModel,
    required this.onPressed,
  });

  final SubscriptionCategoryModel? subscriptionCategoryModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: greyBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subscriptionCategoryModel?.name ?? "",
            style: Helper(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
          ),
          const SizedBox(
            height: 12,
          ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(
          //       subscriptionCategoryModel?.priceFormat ?? "",
          //       style: Helper(context).textTheme.bodyMedium?.copyWith(
          //             fontWeight: FontWeight.w500,
          //             fontSize: 20,
          //             color: grey,
          //             decoration: TextDecoration.lineThrough,
          //             decorationColor: grey,
          //             decorationThickness: 2,
          //           ),
          //     ),
          //     RichText(

          //       text: TextSpan(
          //         text: subscription?.discountPriceFormat,
          //         style: Helper(context).textTheme.titleSmall?.copyWith(
          //               fontWeight: FontWeight.w700,
          //               fontSize: 36,
          //             ),
          //         children: <TextSpan>[
          //           TextSpan(
          //             text: " /month",
          //             style: Helper(context).textTheme.titleSmall?.copyWith(
          //                 fontWeight: FontWeight.w700,
          //                 fontSize: 16,
          //                 color: black),
          //           )
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(
            height: 16,
          ),
          ProfileButton(
              title: "Choose Plan", onPressed: onPressed, color: primaryColor)
        ],
      ),
    );
  }
}
