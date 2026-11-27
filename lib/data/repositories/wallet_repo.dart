import 'package:get/get.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class WallerRepo {
  final ApiClient apiClient;
  WallerRepo({required this.apiClient});

  Future<Response> fetchWalletTransaction({int page = 1}) async =>
      await apiClient.getData("${AppConstants.getWalletTransaction}?page=$page",
          "fetchWalletTransaction");
  Future<Response> fetchWalletTransactionByDate(
          {required String date, int page = 1}) async =>
      await apiClient.getData(
          "${AppConstants.getWalletTransactionByDate}?date=$date?page=$page",
          "fetchWalletTransactionByDate");

  Future<Response> fetchWalletTransactionByAmount(
          {required String amount, int page = 1}) async =>
      await apiClient.getData(
          "${AppConstants.getWalletTransactionByAmount}?amount=$amount?page=$page",
          "fetchWalletTransactionByAmount");

  Future<Response> fetchWallet() async =>
      await apiClient.getData(AppConstants.getWallet, "fetchWallet");

  Future<Response> createWalletPin({required FormData data}) async =>
      await apiClient.postData(AppConstants.postWalletPin, "fetchWallet", data);

  Future<Response> verifyWalletPin({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postVerifyPin, "verifyWalletPin", data);

  Future<Response> postWalletReSetPin({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postWalletPinRest, "postWalletReSetPin", data);

  Future<Response> transferWalletBalance({required Map<String, dynamic> data}) async =>
      await apiClient.postData(
          "/api/wallet/transfer", "transferWalletBalance", data);
}
