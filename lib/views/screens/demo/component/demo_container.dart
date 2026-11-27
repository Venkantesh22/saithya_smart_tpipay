import 'package:flutter/material.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class DemoContainer extends StatelessWidget {
  final DemoContainerModel demoContainerModel;
  const DemoContainer({super.key, required this.demoContainerModel});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: mediaQuery * 0.1,
          ),
          CustomImage(
            path: demoContainerModel.image,
            height: mediaQuery * 0.4,
            width: double.infinity,
          ),
          Text(
            demoContainerModel.title,
            style: Helper(context).textTheme.titleMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            demoContainerModel.subTitle,
            style: Helper(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14, fontWeight: FontWeight.w400, color: greyNumberBg),
          ),
          SizedBox(
            height: mediaQuery * 0.06,
          ),
          Center(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shrinkWrap: true,
              itemCount: demoContainerModel.demoScreenList.length,
              separatorBuilder: (_, __) => const SizedBox(
                height: 25,
              ),
              itemBuilder: (context, index) {
                final rowData = demoContainerModel.demoScreenList[index];
                return Row(
                  children: [
                    CustomImage(
                      path: rowData.image,
                      height: 40,
                      width: 40,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 20),
                    Text(
                      rowData.title,
                      style: Helper(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class DemoContainerModel {
  final String image;
  final String title;
  final String subTitle;
  final List<DemoRowContext> demoScreenList;

  DemoContainerModel({
    required this.title,
    required this.subTitle,
    required this.image,
    required this.demoScreenList,
  });
}

DemoContainerModel demoPage1 = DemoContainerModel(
    title: "Welcome to ${AppConstants.appName}",
    subTitle: "Trusted ecommerce & wallet platform for India",
    image: Assets.imagesDemo1,
    demoScreenList: demoScreen1);

DemoContainerModel demoPage2 = DemoContainerModel(
    title: "Wallet & Transactions",
    subTitle: "Manage your money safely",
    image: Assets.imagesDemo2,
    demoScreenList: demoScreen2);

DemoContainerModel demoPage3 = DemoContainerModel(
    title: "Shop Products",
    subTitle: "Buy products using your wallet",
    image: Assets.imagesDemo3,
    demoScreenList: demoScreen3);

class DemoRowContext {
  final String image;
  final String title;

  DemoRowContext({required this.image, required this.title});
}

List<DemoRowContext> demoScreen1 = [
  DemoRowContext(
      image: Assets.imagesHomeDemo, title: "Trusted Indian E-commerce"),
  DemoRowContext(image: Assets.imagesWallet, title: "Secure Wallet & Payments"),
  DemoRowContext(image: Assets.imagesShopDome, title: "Easy & Fast Shopping"),
];

List<DemoRowContext> demoScreen2 = [
  DemoRowContext(image: Assets.imagesDollerDemo, title: "Add Money Easily"),
  DemoRowContext(
      image: Assets.imagesSearchDemo, title: "Secure Wallet Balance"),
  DemoRowContext(image: Assets.imagesFastDemo, title: "Fast Transaction"),
];

List<DemoRowContext> demoScreen3 = [
  DemoRowContext(
      image: Assets.imagesSearchDemo, title: "Browse & Buy Products"),
  DemoRowContext(image: Assets.imagesWallet, title: "Pay Using Wallet"),
  DemoRowContext(image: Assets.imagesDelivery, title: "Fast Delivery"),
];
