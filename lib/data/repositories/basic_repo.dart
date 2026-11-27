import 'dart:developer';

import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lekra/data/api/api_client.dart';
import 'package:lekra/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasicRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  const BasicRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> getBanner() async =>
      await apiClient.getData(AppConstants.bannerUri, "getBanner");

  Future<Response> fetchAddress() async =>
      await apiClient.getData(AppConstants.getAddress, "fetchAddress");

  Future<Response> addAddress({required FormData data}) async => await apiClient
      .postData(AppConstants.postAddAddress, "postAddAddress", data);

  Future<Response> updateAddress({required int addressId, required dynamic data}) async =>
      await apiClient.postData(
          "/api/address/update/$addressId", "updateAddress", data);

  Future<Response> deletesAddress({required int? addressId}) async =>
      await apiClient.postData(
          "${AppConstants.postDeleteAddress}/$addressId", "deletesAddress", "");

  Future<Response> fetchAddressById({required int? addressId}) async =>
      await apiClient.getData(
          "${AppConstants.getAddressById}/$addressId", "fetchAddressById");

  Future<Response> fetchPrivacyPolicy() async => await apiClient.getData(
      AppConstants.getPrivacyPolicy, "fetchPrivacyPolicy");

  Future<Response> fetchTermsConditions() async => await apiClient.getData(
      AppConstants.getTermsConditions, "fetchTermsConditions");

  Future<Response> fetchRefundPolicy() async => await apiClient.getData(
      AppConstants.getRefundPolicy, "fetchRefundPolicy");

  Future<Response> fetchShippingPolicy() async => await apiClient.getData(
      AppConstants.getShippingPolicy, "fetchShippingPolicy");

  Future<Response> fetchGrievanceOfficer() async => await apiClient.getData(
      AppConstants.getGrievanceOfficer, "fetchGrievanceOfficer");

  Future<Response> fetchSupport() async =>
      await apiClient.getData(AppConstants.getSupport, "fetchSupport");

  Future<bool> saveIsDemoShow(
    bool value,
  ) async {
    try {
      return await sharedPreferences.setBool(AppConstants.isDemoShowKey, value);
    } catch (e, st) {
      log('saveUserToken error: $e\n$st');
      return false;
    }
  }
}
