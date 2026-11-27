import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';

class PayTopSection extends StatelessWidget {
  const PayTopSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: AppConstants.screenPadding,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              primaryColor.withValues(alpha: 0.5),
              white,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: white,
                    ),
                  ),
                  Text(
                    AppConstants.payAppName,
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: white,
                        ),
                  ),
                  const SizedBox(
                    width: 40,
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              GetBuilder<AuthController>(builder: (authController) {
                return Row(
                  children: [
                    CustomImage(
                      path: authController.userModel?.image != null &&
                              (authController.userModel?.image ?? "").isNotEmpty
                          ? authController.userModel?.image ?? ""
                          : Assets.imagesPayUserProfile,
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                      radius: 100,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello, ${authController.userModel?.fullName ?? ""}",
                            overflow: TextOverflow.clip,
                            style:
                                Helper(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          Text(
                            "Your Wallet Balance: ₹${authController.userModel?.currentWallet ?? ""}",
                            overflow: TextOverflow.clip,
                            style:
                                Helper(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: black.withValues(alpha: 0.50),
                                    ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.find<DashBoardController>().dashPage = 1;
                        navigate(
                            context: context, page: const DashboardScreen());
                      },
                      child: const CustomImage(
                        path: Assets.imagesPayWallet,
                        height: 30,
                        width: 30,
                      ),
                    )
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
