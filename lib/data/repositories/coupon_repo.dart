import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class CouponRepo {
  final ApiClient apiClient;
  CouponRepo({required this.apiClient});

  Future<Response> postCouponCode({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postCheckCouponCode, "postCouponCode", data);

  Future<Response> fetchCoupons() async =>
      await apiClient.getData("api/coupons", "fetchCoupons");
}
