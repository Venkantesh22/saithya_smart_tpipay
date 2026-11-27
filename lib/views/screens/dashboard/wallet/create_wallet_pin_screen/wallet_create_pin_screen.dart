import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';
import 'package:lekra/views/screens/dashboard/account_screen/account_screen.dart';
import 'package:lekra/views/screens/dashboard/wallet/create_wallet_pin_screen/wallet_create_pin_confirm_screen.dart';
import 'package:lekra/views/screens/dashboard/wallet/widget/back_key_cell.dart';
import 'package:lekra/views/screens/dashboard/wallet/widget/key_cell.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar_back_button.dart';

class WalletCreatePinScreen extends StatelessWidget {
  final bool isForResetPin;
  const WalletCreatePinScreen({super.key, this.isForResetPin = false});

  void onKeyPress(String value, WalletController walletController) {
    if (value == 'back') {
      if (walletController.createWalletPin.isNotEmpty) {
        walletController.createWalletPin = walletController.createWalletPin
            .substring(0, walletController.createWalletPin.length - 1);
        walletController.update();
      }
    } else if (walletController.createWalletPin.length < 6) {
      walletController.createWalletPin += value;
      walletController.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      builder: (walletController) {
        final isComplete = walletController.createWalletPin.length == 6;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            Get.find<DashBoardController>().dashPage = 0;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppbarBackButton(),
            body: SafeArea(
              child: Padding(
                padding: AppConstants.screenPadding,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const CustomImage(
                      path: Assets.imagesLocalBgGrey,
                      radius: 10,
                      width: 74,
                      height: 60,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      isForResetPin ? "Reset Your PIN" : "Create Your PIN",
                      style: Helper(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isForResetPin
                          ? "Enter your New PIN to reset."
                          : "This PIN secures your wallet and transactions.",
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: greyBillText),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        6,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color:
                                index < walletController.createWalletPin.length
                                    ? primaryColor
                                    : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),

                    // Number Pad
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var row in [
                          ['1', '2', '3'],
                          ['4', '5', '6'],
                          ['7', '8', '9'],
                          ['', '0', 'back'],
                        ])
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8), // row gap
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: row.map((val) {
                                if (val.isEmpty) {
                                  return const SizedBox(width: 102, height: 50);
                                } else if (val == 'back') {
                                  return BackKeyCell(
                                      onPressed: () =>
                                          onKeyPress(val, walletController));
                                } else {
                                  return KeyCell(
                                    label: val,
                                    onTap: () =>
                                        onKeyPress(val, walletController),
                                  );
                                }
                              }).toList(),
                            ),
                          ),
                      ],
                    ),

                    const Spacer(),

                    ProfileButton(
                      title: "Continue",
                      onPressed: () => isComplete
                          ? navigate(
                              context: context,
                              page: WalletCreatePinComfirmScreen(
                                isForResetPin: isForResetPin,
                              ),
                            )
                          : null,
                      color: primaryColor,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
