// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/seleck_payment/dynamc_qr_screen/dynamic_qr_screen.dart';

class RowOfUPIOption extends StatelessWidget {
  final String? image;
  final String title;
  final Function(BuildContext)? onTap;

  const RowOfUPIOption({
    super.key,
    this.image,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                image != null
                    ? Row(
                        children: [
                          CustomImage(
                            path: image ?? "",
                            height: 26,
                            width: 26,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 8),
                        ],
                      )
                    : const SizedBox(),
                Text(
                  title,
                  style: Helper(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios_rounded),
          ],
        ),
      ),
    );
  }
}

class UpiOptionModel {
  final String? image;
  final String title;
  final Function(BuildContext)? onTap;

  UpiOptionModel({this.image, required this.title, required this.onTap});
}

List<UpiOptionModel> getUpiOptionList({
  bool isSubscriptionPayment = false,
}) {
  return [
    UpiOptionModel(
      title: "Dynamic QR",
      onTap: (context) {
        navigate(
            context: context,
            page: QRPaymentScreen(
              isMemberShipPayment: isSubscriptionPayment,
            ));
      },
    ),
  ];
}
