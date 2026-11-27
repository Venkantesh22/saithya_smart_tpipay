// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/views/screens/auth_screens/password_update_screen.dart/password_update_screen.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/dashboard/wallet/create_wallet_pin_screen/wallet_create_pin_screen.dart';
import 'package:pinput/pinput.dart';
import '../../../../services/constants.dart';
import '../../../../services/theme.dart';
import '../../../base/common_button.dart';

class OTPVerification extends StatefulWidget {
  final String phone;
  final bool isForResetPin;
  final bool isVerificationPhone;
  final bool isUpdatePassword;
  final bool isUpdateNumber;
  const OTPVerification({
    super.key,
    required this.phone,
    this.isForResetPin = false,
    this.isVerificationPhone = false,
    this.isUpdatePassword = false,
    this.isUpdateNumber = false,
  });

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isForResetPin) {
        Get.find<AuthController>().generateOtp(mobile: widget.phone);
      } else if (widget.isUpdatePassword) {
        Get.find<AuthController>().generateOtp(mobile: widget.phone);
      } else if (widget.isVerificationPhone) {
        Get.find<AuthController>().generateResendOtp(mobile: widget.phone);
      } else if (widget.isUpdateNumber) {
        Get.find<AuthController>()
            .generateOtpFoUpdateMobileNo(mobile: widget.phone);
      }
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  static const _otpWindow = Duration(minutes: 5);
  Timer? _timer;
  int _secondsLeft = _otpWindow.inSeconds;
  bool reSendCode = false; // true => user can tap to resend
  bool _resending = false; // optional: to prevent double taps

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _secondsLeft = _otpWindow.inSeconds;
      reSendCode = false; // countdown running
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() {
          _secondsLeft = 0;
          reSendCode = true; // now user can resend
        });
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  String _formatMMSS(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _resendCode() async {
    if (!reSendCode || _resending) return; // only when allowed and not busy

    setState(() => _resending = true);

    try {
      if (widget.isForResetPin) {
        Get.find<AuthController>().generateOtp(mobile: widget.phone);
      } else if (widget.isUpdatePassword) {
        Get.find<AuthController>().generateOtp(mobile: widget.phone);
      } else if (widget.isVerificationPhone) {
        Get.find<AuthController>().generateResendOtp(mobile: widget.phone);
      } else if (widget.isUpdateNumber) {
        Get.find<AuthController>()
            .generateOtpFoUpdateMobileNo(mobile: widget.phone);
      }

      // Restart  cooldown
      _startTimer();
    } catch (e) {
      // Optionally show error toast
      showToast(message: 'Failed to resend OTP', toastType: ToastType.error);
      // Keep reSendCode = true so user can try again
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  Future<void> onTap() async {
    if (_pinController.text.length != 6) {
      showToast(message: 'Invalid Otp', toastType: ToastType.error);
      return;
    }
    if (widget.isVerificationPhone) {
      Get.find<AuthController>()
          .registerVerifyOtp(otp: _pinController.text.trim(), phone: widget.phone)
          .then((value) {
        if (value.isSuccess) {
          showToast(message: value.message, typeCheck: value.isSuccess);
          Get.find<DashBoardController>().dashPage = 0;
          navigate(context: context, page: const DashboardScreen(), isRemoveUntil: true);
        } else {
          showToast(message: value.message, typeCheck: value.isSuccess);
        }
      });
      return;
    } else if (widget.isUpdateNumber) {
      Get.find<AuthController>()
          .verifyOtpFoUpdateMobileNo(
        otp: _pinController.text.trim(),
      )
          .then((value) {
        if (value.isSuccess) {
          showToast(message: value.message, typeCheck: value.isSuccess);
          Get.find<DashBoardController>().dashPage = 4;
          navigate(context: context, page: const DashboardScreen());
        } else {
          showToast(message: value.message, typeCheck: value.isSuccess);
        }
      });
    } else {
      Get.find<AuthController>()
          .postVerifyOTP(mobile: widget.phone, otp: _pinController.text)
          .then((value) {
        if (value.isSuccess) {
          showToast(message: value.message, typeCheck: value.isSuccess);

          if (widget.isForResetPin) {
            navigate(
                context: context,
                page: const WalletCreatePinScreen(
                  isForResetPin: true,
                ));
            return;
          } else if (widget.isUpdatePassword) {
            navigate(
                context: context,
                page: const PasswordUpdateScreen(updatePassword: true));
            return;
          } else {
            navigate(context: context, page: const PasswordUpdateScreen());
          }
        } else {
          showToast(message: value.message, typeCheck: value.isSuccess);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: AppConstants.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter Your OTP",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black,
                  ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "We have sent the verification to +91 ${widget.phone}",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            const Spacer(),
            Column(
              children: [
                GetBuilder<AuthController>(builder: (auth) {
                  final otp = auth.lastReceivedOtp ?? "123456";
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      onTap: () {
                        _pinController.text = otp;
                        setState(() {});
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.indigo.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.mark_email_read_rounded, size: 16, color: primaryColor),
                            const SizedBox(width: 6),
                            Text(
                              "OTP: $otp • Tap to fill",
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                Pinput(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  controller: _pinController,
                  length: 6,
                  defaultPinTheme: PinTheme(
                    width: 45,
                    height: 55,
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.black.withOpacity(0.3),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 45,
                    height: 55,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: 45,
                    height: 55,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 60),
                const Text("Didn’t receive any code?"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: reSendCode && !_resending ? _resendCode : null,
                      child: Text(
                        reSendCode
                            ? (_resending
                                ? "Resending..."
                                : "Tap to resend code")
                            : "Resend a new code   ",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          decoration: reSendCode && !_resending
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                    if (!reSendCode)
                      Text(
                        _formatMMSS(_secondsLeft),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                )
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalPadding, vertical: 15),
          child: SizedBox(
            height: 50,
            child: CustomButton(
              radius: 6,
              elevation: 0,
              color: primaryColor,
              onTap: onTap,
              child: Text(
                'Next',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 14,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
