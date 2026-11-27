import 'package:get/get.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class SubscriptionRepo {
  final ApiClient apiClient;
  SubscriptionRepo({required this.apiClient});

  Future<Response> fetchSubscriptionCategoryPlan() async => await apiClient
      .getData(AppConstants.getSubscription, "fetchSubscriptionCategoryPlan");

  Future<Response> fetchSubscriptionPlanById({required int? id}) async =>
      await apiClient.getData("${AppConstants.getSubscriptionById}/$id",
          "fetchSubscriptionPlanById");

  Future<Response> fetchSubscriptionPlanDetails({required int? id}) async =>
      await apiClient.getData("${AppConstants.getSubscriptionDetails}/$id",
          "fetchSubscriptionPlan");

  Future<Response> subscriptionCheckout(
          {required int? id, required FormData data}) async =>
      await apiClient.postData(
          "${AppConstants.getSubscriptionCheckout}/$id/checkout",
          "subscriptionCheckout",
          data);

  Future<Response> fetchSubscriptionHistory() async => await apiClient.getData(
      AppConstants.getSubscriptionHistory, "fetchSubscriptionHistory");
}
