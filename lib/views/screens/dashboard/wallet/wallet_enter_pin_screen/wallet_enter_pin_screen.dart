import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/controllers/order_controlller.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/controllers/subscription_controller.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/pay_section/mobile_recharge/mobile_recharge_select_no/success_recharge_screen/success_recharge_screen.dart';
import 'package:lekra/views/screens/auth_screens/forget_password/opt_verification_screen.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/dashboard/account_screen/account_screen.dart';
import 'package:lekra/views/screens/dashboard/wallet/create_wallet_pin_screen/wallet_create_pin_screen.dart';
import 'package:lekra/views/screens/dashboard/wallet/widget/back_key_cell.dart';
import 'package:lekra/views/screens/dashboard/wallet/widget/key_cell.dart';
import 'package:lekra/views/screens/order_confirmed/order_confirmed_screen.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar_back_button.dart';
import 'package:page_transition/page_transition.dart';

class WalletEnterPinScreen extends StatefulWidget {
  final bool isForResetPin;
  final bool isMemberShipPayment;
  final bool isMobileRecharge;

  const WalletEnterPinScreen({
    super.key,
    this.isMemberShipPayment = false,
    this.isForResetPin = false,
    this.isMobileRecharge = false,
  });

  @override
  State<WalletEnterPinScreen> createState() => _WalletEnterPinScreenState();
}

class _WalletEnterPinScreenState extends State<WalletEnterPinScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnim; // translates X
  bool _isShaking = false;
  bool _wasComplete = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    // reset pin on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final w = Get.find<WalletController>();
      w.walletPin = "";
      w.update();
    });

    // shake controller
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -14.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -14.0, end: 14.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 14.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(
        CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerShake() {
    setState(() => _isShaking = true);
    _shakeController.forward(from: 0).whenComplete(() {
      setState(() => _isShaking = false);
    });
    HapticFeedback.mediumImpact();
  }

  void onKeyPress(String value, WalletController walletController) {
    if (value == 'back') {
      if (walletController.walletPin.isNotEmpty) {
        walletController.walletPin = walletController.walletPin
            .substring(0, walletController.walletPin.length - 1);
        walletController.update();
      }
    } else if (walletController.walletPin.length < 6) {
      walletController.walletPin += value;
      walletController.update();
      HapticFeedback.selectionClick();
    }
  }

  Future<void> onTap() async {
    if (_isSubmitting) return;
    setState(() => _isSubmitting = true);

    if (widget.isMemberShipPayment) {
      Get.find<SubscriptionController>()
          .subscriptionCheckout(
              id: Get.find<SubscriptionController>().selectSubscription?.id)
          .then((value) {
        setState(() => _isSubmitting = false);
        if (value.isSuccess) {
          showToast(message: value.message, typeCheck: value.isSuccess);
          Get.find<DashBoardController>().dashPage = 3;
          navigate(context: context, page: const DashboardScreen());
        } else {
          _triggerShake();
          showToast(message: value.message, typeCheck: value.isSuccess);
        }
      }).catchError((_) {
        setState(() => _isSubmitting = false);
      });
      return;
    }

    if (widget.isForResetPin) {
      Get.find<WalletController>().verifyWalletPin().then((value) {
        setState(() => _isSubmitting = false);
        if (value.isSuccess) {
          navigate(
              context: context,
              type: PageTransitionType.rightToLeft,
              page: WalletCreatePinScreen(
                isForResetPin: widget.isForResetPin,
              ));
          showToast(message: value.message, typeCheck: value.isSuccess);
        } else {
          _triggerShake();
          showToast(message: value.message, typeCheck: value.isSuccess);
        }
      }).catchError((_) {
        setState(() => _isSubmitting = false);
      });
      return;
    }

    if (widget.isMobileRecharge == true) {
      final rechargeController = Get.find<RechargeController>();

      rechargeController.mobileRecharge().then((value) {
        setState(() => _isSubmitting = false);
        if (value.isSuccess) {
          Get.find<WalletController>().fetchWallet();
          navigate(context: context, page: SuccessRechargeScreen());
          showToast(message: value.message, typeCheck: value.isSuccess);
        } else {
          _triggerShake();
          showToast(message: value.message, typeCheck: value.isSuccess);
          pop(context);
        }
      }).catchError((_) {
        setState(() => _isSubmitting = false);
      });
      return;
    }

    Get.find<OrderController>()
        .postPayOrderWallet(orderId: Get.find<OrderController>().orderId)
        .then((value) {
      setState(() => _isSubmitting = false);
      if (value.isSuccess) {
        Get.find<WalletController>().fetchWallet();
        showToast(
            message:
                "Congratulations! Your order has been placed successfully",
            typeCheck: value.isSuccess);

        navigate(context: context, page: const OrderConfirmedScreen());
      } else {
        _triggerShake();
        showToast(message: value.message, typeCheck: value.isSuccess);
      }
    }).catchError((_) {
      setState(() => _isSubmitting = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      builder: (walletController) {
        final isComplete = walletController.walletPin.length == 6;

        if (_wasComplete != isComplete) {
          _wasComplete = isComplete;
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppbarBackButton(),
          body: SafeArea(
            child: Padding(
              padding: AppConstants.screenPadding,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const CustomImage(
                    path: Assets.imagesLocalBgGrey,
                    radius: 10,
                    width: 74,
                    height: 60,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.isForResetPin
                        ? "Enter Your Old  PIN"
                        : "Enter 6-Digit PIN",
                    style: Helper(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  widget.isForResetPin
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "This PIN secures your wallet and transactions.",
                                style: Helper(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: greyBillText,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              GetBuilder<AuthController>(
                                  builder: (authController) {
                                return TextButton(
                                  onPressed: () {
                                    navigate(
                                        context: context,
                                        page: OTPVerification(
                                          isForResetPin: widget.isForResetPin,
                                          phone: authController
                                                  .userModel?.mobile ??
                                              "",
                                        ));
                                  },
                                  child: Text(
                                    "forgot pin?",
                                    style: Helper(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: primaryColor,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }),
                            ],
                          ),
                        )
                      : Text(
                          "This PIN secures your wallet and transactions.",
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: greyBillText,
                              ),
                          textAlign: TextAlign.center,
                        ),
                  const SizedBox(height: 32),
                  AnimatedBuilder(
                    animation: _shakeAnim,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(_isShaking ? _shakeAnim.value : 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(6, (index) {
                            final filled =
                                index < walletController.walletPin.length;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOut,
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: filled ? 16 : 14,
                              height: filled ? 16 : 14,
                              decoration: BoxDecoration(
                                color: filled
                                    ? (_isShaking ? red : primaryColor)
                                    : Colors.grey[300],
                                shape: BoxShape.circle,
                                boxShadow: filled
                                    ? [
                                        BoxShadow(
                                          color: primaryColor.withOpacity(0.25),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        )
                                      ]
                                    : [],
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
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
                          padding: const EdgeInsets.symmetric(vertical: 8),
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
                    child: GetBuilder<OrderController>(
                      builder: (orderController) {
                        return AnimatedScale(
                          duration: const Duration(milliseconds: 160),
                          scale: isComplete ? 1.0 : 0.98,
                          child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 160),
                              opacity: isComplete ? 1.0 : 0.6,
                              child: ProfileButton(
                                  title: _isSubmitting ? "Processing..." : "Continue",
                                  onPressed: (isComplete && !_isSubmitting) ? onTap : null,
                                  color: primaryColor)),
                        );
                      },
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
