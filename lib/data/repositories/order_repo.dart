import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class OrderRepo {
  final ApiClient apiClient;
  const OrderRepo({required this.apiClient});

  Future<Response> postCheckout({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.postCheckOut,
        "postCheckout",
        data,
      );
  Future<Response> postPayOrderWalled(
          {required int? orderId, required FormData data}) async =>
      await apiClient.postData(
        "${AppConstants.postPayOrderWalled}/$orderId",
        "postPayOrderWalled",
        data,
      );

  Future<Response> fetchOrder() async => await apiClient.getData(
        AppConstants.getOrder,
        "fetchOrder",
      );
}
