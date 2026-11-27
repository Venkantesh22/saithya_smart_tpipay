import 'dart:developer';
import 'package:get/get.dart';
import 'package:lekra/services/extensions.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/constants.dart';
import '../api/api_client.dart';

class AuthRepo {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;
  AuthRepo({required this.sharedPreferences, required this.apiClient});

  Future<Response> generateOtp({required FormData data}) async =>
      await apiClient.postData(AppConstants.generateOtp, "generateOtp", data);

  Future<Response> generateEditOptSend({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postEditOptSend, "generateEditOptSend", data);

  Future<Response> generateResendOtp({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postResendVerifyOtp, "generateResendOtp", data);

  Future<Response> registerVerifyOtp({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postRegisterVerifyOtp, "registerVerifyOtp", data);

  Future<Response> postVerifyOTP({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postVerifyOTP, "postVerifyOTP", data);

  Future<Response> postUpdatePassword({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.postUpdatePassword, "postUpdatePassword", data);

  Future<Response> generateOtpFoUpdateMobileNo(
          {required FormData data}) async =>
      await apiClient.postData(AppConstants.postGenerateOtpFoUpdateMobileNo,
          "generateOtpFoUpdateMobileNo", data);

  Future<Response> verifyOtpFoUpdateMobileNo({required FormData data}) async =>
      await apiClient.postData(AppConstants.postVerifyOtpFoUpdateMobileNo,
          "verifyOtpFoUpdateMobileNo", data);

  Future<Response> fetchUserProfile() async =>
      await apiClient.getData(AppConstants.profileUri, "fetchUserProfile");

  Future<Response> postUserRegister({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.userRegisterUri,
        "postUserRegister",
        data,
      );

  Future<Response> postUserLogin({required FormData data}) async =>
      await apiClient.postData(
        AppConstants.loginUri,
        "postUserLogin",
        data,
      );
  Future<Response> postLogout() async =>
      await apiClient.postData(AppConstants.logoutUri, "postLogout", "");

  Future<Response> postDeleteAccount({required FormData data}) async =>
      await apiClient.postData(AppConstants.postDeleteAccount, "postDeleteAccount", data);

  Future<Response> postUpdateConsent({required FormData data}) async =>
      await apiClient.postData(AppConstants.postUpdateConsent, "postUpdateConsent", data);

  Future<Response> postUpdateProfile({required FormData data}) async =>
      await apiClient.postData(
          AppConstants.updateProfile, "postUpdateProfile", data);

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  String getUserId() {
    return sharedPreferences.getString(AppConstants.userId) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.token);
    sharedPreferences.remove(AppConstants.userId);
    apiClient.token = '';
    apiClient.updateHeader('');
    return true;
  }

  Future<String> getDeviceId() async {
    int count = 0;

    while (OneSignal.User.pushSubscription.id.isNotValid && count < 0) {
      await Future.delayed(const Duration(seconds: 1));
      count++;

      log(count.toString(), name: 'DeviceId Wait Count');
      log('${OneSignal.User.pushSubscription.id}', name: "12345678");
      log('${OneSignal.User.pushSubscription.token}', name: "12345678");
    }

    if (OneSignal.User.pushSubscription.id.isValid) {
      return OneSignal.User.pushSubscription.id!;
    } else {
      return '12345678';
    }
  }
}
