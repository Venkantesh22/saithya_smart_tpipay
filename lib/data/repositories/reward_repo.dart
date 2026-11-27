import 'package:get/get.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class RewardRepo {
  final ApiClient apiClient;
  const RewardRepo({required this.apiClient});

  Future<Response> fetchScratchCard() async => await apiClient.getData(
      AppConstants.fetchScratchCard, "fetchScratchCard");

  Future<Response> postScratchCardRedeem({required int? scratchId}) async =>
      await apiClient.postData(
          "${AppConstants.postScratchCardRedeem}$scratchId/redeem",
          "fetchScratchCard",
          "");

  Future<Response> fetchRewardsWallerHistory() async => await apiClient.getData(
      AppConstants.getRewardsWallerHistory, "fetchRewardsWallerHistory");

  Future<Response> fetchSpinWheel() async =>
      await apiClient.getData(AppConstants.getSpinWheel, "getSpinWheel");

  Future<Response> postCreateScratchCard({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postCreateScratchCard, "postCreateScratchCard", data);

  Future<Response> postConvertPoints({required int points}) async =>
      await apiClient.postData(
          AppConstants.convertRewardPoints,
          "postConvertPoints",
          {'points': points});
}
