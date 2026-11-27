import 'package:get/get_connect/http/src/multipart/form_data.dart'
    show FormData;
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class DynamicQrRepo {
  final ApiClient apiClient;
  const DynamicQrRepo({required this.apiClient});

  Future<Response> postGenerateDynamicQR({required int? orderId}) async =>
      await apiClient.postData(
        "${AppConstants.postDynamicQR}/$orderId",
        "postGenerateDynamicQR",
        "",
      );

  Future<Response> checkPaymentStatus({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postPaymentStatus, "checkPaymentStatus", data);

  Future<Response> checkoutDynamicQRSubscriptionPayment(
          {required int? subscriptionID, required FormData data}) async =>
      await apiClient.postData(
        "${AppConstants.postDynamicQRSubscriptionPayment}/$subscriptionID",
        "checkoutDynamicQRSubscriptionPayment",
        data,
      );

  Future<Response> checkDynamicQRSubscriptionPaymentStatus(
          {required int? orderID}) async =>
      await apiClient.getData(
          "${AppConstants.getDynamicQRSubscriptionPaymentStatus}/$orderID",
          "checkDynamicQRSubscriptionPaymentStatus");

  Future<Response> fetchDynamicForMobileRecharge({
    required FormData data,
  }) async =>
      await apiClient.postData(
        AppConstants.postDynamicForMobileRecharge,
        "fetchMobileRechargePlan",
        data,
      );

      Future<Response> fetchDynamicQRForFund({
    required FormData data,
    
  }) async =>
      await apiClient.postData(
          AppConstants.postDynamicCreateQR,
          "fetchDynamicQRForFund",
          data);

  Future<Response> fetchDynamicQRStatusForFund({
    required FormData data,
    
  }) async =>
      await apiClient.postData(
          AppConstants.postDynamicQRStatus,
          "fetchDynamicQRForFund",
          data);
}
