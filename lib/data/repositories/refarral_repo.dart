import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';

class ReferralRepo {
  final ApiClient apiClient;
  const ReferralRepo({required this.apiClient});

  Future<Response> fetchReferral() async =>
      await apiClient.getData(AppConstants.getReferral, "fetchReferral");

  Future<Response> fetchReferralLevel() async => await apiClient.getData(
      AppConstants.getReferralLevels, "fetchReferralLevel");

  Future<Response> fetchReferralLevelDataByID({required int? levelId}) async =>
      await apiClient.getData(
          "${AppConstants.getReferralLevelsDataByID}/$levelId",
          "fetchReferralLevelDataByID");
}
