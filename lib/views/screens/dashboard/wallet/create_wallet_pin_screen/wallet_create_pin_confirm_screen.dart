import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/dashboard/account_screen/account_screen.dart';
import 'package:lekra/views/screens/dashboard/wallet/widget/back_key_cell.dart';
import 'package:lekra/views/screens/dashboard/wallet/widget/key_cell.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar_back_button.dart';

class WalletCreatePinComfirmScreen extends StatefulWidget {
  final bool isForResetPin;
  const WalletCreatePinComfirmScreen({super.key, this.isForResetPin = false});

  @override
  State<WalletCreatePinComfirmScreen> createState() =>
      _WalletCreatePinComfirmScreenState();
}   

class _WalletCreatePinComfirmScreenState
    extends State<WalletCreatePinComfirmScreen>
    with SingleTickerProviderStateMixin {
  bool isPinMatch = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -16.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -16.0, end: 16.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 16.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void onKeyPress(String value, WalletController walletController) {
    if (value == 'back') {
      if (walletController.createWalletPinConfirm.isNotEmpty) {
        walletController.createWalletPinConfirm = walletController
            .createWalletPinConfirm
            .substring(0, walletController.createWalletPinConfirm.length - 1);
        walletController.update();
      }
    } else if (walletController.createWalletPinConfirm.length < 6) {
      walletController.createWalletPinConfirm += value;
      walletController.update();
    }
  }

  void triggerShake() {
    setState(() => isPinMatch = true);
    _shakeController.forward(from: 0).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() => isPinMatch = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      builder: (walletController) {
        final isComplete = walletController.createWalletPinConfirm.length == 6;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar:  CustomAppbarBackButton(),
          body: SafeArea(
            child: Padding(
              padding: AppConstants.screenPadding,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Text(
                    "Confirm Your PIN",
                    style: Helper(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Re-enter your 6-digit PIN to confirm.",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: greyBillText),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset:
                            Offset(isPinMatch ? _shakeAnimation.value : 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            6,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: index <
                                        walletController
                                            .createWalletPinConfirm.length
                                    ? isPinMatch &&
                                            walletController
                                                    .createWalletPinConfirm
                                                    .length ==
                                                6
                                        ? red
                                        : primaryColor
                                    : Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  // Number Pad
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var row in [
                        ['1', '2', '3'],
                        ['4', '5', '6'],
                        ['7', '8', '9'],
                        ['', '0', 'back'],
                      ])
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8), // row gap
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: row.map((val) {
                              if (val.isEmpty) {
                                return const SizedBox(width: 102, height: 50);
                              } else if (val == 'back') {
                                return BackKeyCell(
                                    onPressed: () =>
                                        onKeyPress(val, walletController));
                              } else {
                                return KeyCell(
                                  label: val,
                                  onTap: () =>
                                      onKeyPress(val, walletController),
                                );
                              }
                            }).toList(),
                          ),
                        ),
                    ],
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: ProfileButton(
                      color: primaryColor,
                      onPressed: isComplete
                          ? () {
                              log("walletController.walletPin ${walletController.createWalletPin}");
                              log("walletController.walletPin confirm ${walletController.createWalletPinConfirm}");
                              if (walletController.createWalletPin ==
                                  walletController.createWalletPinConfirm) {
                                if (widget.isForResetPin) {
                                  walletController
                                      .postWalletReSetPin()
                                      .then((value) {
                                    if (value.isSuccess) {
                                      Get.find<DashBoardController>().dashPage =
                                          1;
                                      navigate(
                                          isRemoveUntil: true,
                                          context: context,
                                          page: const DashboardScreen());
                                      showToast(
                                          message: value.message,
                                          typeCheck: value.isSuccess);
                                    } else {
                                      showToast(
                                          message: value.message,
                                          typeCheck: value.isSuccess);
                                    }
                                  });
                                } else {
                                  walletController
                                      .postCreateWalletPin()
                                      .then((value) {
                                    if (value.isSuccess) {
                                      Get.find<DashBoardController>().dashPage =
                                          1;
                                      navigate(
                                          isRemoveUntil: true,
                                          context: context,
                                          page: const DashboardScreen());
                                      showToast(
                                          message: value.message,
                                          typeCheck: value.isSuccess);
                                    } else {
                                      showToast(
                                          message: value.message,
                                          typeCheck: value.isSuccess);
                                    }
                                  });
                                }
                              } else {
                                triggerShake();
                              }
                            }
                          : null,
                      title: "Continue",
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
