import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class FundRequestRepo {
  final ApiClient apiClient;
  FundRequestRepo({required this.apiClient});

  Future<Response> getAssignBank() async =>
      await apiClient.getData(AppConstants.getAssignBank, "getAssignBank");

  Future<Response> postFundRequest({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postFundRequests, "getAssignBank", data);

  Future<Response> fetchFundStatus() async => await apiClient.getData(
        AppConstants.getFundStatus,
        "fetchFundStatus",
      );

  Future<Response> fetchFundDetails({required int? id}) async =>
      await apiClient.getData(
        "${AppConstants.getFundDetails}/$id/deatils",
        "fetchFundDetails",
      );

  Future<Response> createUPIQR({required FormData data}) async =>
      await apiClient.postData(AppConstants.postCreateQR, "createUPIQR", data);

  Future<Response> uPIQRStatus({
    required FormData data,
    required int? gatewayOrderId,
  }) async =>
      await apiClient.postData(
          "${AppConstants.postCreateQRStatus}/$gatewayOrderId",
          "uPIQRStatus",
          data);

  
}
