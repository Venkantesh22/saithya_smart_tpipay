import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/order_controlller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/date_formatters_and_converters.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/order_confirmed/components/confirm_refer_and_earn_screen.dart';
import 'package:lekra/views/screens/spin_wheel/spin_wheel_screen.dart';

class OrderConfirmedScreen extends StatefulWidget {
  const OrderConfirmedScreen({super.key});

  @override
  State<OrderConfirmedScreen> createState() => _OrderConfirmedScreenState();
}

class _OrderConfirmedScreenState extends State<OrderConfirmedScreen> {
  Timer? _timer;
  int _remainingSeconds = 3;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_remainingSeconds == 0) {
          setState(() {
            timer.cancel();
          });
          navigate(
              context: context,
              isRemoveUntil: true,
              page: const SpinWheelPage());
        } else {
          setState(() {
            _remainingSeconds--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    // 3. Always cancel timers when leaving the screen
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: GetBuilder<OrderController>(builder: (orderController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: black),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 38),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: white,
                              radius: 28,
                              child: Center(
                                child: Icon(
                                  Icons.check,
                                  color: primaryColor,
                                  size: 32,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 9.0),
                              child: Text(
                                "Order Confirmed!",
                                style: Helper(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                            Text(
                              "Thanks for shopping with us.",
                              style: Helper(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 35),
                          Text(
                            "Order ID",
                            style:
                                Helper(context).textTheme.bodyMedium?.copyWith(
                                      color: primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "#${orderController.orderId ?? ""}",
                              style: Helper(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          Text(
                            "Order placed on ${DateFormatters().mdy.format(getDateTime())}",
                            style: Helper(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 35),
                        child: Divider(
                          color: grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order Status",
                              style: Helper(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 36),
                            const CustomImage(
                              path: Assets.imagesOrderStatusConfirmed,
                              height: 83,
                              width: 247,
                              fit: BoxFit.cover,
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 35),
                        child: Divider(
                          color: grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24, horizontal: 61),
                        child: CustomButton(
                          onTap: () {
                            navigate(
                                context: context, page: const SpinWheelPage());
                          },
                          radius: 100,
                          color: secondaryColor,
                          child: Text(
                            " ${_remainingSeconds}s Spin the wheel",
                            style: Helper(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const ConfirmReferAndEarnScreen()
              ],
            );
          }),
        ),
      ),
    );
  }
}
