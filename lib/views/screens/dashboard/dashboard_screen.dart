import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lekra/views/screens/dashboard/account_screen/account_screen.dart';
import 'package:lekra/views/screens/dashboard/home_screen/home_screen.dart';
import 'package:lekra/views/screens/dashboard/referral/referral_screen/referral_screen.dart';
import 'package:lekra/views/screens/dashboard/wallet/wallet_screen/wallet_screen.dart';
import 'package:lekra/views/screens/order_screem/screen/order_screen.dart';

import '../../../controllers/dashboard_controller.dart';
import '../../../generated/assets.dart';
import '../../../services/theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final dashController = Get.find<DashBoardController>();

        // If user is on any other tab (Wallet, Order, Referral, Account),
        // pressing Back returns smoothly to Home without closing the app.
        if (dashController.dashPage != 0) {
          dashController.dashPage = 0;
          dashController.update();
          return;
        }

        // When already on Home, prompt user before exiting
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(true), // Returns true
                child: const Text('Yes'),
              ),
            ],
          ),
        );

        if (shouldExit == true) {
          // Close the app
          if (context.mounted) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: GetBuilder<DashBoardController>(
          builder: (DashBoardController controller) {
            return [
              const HomeScreen(),
              const WalletScreen(),
              const OrderScreen(),
              const ReferralScreen(),
              const AccountScreen(),
            ][controller.dashPage];
          },
        ),
        bottomNavigationBar: GetBuilder<DashBoardController>(
          builder: (controller) {
            return SafeArea(
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: backgroundLight,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Each item approx width
                    const itemWidth = 80.0; // adjust if needed
                    final needScroll = 5 * itemWidth > constraints.maxWidth;

                    if (!needScroll) {
                      // ⭐ Items fit → use Row expanded
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildItem(controller, 0, "Home", Assets.svgsHome),
                          buildItem(controller, 1, "Wallet", Assets.svgsWallet),
                          buildItem(
                              controller, 2, "Order", Assets.svgsShopping),
                          buildItem(
                              controller, 3, "Referral", Assets.svgsReferral),
                          buildItem(
                              controller, 4, "Account", Assets.svgsProfile),
                        ],
                      );
                    }

                    // ⭐ Overflow → enable horizontal scroll
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          buildItem(controller, 0, "Home", Assets.svgsHome),
                          buildItem(controller, 1, "Wallet", Assets.svgsWallet),
                          buildItem(
                              controller, 2, "Order", Assets.svgsShopping),
                          buildItem(
                              controller, 3, "Referral", Assets.svgsReferral),
                          buildItem(
                              controller, 4, "Account", Assets.svgsProfile),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

///
class BottomNavigationItemWidget extends StatelessWidget {
  const BottomNavigationItemWidget({
    super.key,
    required this.title,
    required this.icon,
    this.isActive = false,
    this.onTap,
  });

  final String title;
  final String icon;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(
              icon,
              width: icon.contains('logout') ? 20 : 24,
              height: icon.contains('logout') ? 20 : 24,
              colorFilter: ColorFilter.mode(
                  isActive ? primaryColor : Colors.black87, BlendMode.srcIn),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isActive ? primaryColor : const Color(0xFF393648),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildItem(
    DashBoardController controller, int index, String title, String icon) {
  return Expanded(
    child: GestureDetector(
      onTap: () => controller.dashPage = index,
      child: BottomNavigationItemWidget(
        title: title,
        icon: icon,
        isActive: controller.dashPage == index,
      ),
    ),
  );
}
