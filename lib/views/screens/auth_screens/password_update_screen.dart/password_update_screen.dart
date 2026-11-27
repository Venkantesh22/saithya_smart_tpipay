// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/input_decoration.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';
import 'package:lekra/views/screens/dashboard/account_screen/account_screen.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar_back_button.dart';

class PasswordUpdateScreen extends StatefulWidget {
  final bool? updatePassword;
  const PasswordUpdateScreen({super.key, this.updatePassword = false});

  @override
  State<PasswordUpdateScreen> createState() => _PasswordUpdateScreenState();
}

class _PasswordUpdateScreenState extends State<PasswordUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isMatch = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthController>().confirmPasswordController.clear();
      Get.find<AuthController>().passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarBackButton(
        onPressed: () {
          Get.find<DashBoardController>().dashPage = 4;
          navigate(context: context, page: const DashboardScreen());
        },
      ),
      bottomNavigationBar: SafeArea(
        child: GetBuilder<AuthController>(builder: (authController) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: ProfileButton(
              title: "Change password",
              color: primaryColor,
              onPressed: () async {
                final password = authController.passwordController.text.trim();
                final confirm =
                    authController.confirmPasswordController.text.trim();

                setState(() {
                  isMatch = password == confirm;
                });

                if (_formKey.currentState!.validate()) {
                  authController.updatePassword().then((value) {
                    if (value.isSuccess) {
                      if (widget.updatePassword == true) {
                        Get.find<DashBoardController>().dashPage = 4;
                        navigate(
                            context: context, page: const DashboardScreen());
                      } else {
                        navigate(
                            context: context,
                            isRemoveUntil: true,
                            page: const LoginScreen());
                      }

                      showToast(
                        message: value.message,
                        typeCheck: value.isSuccess,
                      );
                    } else {
                      showToast(
                        message: value.message,
                        typeCheck: value.isSuccess,
                      );
                    }
                  });
                }
              },
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
                    "Update password",
                    style: Helper(context).textTheme.titleMedium?.copyWith(
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Please enter your new password to continue",
                    style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "New password",
                          style: Helper(context).textTheme.titleSmall?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: authController.passwordController,
                          obscureText: true,
                          decoration: CustomDecoration.inputDecoration(
                            bgColor: greyLight.withValues(alpha: 0.1),
                            hint: 'Enter new password',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            borderColor: greyDark,
                            hintStyle: Helper(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: greyDark, fontSize: 14),
                          ),
                          validator: (value) {
                            final v = (value ?? '').trim();
                            if (v.isEmpty) return "Please enter new password";
                            if (v.length < 8) {
                              return "Password must be at least 8 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        Text(
                          "Confirm password",
                          style: Helper(context).textTheme.titleSmall?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: authController.confirmPasswordController,
                          onChanged: (val) {
                            setState(() {
                              isMatch = authController.passwordController.text
                                      .trim() ==
                                  val.trim();
                            });
                          },
                          decoration: CustomDecoration.inputDecoration(
                            bgColor: greyLight.withValues(alpha: 0.1),
                            hint: 'Enter confirm password',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            borderColor: greyDark,
                            hintStyle: Helper(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: greyDark, fontSize: 14),
                          ),
                          validator: (value) {
                            final v = (value ?? '').trim();
                            if (v.isEmpty) return "Please confirm password";
                            if (!isMatch) return "Passwords do not match";
                            return null;
                          },
                        ),
                        // ✅ Optional live feedback below field
                        if (!isMatch)
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              "Passwords do not match",
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 300),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
