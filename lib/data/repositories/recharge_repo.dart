import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class RechargeRepo {
  final ApiClient apiClient;

  RechargeRepo({required this.apiClient});

  Future<Response> mobileRecharge({required FormData? data}) async =>
      await apiClient.postData(
        AppConstants.postRecharge,
        "mobileRecharge",
        data,
      );

  Future<Response> fetchMobileRechargePlan({
    required String? operatorCode,
    required int? circleCode,
  }) async =>
      await apiClient.getData(
        "${AppConstants.getRechargePlane}?operator_code=$operatorCode&circle_code=$circleCode",
        "fetchMobileRechargePlan",
      );
}
