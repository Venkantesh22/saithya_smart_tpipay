import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/route_helper.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';

import '../../../services/theme.dart';
import '../common_button.dart';

showLogoutDialogue({required BuildContext context}) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return const LogoutDialog();
    },
  );
}

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.redAccent,
                  )),
              child: const Icon(Icons.logout, color: Colors.redAccent),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Oh no! You're leaving...\nAre you sure?",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomButton(
                radius: 6,
                type: ButtonType.secondary,
                title: 'No',
                height: 46,
                onTap: () {
                  Navigator.pop(context, false);
                },
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            GetBuilder<DashBoardController>(builder: (dashBoardController) {
              return GetBuilder<AuthController>(builder: (authController) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: CustomButton(
                    color: primaryColor,
                    radius: 6,
                    type: ButtonType.primary,
                    title: 'Yes, Log Me Out',
                    height: 46,
                    onTap: () async {
                      // AuthController auth = Get.find<AuthController>();
                      authController.logout().then(
                        (value) {
                          if (value.isSuccess) {
                            authController.logout();
                            authController.clearSharedData();
                            authController.update();
                            dashBoardController.dashPage = 0;
                            Navigator.pushAndRemoveUntil(
                              context,
                              getCustomRoute(
                                child: const LoginScreen(),
                              ),
                              (route) => false,
                            );
                            showToast(
                                message: value.message,
                                typeCheck: value.isSuccess);
                          } else {
                            showToast(
                                message: value.message,
                                typeCheck: value.isSuccess);
                          }
                        },
                      );
                    },
                  ),
                );
              });
            }),
          ],
        ),
      ),
    );
  }
}
