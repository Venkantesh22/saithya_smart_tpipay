// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/firebase/block_screen.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/auth_screens/login_screen.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';
import 'package:lekra/views/screens/splash_screen/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../generated/assets.dart';
import '../../../services/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuth();
    });
  }

  Future<void> checkAuth() async {
    try {
      // 1. Check app block status
      if (Get.isRegistered<BasicController>()) {
        // final basicController = Get.find<BasicController>();
        // await basicController.isCheckApp();

        // bool isBlock = basicController.blockModel?.isBlock ?? false;
        // bool isTimeBlock = basicController.blockModel?.timeBlock ?? false;

        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        // log("isBlock == $isBlock, isTimeBlock == $isTimeBlock");

        // if (isBlock) {
        //   if (!mounted) return;

        //   navigate(
        //     context: context,
        //     page: const FlashMessageScreen(),
        //     isRemoveUntil: true,
        //   );
        //   return;
        // }

        // if (isTimeBlock) {
        //   basicController.startRandomCloseTimer();
        // }

        // 2. Check demo status FIRST
        final bool isDemoShow =
            sharedPreferences.getBool(AppConstants.isDemoShowKey) ?? false;

        log("isDemoShow == $isDemoShow");

        if (isDemoShow) {
          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const LoginScreen(),
            ),
          );
          return;
        }
      }

      // 3. Check AuthController registration
      await Future.delayed(const Duration(milliseconds: 1500));

      if (!mounted) return;

      if (!Get.isRegistered<AuthController>()) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
        return;
      }

      final authController = Get.find<AuthController>();

      // 4. Check token before fetching profile
      final String token = authController.getUserToken();

      if (token.isEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
        return;
      }

      // 5. Fetch profile only if token exists
      final response = await authController.fetchUserProfile().timeout(
            const Duration(seconds: 4),
            onTimeout: () => ResponseModel(false, "Timeout"),
          );

      if (!mounted) return;

      if (response.isSuccess) {
        if (authController.userModel?.isPhoneVerified == false) {
          navigate(
            context: context,
            page: const LoginScreen(),
            isRemoveUntil: true,
          );

          showToast(
            message: "Please verify phone number to continue",
            toastType: ToastType.warning,
          );
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const DashboardScreen(),
          ),
        );
      } else {
        await authController.logout();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const OnboardingScreen(),
          ),
        );
      }
    } catch (e) {
      log("Error during splash navigation: $e");

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset(
              Assets.imagesOnlyLogo,
              height: size.height * 0.25,
              width: size.height * 0.25,
              errorBuilder: (_, __, ___) => Icon(
                Icons.shopping_bag_outlined,
                size: 80,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
            ),
            const SizedBox(height: 30),
            CircularProgressIndicator(color: primaryColor),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
