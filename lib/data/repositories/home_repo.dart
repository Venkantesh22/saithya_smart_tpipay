import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class HomeRepo {
  final ApiClient apiClient;
  const HomeRepo({required this.apiClient});

  Future<Response> getCategory() async =>
      await apiClient.getData(AppConstants.categoryList, "getCategory");

  Future<Response> getFeaturedProducts({int page = 1}) async =>
      await apiClient.getData(
          "${AppConstants.getFeaturedProducts}?page=$page", "featuredProducts");

  Future<Response> fetchHotDealsTodayProducts() async =>
      await apiClient.getData(
          AppConstants.getHotDealsTodayProducts, "fetchHotDealsTodayProducts");

  Future<Response> fetchSearchProduct({required String query}) async =>
      await apiClient.getData(
          "${AppConstants.postSearchProduct}=$query", "fetchSearchProduct");
}
