// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/input_decoration.dart';
import 'package:lekra/services/route_helper.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/auth_screens/forget_password/enter_number_for_opt_screen.dart';
import 'package:lekra/views/screens/auth_screens/forget_password/opt_verification_screen.dart';
import 'package:lekra/views/screens/auth_screens/signup_screen.dart';
import 'package:lekra/views/screens/dashboard/account_screen/screen/privacy_center_screen.dart';
import 'package:lekra/views/screens/dashboard/account_screen/screen/terms_conditions_screen.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/widget/text_box/app_text_box.dart';

import '../../../services/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showPassword = false;

  final _formKey = GlobalKey<FormState>();
  bool isEmailLogin = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authController = Get.find<AuthController>();
      authController.emailController.clear();
      authController.numberController.clear();
      authController.passwordController.clear();
      authController.update();
    });
  }

  Future<void> _loginTap(AuthController authController) async {
    if (authController.isLoading) {
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      isEmailLogin =
          GetUtils.isEmail(authController.emailController.text.trim());
      authController.userLogin(isEmail: isEmailLogin).then(
        (value) {
          if (value.isSuccess) {
            if (authController.isPhoneNumberVerified) {
              Get.find<DashBoardController>().dashPage = 0;
              navigate(
                  context: context,
                  page: const DashboardScreen(),
                  isRemoveUntil: true);
              showToast(message: value.message, typeCheck: value.isSuccess);
            } else {
              navigate(
                context: context,
                page: OTPVerification(
                  phone: authController.numberController.text,
                  isVerificationPhone: true,
                ),
              );
              showToast(message: value.message, typeCheck: value.isSuccess);
            }
          } else {
            showToast(message: value.message, typeCheck: value.isSuccess);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: loginPageBg,
      body: Center(
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
                LogoWithWidget(),
                Text(
                  "Welcome Back",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  "Login to continue",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: GetBuilder<AuthController>(builder: (authController) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mobile/Email",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        AppTextFieldWithHeading(
                          controller: authController.emailController,
                          hindText: "Enter your Mobile no. / Email",
                          hintStyle:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: grey,
                                  ),
                          keyboardType: TextInputType.emailAddress,
                          borderWidth: 2,
                          borderColor: black,
                          bgColor: white,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email or number";
                            }

                            bool isEmail = GetUtils.isEmail(value);

                            bool isPhone =
                                RegExp(r'^[0-9]{10}$').hasMatch(value);

                            if (!isEmail && !isPhone) {
                              return "Please enter a valid email or 10-digit mobile number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Password",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        TextFormField(
                          controller: authController.passwordController,
                          obscureText: !showPassword,
                          decoration: CustomDecoration.inputDecoration(
                            suffix: IconButton(
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                            hint: "Enter your Password",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: grey,
                                ),
                          ),
                          onFieldSubmitted: (_) => _loginTap(authController),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your Password";
                            }

                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GetBuilder<AuthController>(builder: (authController) {
                          return GestureDetector(
                            onTap: () => _loginTap(authController),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: authController.isLoading
                                    ? const CircularProgressIndicator(
                                        color: white,
                                      )
                                    : Text(
                                        "Login",
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
                        const SizedBox(height: 8),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
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
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    navigate(
                                        context: context,
                                        page: const TermsAndConditionScreen());
                                  },
                              ),
                              const TextSpan(
                                text: " and ",
                              ),
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    navigate(
                                        context: context,
                                        page: const PrivacyCenterScreen());
                                  },
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  navigate(
                                      context: context,
                                      page: const EnterNumberForOPTScreen());
                                },
                                child: Text(
                                  "Forget password",
                                  style: Helper(context).textTheme.bodyMedium,
                                )),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              getCustomRoute(child: const SignUPScreen()),
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
                                  text: "Don’t have an account? ",
                                ),
                                TextSpan(
                                  text: "Register",
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
                          ),
                        )
                      ],
                    );
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
