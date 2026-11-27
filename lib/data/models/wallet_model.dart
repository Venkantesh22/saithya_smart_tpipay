import 'package:lekra/services/constants.dart';

class WalletModel {
  final String? wallet;
  final String? mainWallet;
  final String? cashbackWallet;
  final String? shoppingWallet;
  final String? rechargeWallet;

  WalletModel({
    this.wallet,
    this.mainWallet,
    this.cashbackWallet,
    this.shoppingWallet,
    this.rechargeWallet,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        wallet: (json["wallet"] ?? json["balance"] ?? "0.00").toString(),
        mainWallet: (json["main_wallet"] ?? json["wallet"] ?? json["balance"] ?? "0.00").toString(),
        cashbackWallet: (json["cashback_wallet"] ?? json["gift_balance"] ?? "0.00").toString(),
        shoppingWallet: (json["shopping_wallet"] ?? json["shopping_balance"] ?? "0.00").toString(),
        rechargeWallet: (json["recharge_wallet"] ?? json["recharge_balance"] ?? "0.00").toString(),
      );

  Map<String, dynamic> toJson() => {
        "wallet": wallet,
        "main_wallet": mainWallet,
        "cashback_wallet": cashbackWallet,
        "shopping_wallet": shoppingWallet,
        "recharge_wallet": rechargeWallet,
      };

  String get walletBalance => PriceConverter.convertToNumberFormat(
      double.tryParse(mainWallet ?? wallet ?? "") ?? 0.0);

  String get cashbackBalance => PriceConverter.convertToNumberFormat(
      double.tryParse(cashbackWallet ?? "") ?? 0.0);

  String get shoppingBalance => PriceConverter.convertToNumberFormat(
      double.tryParse(shoppingWallet ?? "") ?? 0.0);

  String get rechargeBalance => PriceConverter.convertToNumberFormat(
      double.tryParse(rechargeWallet ?? "") ?? 0.0);

  double get shoppingBalanceNum => double.tryParse(shoppingWallet ?? "0") ?? 0.0;
  double get rechargeBalanceNum => double.tryParse(rechargeWallet ?? "0") ?? 0.0;
  double get mainBalanceNum => double.tryParse(mainWallet ?? wallet ?? "0") ?? 0.0;
  double get cashbackBalanceNum => double.tryParse(cashbackWallet ?? "0") ?? 0.0;
}
