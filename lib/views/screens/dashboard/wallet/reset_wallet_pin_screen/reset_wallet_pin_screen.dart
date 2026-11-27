// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lekra/controllers/wallet_controller.dart';
// import 'package:lekra/services/constants.dart';
// import 'package:lekra/services/theme.dart';
// import 'package:lekra/views/screens/dashboard/wallet/create_wallet_pin_screen/wallet_create_pin_confirm_screen.dart';
// import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar_back_button.dart';

// class ResetWalletPinScreen extends StatelessWidget {
//   const ResetWalletPinScreen({super.key});

//   void onKeyPress(String value, WalletController walletController) {
//     if (value == 'back') {
//       if (walletController.createWalletPin.isNotEmpty) {
//         walletController.createWalletPin = walletController.createWalletPin
//             .substring(0, walletController.createWalletPin.length - 1);
//         walletController.update();
//       }
//     } else if (walletController.createWalletPin.length < 6) {
//       walletController.createWalletPin += value;
//       walletController.update();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<WalletController>(
//       builder: (walletController) {
//         final isComplete = walletController.createWalletPin.length == 6;

//         return Scaffold(
//           backgroundColor: Colors.white,
//           appBar: const CustomAppbarBackButton(),
//           body: SafeArea(
//             child: Padding(
//               padding: AppConstants.screenPadding,
//               child: Column(
//                 children: [
//                   const SizedBox(height: 40),

//                   const SizedBox(height: 24),
//                   Text(
//                     "Reset Your PIN",
//                     style: Helper(context)
//                         .textTheme
//                         .titleMedium
//                         ?.copyWith(fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Re-enter your 6-digit PIN to confirm.",
//                     style: Helper(context).textTheme.bodyMedium?.copyWith(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 14,
//                         color: greyBillText),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 32),

//                   // PIN Circles
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(
//                       6,
//                       (index) => Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 6),
//                         width: 14,
//                         height: 14,
//                         decoration: BoxDecoration(
//                           color: index < walletController.createWalletPin.length
//                               ? primaryColor
//                               : Colors.grey[300],
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const Spacer(),

//                   // Number Pad
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       for (var row in [
//                         ['1', '2', '3'],
//                         ['4', '5', '6'],
//                         ['7', '8', '9'],
//                         ['', '0', 'back'],
//                       ])
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 8), // row gap
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: row.map((val) {
//                               if (val.isEmpty) {
//                                 return const SizedBox(width: 102, height: 50);
//                               } else if (val == 'back') {
//                                 return Container(
//                                   width: 102,
//                                   height: 50,
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 8),
//                                   child: IconButton(
//                                     onPressed: () =>
//                                         onKeyPress(val, walletController),
//                                     icon: const Icon(
//                                       Icons.backspace_outlined,
//                                       size: 28,
//                                       color: greyBillText,
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 return Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 8),
//                                   child: InkWell(
//                                     borderRadius: BorderRadius.circular(12),
//                                     onTap: () =>
//                                         onKeyPress(val, walletController),
//                                     child: Container(
//                                       width: 102,
//                                       height: 50,
//                                       decoration: BoxDecoration(
//                                         color: greyNumberBg,
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         val,
//                                         style: const TextStyle(
//                                           fontSize: 22,
//                                           fontWeight: FontWeight.w500,
//                                           color: white,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }
//                             }).toList(),
//                           ),
//                         ),
//                     ],
//                   ),

//                   const Spacer(),

//                   // Continue Button
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: isComplete
//                           ? () {
//                               navigate(
//                                 context: context,
//                                 page: WalletCreatePinComfirmScreen(),
//                               );
//                             }
//                           : null,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         disabledBackgroundColor:
//                             Colors.blue.withValues(alpha: 0.4),
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: const Text(
//                         "Continue",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
