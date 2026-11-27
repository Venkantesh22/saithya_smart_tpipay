import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/input_decoration.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/auth_screens/forget_password/opt_verification_screen.dart';
import 'package:lekra/views/screens/dashboard/account_screen/account_screen.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar_back_button.dart';

class EnterNumberForOPTScreen extends StatefulWidget {
  const EnterNumberForOPTScreen({super.key});

  @override
  State<EnterNumberForOPTScreen> createState() =>
      _EnterNumberForOPTScreenState();
}

class _EnterNumberForOPTScreenState extends State<EnterNumberForOPTScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = Get.find<AuthController>();
      authController.numberController.clear();
      authController.update();
    });
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> _sendOtpFun({required AuthController authController}) async {
    if (_formKey.currentState?.validate() != true) return;
    authController
        .generateOtp(mobile: authController.numberController.text.trim())
        .then((value) {
      if (value.isSuccess) {
        navigate(
            context: context,
            page: OTPVerification(
                phone: authController.numberController.text.trim()));
        showToast(message: value.message, typeCheck: value.isSuccess);
      } else {
        showToast(message: value.message, typeCheck: value.isSuccess);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarBackButton(),
      bottomNavigationBar: SafeArea(
        child: GetBuilder<AuthController>(builder: (authController) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: ProfileButton(
              title: "Send OTP",
              color: primaryColor,
              onPressed: () => _sendOtpFun(authController: authController),
            ),
          );
        }),
      ),
      body: Padding(
        padding: AppConstants.screenPadding,
        child: GetBuilder<AuthController>(
          builder: (authController) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    "Forgot password?",
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Please enter your phone number to recover your OTP.",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                  const SizedBox(height: 40),

                  // Label
                  Text(
                    "Phone number",
                    style: Helper(context).textTheme.titleSmall?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),

                  // ✅ Proper Form
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      controller: authController.numberController,
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: CustomDecoration.inputDecoration(
                          bgColor: greyLight.withValues(alpha: 0.1),
                          hint: 'Enter mobile number',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          borderColor: greyDark,
                          hintStyle: Helper(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: greyDark, fontSize: 14),
                          prefixText: "+91"),
                      onChanged: (value) {
                        if (value.length == 10) {
                          _sendOtpFun(authController: authController);
                        }
                      },
                      validator: (value) {
                        final v = (value ?? '').trim();
                        if (v.isEmpty) {
                          return "Please enter your number";
                        }
                        if (v.length != 10) {
                          return "Phone number must be 10 digits";
                        }
                        // Optional: basic first-digit constraint for India
                        if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v)) {
                          return "Enter a valid Indian mobile number";
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) =>
                          _sendOtpFun(authController: authController),
                    ),
                  ),

                  const SizedBox(
                    height: 301,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
