import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/dynamic_qr_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class FundAddSuccessScreenTopSection extends StatelessWidget {
  const FundAddSuccessScreenTopSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DynamicQRController>(
      builder: (dynamicQRController) {
        return Center(
          child: Column(
            children: [
              CustomImage(
                path: Assets.imagesCheckSuccessCircle,
                height: 96,
                width: 96,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 24),
              Text(
                "Funds Added Successfully",
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: Helper(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 30,
                      color: blackText,
                    ),
              ),
              SizedBox(height: 12),
              Text(
                "Your wallet has been topped up instantly.",
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: Helper(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: greyText2,
                    ),
              ),
              SizedBox(height: 24),
              Text(
                "AMOUNT PAID",
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: Helper(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: greyText2,
                    ),
              ),
              SizedBox(height: 4),
              Text(
                dynamicQRController.dynamicWalletPaymentDoneModel?.formatAmount ?? "0.00" ,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: Helper(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 48,
                      color: blueDark,
                    ),
              ),
              SizedBox(height: 40),
        
            ],
          ),
        );
      }
    );
  }
}
