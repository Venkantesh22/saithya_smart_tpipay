import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class RechargeSuccessTopSection extends StatelessWidget {
  const RechargeSuccessTopSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CustomImage(
            path: Assets.imagesCheckMarkRecharge,
            height: 120,
            width: 96,
            fit: BoxFit.cover,
          ),
          Text(
            "Recharge Successful",
            style: Helper(context).textTheme.displaySmall?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: blackText,
                ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            child: Text(
              "Your mobile recharge has been processed successfully. A confirmation SMS has been sent to your number.",
              textAlign: TextAlign.center,
              style: Helper(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: greyText2,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
