import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/route_helper.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/auth_screens/forget_password/opt_verification_screen.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';
import 'package:lekra/views/screens/dashboard/account_screen/screen/privacy_center_screen.dart';
import 'package:lekra/views/screens/dashboard/account_screen/screen/terms_conditions_screen.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

import '../../../services/theme.dart';

class SignUPScreen extends StatefulWidget {
  const SignUPScreen({super.key});

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = Get.find<AuthController>();
      authController.checkReferral();
      authController.firstNameController.clear();
      authController.lastNameController.clear();
      authController.emailController.clear();
      authController.numberController.clear();
      authController.passwordController.clear();
      authController.confirmPasswordController.clear();
      authController.update();
    });
  }

  bool termsAndConditions = false;

  Future<void> _registerFun({required AuthController authController}) async {
    if (authController.isLoading) {
      return;
    }

    if (!termsAndConditions) {
      return showToast(
          message: "Select Term & condition and Privacy Policy",
          toastType: ToastType.error);
    } else if (!termsAndConditions) {
      return showToast(
          message: "Select Term & condition", toastType: ToastType.error);
    }

    if (_formKey.currentState?.validate() ?? false) {
      signUp(authController);
    }
  }

  final _formKey = GlobalKey<FormState>();
  signUp(AuthController authController) {
    authController.registerUser().then(
      (value) {
        if (value.isSuccess) {
          Navigator.of(context).push(
            getCustomRoute(
              child: OTPVerification(
                phone: authController.numberController.text.trim(),
                isVerificationPhone: true,
              ),
            ),
          );
          showToast(message: value.message, typeCheck: value.isSuccess);
        } else {
          showToast(message: value.message, toastType: ToastType.warning);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: loginPageBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: grey.withValues(alpha: 0.3),
                        blurRadius: 4,
                        spreadRadius: 0,
                        offset: const Offset(0, 4))
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CustomImage(
                    path: Assets.imagesOnlyLogo,
                    height: 80,
                    width: 80,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    "Create an Account",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    "join us and start your journey",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child:
                        GetBuilder<AuthController>(builder: (authController) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppTextFieldWithHeading(
                                      controller:
                                          authController.firstNameController,
                                      hindText: "Enter your first name",
                                      heading: "First Name",
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: grey,
                                          ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter your first name";
                                        }

                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppTextFieldWithHeading(
                                      controller:
                                          authController.lastNameController,
                                      heading: "Last Name",
                                      hindText: "Enter your last name",
                                      hintStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: grey,
                                          ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter your last name";
                                        }

                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextFieldWithHeading(
                            controller: authController.emailController,
                            heading: "Email",
                            hindText: "Enter your Email",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: grey,
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your email";
                              }
                              if (!GetUtils.isEmail(value)) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextFieldWithHeading(
                            controller: authController.numberController,
                            heading: "Mobile",
                            hindText: "Enter your Mobile number",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: grey,
                                ),
                            prefixText: "+91",
                            prefixStyle:
                                Helper(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 16,
                                      color: black,
                                      fontWeight: FontWeight.bold,
                                    ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your Mobile number";
                              }
                              if (value.length != 10) {
                                return "Please number should be 10 digit";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextFieldWithHeading(
                            controller: authController.passwordController,
                            obscureText: true,
                            heading: "Password",
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) =>
                                _registerFun(authController: authController),
                            hindText: "Enter your Password",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: grey,
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your password";
                              }

                              if (value.length < 8) {
                                return "Password must be at least 8 characters";
                              }

                              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                return "Add at least 1 uppercase letter";
                              }

                              if (!RegExp(r'[a-z]').hasMatch(value)) {
                                return "Add at least 1 lowercase letter";
                              }

                              if (!RegExp(r'[0-9]').hasMatch(value)) {
                                return "Add at least 1 number";
                              }

                              if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                  .hasMatch(value)) {
                                return "Add at least 1 special character";
                              }

                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: ValueListenableBuilder(
                              valueListenable:
                                  authController.passwordController,
                              builder: (context, value, child) {
                                final password =
                                    authController.passwordController.text;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    passwordRule(
                                      isValid: password.length >= 8,
                                      text: "Minimum 8 characters",
                                    ),
                                    passwordRule(
                                      isValid:
                                          RegExp(r'[A-Z]').hasMatch(password),
                                      text: "One uppercase letter",
                                    ),
                                    passwordRule(
                                      isValid:
                                          RegExp(r'[a-z]').hasMatch(password),
                                      text: "One lowercase letter",
                                    ),
                                    passwordRule(
                                      isValid:
                                          RegExp(r'[0-9]').hasMatch(password),
                                      text: "One number",
                                    ),
                                    passwordRule(
                                      isValid:
                                          RegExp(r'[!@#\$%^&*(),.?\":{}|<>]')
                                              .hasMatch(password),
                                      text: "One special character",
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextFieldWithHeading(
                            controller:
                                authController.confirmPasswordController,
                            obscureText: true,
                            heading: "Confirm Password",
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) =>
                                _registerFun(authController: authController),
                            hindText: "Enter Password again",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: grey,
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please confirm password";
                              }

                              if (value !=
                                  authController.passwordController.text) {
                                return "Passwords do not match";
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          AppTextFieldWithHeading(
                            controller: authController.referralCodeController,
                            heading: "referral code (optional)",
                            hindText: "Enter your referral code (if any)",
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) =>
                                _registerFun(authController: authController),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: grey,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                    value: termsAndConditions,
                                    side: BorderSide(color: primaryColor),
                                    onChanged: (value) {
                                      setState(() {
                                        termsAndConditions =
                                            !termsAndConditions;
                                      });
                                    }),
                                Expanded(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                      children: [
                                        const TextSpan(
                                          text:
                                              "By continuing, you confirm that you are 18 years of age and you agree to the Trust India ",
                                        ),
                                        TextSpan(
                                          text: "Terms of Use",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              navigate(
                                                  context: context,
                                                  page:
                                                      const TermsAndConditionScreen());
                                            },
                                        ),
                                        const TextSpan(
                                          text: " and ",
                                        ),
                                        TextSpan(
                                          text: "Privacy Policy",
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              navigate(
                                                  context: context,
                                                  page:
                                                      const PrivacyCenterScreen());
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GetBuilder<AuthController>(builder: (authController) {
                            return GestureDetector(
                              onTap: () =>
                                  _registerFun(authController: authController),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Center(
                                  child: authController.isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : Text(
                                          "Register",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: white,
                                              ),
                                        ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  getCustomRoute(
                                    child: const LoginScreen(),
                                  ),
                                );
                              },
                              child: RichText(
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.clip,
                                text: TextSpan(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  children: [
                                    const TextSpan(
                                      text: "Already have an account? ",
                                    ),
                                    TextSpan(
                                      text: "Login",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: secondaryColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ))
                        ],
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordRule({
    required bool isValid,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isValid ? Colors.green : Colors.grey,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isValid ? Colors.green : Colors.grey,
                fontSize: 13,
                fontWeight: isValid ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
