import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/generated/assets.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/success_recharge_screen/widget/column_of_info.dart';

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double zigzagHeight = 10;
    double zigzagWidth = 20;

    Path path = Path();

    /// TOP
    for (double i = 0; i < size.width; i += zigzagWidth) {
      path.lineTo(i + zigzagWidth / 2, zigzagHeight);
      path.lineTo(i + zigzagWidth, 0);
    }

    /// RIGHT
    path.lineTo(size.width, size.height);

    /// BOTTOM
    for (double i = size.width; i > 0; i -= zigzagWidth) {
      path.lineTo(i - zigzagWidth / 2, size.height - zigzagHeight);
      path.lineTo(i - zigzagWidth, size.height);
    }

    /// LEFT
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SuccessRechargeInfoSection extends StatelessWidget {
  const SuccessRechargeInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RechargeController>(builder: (rechargeController) {
      return ClipPath(
        clipper: TicketClipper(),
        child: Container(
          // width: double.infinity,
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(color: appbarBlueLight, boxShadow: []),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Total Amount",
                      style: Helper(context).textTheme.headlineSmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: greyText2,
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      rechargeController.rechargeSuccessModel?.formatAmount ??
                          "",
                      style: Helper(context).textTheme.displaySmall?.copyWith(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: primaryColor,
                          ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Assets.svgsCheckInZigzipCirlce,
                    height: 14,
                    width: 14,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 4),
                  Text(
                    "Success",
                    style: Helper(context).textTheme.headlineSmall?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: blueDark,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 60),
              Text(
                "Mobile Number",
                style: Helper(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: greyText2,
                    ),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                rechargeController.rechargeSuccessModel?.mobile ?? "",
                style: Helper(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: blackText,
                    ),
              ),
              SizedBox(height: 24),
              ColumnOfInfo(
                title: "operator_txn_id",
                text: rechargeController.rechargeSuccessModel?.operatorTxnId ??
                    "",
              ),
              SizedBox(height: 16),
              ColumnOfInfo(
                title: "Request ID",
                text: rechargeController.rechargeSuccessModel?.reqid ?? "",
              )
            ],
          ),
        ),
      );
    });
  }
}
