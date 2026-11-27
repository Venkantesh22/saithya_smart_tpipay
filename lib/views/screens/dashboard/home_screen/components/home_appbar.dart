import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/dashboard/account_screen/account_screen.dart';
import 'package:lekra/views/screens/dashboard/search_screen/search_screen.dart';
import 'package:lekra/views/screens/widget/card_icon.dart';
import 'package:lekra/views/screens/widget/not_icon.dart';

class HomeApp extends StatelessWidget implements PreferredSizeWidget {
  const HomeApp({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: GetBuilder<AuthController>(builder: (authController) {
        return GestureDetector(
          onTap: () {
            navigate(context: context, page: const AccountScreen());
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 16),
            child: Stack(
              children: [
                CustomImage(
                  path: authController.userModel?.image ?? "",
                  height: 36,
                  width: 36,
                  isProfile: true,
                  fit: BoxFit.cover,
                  radius: 100,
                ),
              ],
            ),
          ),
        );
      }),
      title: GestureDetector(
        onTap: () {
          navigate(context: context, page: const SearchScreen());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
              color: grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Icon(
                Icons.search,
                color: grey.withValues(
                  alpha: 0.6,
                ),
                size: 24,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "Search ",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16, fontWeight: FontWeight.w600, color: grey),
              )
            ],
          ),
        ),
      ),
      actions: const [
        NotIcon(),
        CardIcon(),
        SizedBox(
          width: 6,
        ),
      ],
    );
  }
}
