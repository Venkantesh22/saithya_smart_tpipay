import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lekra/controllers/dynamic_qr_controller.dart';
import 'package:lekra/controllers/subscription_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/order_confirmed/order_confirmed_screen.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPaymentScreen extends StatefulWidget {
  final bool isMemberShipPayment;
  const QRPaymentScreen({
    super.key,
    this.isMemberShipPayment = false,
  });

  @override
  State<QRPaymentScreen> createState() => _QRPaymentScreenState();
}

class _QRPaymentScreenState extends State<QRPaymentScreen> {
  final DynamicQRController _controller = Get.find<DynamicQRController>();

  static const int _totalSeconds = 5 * 60;
  int _remainingSeconds = _totalSeconds;
  Timer? _countdownTimer;
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.isMemberShipPayment) {
        final subscriptionID =
            Get.find<SubscriptionController>().selectSubscription?.id;
        await _controller
            .checkoutDynamicQRSubscriptionPayment(
                subscriptionID: subscriptionID)
            .then((value) {
          if (value.isSuccess) {
            _startCountdown();

            _statusTimer =
                Timer.periodic(const Duration(milliseconds: 2000), (_) async {
              await _controller
                  .checkDynamicQRSubscriptionPaymentStatus()
                  .then((val) {
                if (val.isSuccess) {
                  if (_controller.isDynamicQRPaymentDone) {
                    _statusTimer?.cancel();
                    showToast(
                        message:
                            "Congratulations! Your Subscription has been active successfully",
                        typeCheck: value.isSuccess);

                    navigate(
                        context: context, page: const OrderConfirmedScreen());
                  }

                  if (!mounted) return;
                }
              });
            });
          } else {
            showToast(message: value.message, typeCheck: value.isSuccess);
          }
        });
      } else {
        _controller.dynamicQR().then((value) {
          if (value.isSuccess) {
            _startCountdown();

            _statusTimer =
                Timer.periodic(const Duration(milliseconds: 2000), (_) async {
              await _controller.checkPaymentStatus().then((val) {
                if (val.isSuccess) {
                  if (_controller.isDynamicQRPaymentDone) {
                    _statusTimer?.cancel();
                    showToast(
                        message:
                            "Congratulations! Your order has been placed successfully",
                        typeCheck: value.isSuccess);

                    navigate(
                        context: context, page: const OrderConfirmedScreen());
                  }

                  if (!mounted) return;
                }
              });
            });
          } else {
            showToast(message: value.message, typeCheck: value.isSuccess);
          }
        });
      }
    });
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_remainingSeconds <= 1) {
        setState(() => _remainingSeconds = 0);
        t.cancel();

        // stop polling if QR expired
        _statusTimer?.cancel();

        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          pop(context);
        }
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  String _formatMMSS(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar2(title: "Pay with QR"),
      body: Center(
        child: Padding(
          padding: AppConstants.screenPadding,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                decoration: BoxDecoration(
                  color: grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Scan to Pay",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    GetBuilder<DynamicQRController>(
                      builder: (dynamicQRController) {
                        if (dynamicQRController.isLoading) {
                          return const SizedBox(
                            height: 300,
                            width: 300,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final data =
                            dynamicQRController.dynamicModel?.qrString ?? "";
                        if (data.isEmpty) {
                          return const SizedBox(
                            height: 300,
                            width: 300,
                            child: Center(child: Text("QR not ready")),
                          );
                        }
                        return QrImageView(
                          data: data,
                          version: QrVersions.auto,
                          size: 300.0,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _formatMMSS(_remainingSeconds),
                      textAlign: TextAlign.center,
                      style: Helper(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: red,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
