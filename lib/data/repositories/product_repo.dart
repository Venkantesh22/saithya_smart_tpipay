import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class ProductRepo {
  final ApiClient apiClient;
  const ProductRepo({required this.apiClient});

  Future<Response> fetchCategoryDetails({
    required int? categoryId,
    int? page = 1,
    bool lowToHight = false,
    bool hightToLow = false,
  }) async =>
      await apiClient.getData(
          "${AppConstants.getCategoryDetails}/$categoryId?page=$page&sort=${lowToHight ? "low_high" : hightToLow ? "high_low" : null}",
          "fetchCategoryDetails");

  Future<Response> fetchProductDetails({required int? productId}) async =>
      await apiClient.getData("${AppConstants.getProductDetails}/$productId",
          "fetchProductDetails");

  Future<Response> postAddToCard(
          {required FormData data, required int? productId}) async =>
      await apiClient.postData(
        "${AppConstants.postAddToCard}/$productId",
        "postAddToCard",
        data,
      );

  Future<Response> postRemoveToCard({required int? productId}) async =>
      await apiClient.postData(
        AppConstants.postRemoveToCard,
        "postRemoveToCard",
        {"product_id": productId ?? ""},
      );

  Future<Response> fetchCard({required FormData data}) async =>
      await apiClient.postData(AppConstants.getCard, "fetchCard", data);
}
