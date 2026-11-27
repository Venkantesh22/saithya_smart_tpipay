import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/dashboard/profile_edit/profile_edit_screen.dart';
import 'package:lekra/views/screens/premium_screen/premium_screen.dart';

class UserProfileContainer extends StatelessWidget {
  const UserProfileContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  color: black.withValues(alpha: 0.26),
                  spreadRadius: 0,
                  blurRadius: 4,
                )
              ]),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 36.5,
                    backgroundColor: white,
                    child: CustomImage(
                        height: 64,
                        width: 64,
                        radius: 100,
                        isProfile: true,
                        path: authController.userModel?.image ?? ""),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authController.userModel?.fullName ?? "qqq",
                          overflow: TextOverflow.ellipsis,
                          style: Helper(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: white),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          authController.userModel?.email ?? "",
                          overflow: TextOverflow.ellipsis,
                          style: Helper(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: white),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () => navigate(
                              context: context,
                              page: const ProfileEditScreen()),
                          child: Row(
                            children: [
                              Text(
                                "Edit Profile  ",
                                style: Helper(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: white),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: white,
                                size: 14,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              authController.userModel?.subscription?.isActive == true
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Divider(
                            color: white,
                            radius: BorderRadius.circular(6),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => navigate(
                              context: context, page: const PremiumScreen()),
                          child: Row(
                            children: [
                              const CustomImage(
                                path: Assets.imagesPremium,
                                height: 24,
                                width: 24,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "Premium",
                                  style: Helper(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: yellow),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: yellow,
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox()
            ],
          ),
        );
      },
    );
  }
}
