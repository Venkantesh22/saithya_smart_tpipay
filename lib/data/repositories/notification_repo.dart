import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class NotificationRepo {
  final ApiClient apiClient;
  const NotificationRepo({required this.apiClient});

  Future<Response> fetchNotifications() async =>
      await apiClient.getData(AppConstants.getNotifications, "fetchNotifications");

  Future<Response> fetchMarketingPromotions() async =>
      await apiClient.getData(AppConstants.getMarketingPromotions, "fetchMarketingPromotions");
}
