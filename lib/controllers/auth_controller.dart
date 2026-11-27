import 'dart:developer';
import 'dart:io';
import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/user_model.dart';
import 'package:lekra/services/constants.dart';
import '../data/repositories/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool _acceptTerms = true;

  bool get isLoading => _isLoading;

  bool get acceptTerms => _acceptTerms;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();
  TextEditingController birthdayCodeController = TextEditingController();
  String? lastReceivedOtp;

  Future<ResponseModel> generateOtp({required String mobile}) async {
    log('----------- generateOtp Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      String cleanMobile = mobile.replaceAll(RegExp(r'\D'), '');
      if (cleanMobile.length > 10 && cleanMobile.startsWith('91')) {
        cleanMobile = cleanMobile.substring(cleanMobile.length - 10);
      }
      Map<String, dynamic> data = {
        "mobile": cleanMobile,
        "type": "forgot_password",
      };

      Response response = await authRepo.generateOtp(
        data: FormData(data),
      );

      log("Raw Response: ${response.body}");

      if (response.body is Map && response.body['status'] == true) {
        lastReceivedOtp = response.body['otp']?.toString() ??
            response.body['data']?['debug_otp']?.toString() ??
            response.body['data']?['otp']?.toString();
        responseModel = ResponseModel(
            true, response.body['message'] ?? "OTP sent successfully");
      } else {
        String msg = "Error while generating OTP";
        if (response.body is Map && response.body['message'] != null) {
          msg = response.body['message'];
        } else if (response.statusText != null && response.statusText!.isNotEmpty) {
          msg = response.statusText!;
        }
        responseModel = ResponseModel(false, msg);
      }
    } catch (e) {
      log('ERROR AT generateOtp(): $e');
      responseModel = ResponseModel(false, "Error while generating OTP: $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> generateEditOptSend({required String mobile}) async {
    log('----------- generateEditOptSend Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "mobile": mobile,
      };

      Response response = await authRepo.generateEditOptSend(
        data: FormData(data),
      );

      log("Raw Response: ${response.body}");

      if (response.body['status'] == true) {
        responseModel = ResponseModel(
            true, response.body['message'] ?? "generateEditOptSend updated");
      } else {
        responseModel = ResponseModel(false,
            response.body['error'] ?? "Error while generateEditOptSend user");
      }
    } catch (e) {
      log('ERROR AT generateEditOptSend(): $e');
      responseModel =
          ResponseModel(false, "Error while generateEditOptSend user $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> generateResendOtp({required String mobile}) async {
    log('----------- generateResendOtp Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "mobile": mobile,
      };

      Response response = await authRepo.generateResendOtp(
        data: FormData(data),
      );

      log("Raw Response: ${response.body}");

      if (response.body['status'] == true) {
        lastReceivedOtp = response.body['otp']?.toString() ??
            response.body['data']?['debug_otp']?.toString() ??
            response.body['data']?['otp']?.toString();
        responseModel = ResponseModel(
            true, response.body['message'] ?? "generateResendOtp updated");
      } else {
        responseModel = ResponseModel(false,
            response.body['error'] ?? "Error while generateResendOtp user");
      }
    } catch (e) {
      log('ERROR AT generateResendOtp(): $e');
      responseModel =
          ResponseModel(false, "Error while generateResendOtp user $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> postVerifyOTP(
      {required String mobile, required String otp}) async {
    log('----------- postVerifyOTP Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "mobile": mobile,
        "otp": otp,
      };

      Response response = await authRepo.postVerifyOTP(
        data: FormData(data),
      );

      log("Raw Response: ${response.body}");

      if (response.body['status'] == true) {
        responseModel = ResponseModel(
            true, response.body['message'] ?? "postVerifyOTP updated");
      } else {
        responseModel = ResponseModel(
            false, response.body['error'] ?? "Error while postVerifyOTP user");
      }
    } catch (e) {
      log('ERROR AT postVerifyOTP(): $e');
      responseModel = ResponseModel(false, "Error while postVerifyOTP user $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> registerUser({bool marketingConsent = false}) async {
    log('----------- registerUser Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "first_name": firstNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "referral_code": referralCodeController.text.trim(),
        "mobile": numberController.text.trim(),
        "terms_agreed": "1",
        "privacy_agreed": "1",
        "marketing_consent": marketingConsent ? "1" : "0",
      };

      Response response = await authRepo.postUserRegister(
        data: FormData(data),
      );

      log("Raw Response: ${response.body}");

      if (response.body != null && (response.body['status'] == true || response.body['success'] == true)) {
        var token = response.body['token'] ?? response.body['data']?['token'];
        if (token != null && token.toString().isNotEmpty) {
          authRepo.saveUserToken(token.toString());
        }

        var userData = response.body['user'] ?? response.body['data']?['user'];
        var otpRequired = response.body['otp_required'] ?? response.body['data']?['otp_required'];

        if (userData != null) {
          var verifiedVal = userData['is_verified'];
          isPhoneNumberVerified = (verifiedVal == 1 || verifiedVal == true || verifiedVal == '1');
          userPhoneNumber = userData['mobile']?.toString();
        } else if (otpRequired == false && token != null) {
          isPhoneNumberVerified = true;
        } else if (otpRequired == true) {
          isPhoneNumberVerified = false;
        } else if (token != null) {
          isPhoneNumberVerified = true;
        } else {
          isPhoneNumberVerified = false;
        }

        userPhoneNumber ??= numberController.text.trim();

        responseModel = ResponseModel(
            true, response.body['message'] ?? "Registration successful");
        firstNameController.clear();
        lastNameController.clear();
        emailController.clear();
        passwordController.clear();
        referralCodeController.clear();
      } else {
        responseModel = ResponseModel(
            false, response.body?['message'] ?? "Error while registering user");
      }
    } catch (e) {
      log('ERROR AT registerUser(): $e');
      responseModel = ResponseModel(false, "Error while registering user $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  bool isPhoneNumberVerified = false;
  String? userPhoneNumber;
  Future<ResponseModel> userLogin({required bool isEmail}) async {
    log('----------- userLogin Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "email": isEmail ? emailController.text.trim() : "",
        "mobile": isEmail ? "" : emailController.text.trim(),
        "password": passwordController.text.trim(),
      };

      Response response = await authRepo.postUserLogin(data: FormData(data));

      log("Raw Response: ${response.body}");

      if (response.body != null && response.body['status'] == true) {
        var token = response.body['token'] ?? response.body['data']?['token'];
        if (token != null && token.toString().isNotEmpty) {
          authRepo.saveUserToken(token.toString());
        }

        var userData = response.body['user'] ?? response.body['data']?['user'];
        var otpRequired = response.body['otp_required'] ?? response.body['data']?['otp_required'];

        if (userData != null) {
          var verifiedVal = userData['is_verified'];
          isPhoneNumberVerified = (verifiedVal == 1 || verifiedVal == true || verifiedVal == '1');
          userPhoneNumber = userData['mobile']?.toString();
        }

        if (otpRequired == true) {
          isPhoneNumberVerified = false;
        } else if (token != null && token.toString().isNotEmpty) {
          isPhoneNumberVerified = true;
        }

        if (userPhoneNumber == null || userPhoneNumber!.isEmpty) {
          userPhoneNumber = emailController.text.trim();
        }
        numberController.text = userPhoneNumber ?? '';

        log("isPhoneNumberVerified: $isPhoneNumberVerified");
        log("userPhoneNumber: $userPhoneNumber");

        responseModel =
            ResponseModel(true, response.body['message'] ?? "Login successful");
      } else {
        responseModel = ResponseModel(
            false, response.body?['message'] ?? "Error while login user");
      }
    } catch (e) {
      log('ERROR AT userLogin(): $e');
      responseModel = ResponseModel(false, "Error while login user $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> registerVerifyOtp({required String otp, String? phone}) async {
    log('----------- registerVerifyOtp Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      String mobileNumber = (phone != null && phone.trim().isNotEmpty)
          ? phone.trim()
          : (numberController.text.trim().isNotEmpty
              ? numberController.text.trim()
              : (userPhoneNumber ?? emailController.text.trim()));

      Map<String, dynamic> data = {
        "otp": otp,
        "mobile": mobileNumber,
      };

      Response response =
          await authRepo.registerVerifyOtp(data: FormData(data));

      log("Raw registerVerifyOtp Response: ${response.body}");

      if (response.body != null && (response.body['status'] == true || response.body['success'] == true)) {
        var token = response.body['token'] ?? response.body['data']?['token'];
        if (token != null && token.toString().isNotEmpty) {
          authRepo.saveUserToken(token.toString());
          isPhoneNumberVerified = true;
        }
        responseModel = ResponseModel(
            true, response.body['message'] ?? "Verification successful");
      } else {
        responseModel = ResponseModel(
            false, response.body?['message'] ?? "Error while registerVerifyOtp");
      }
    } catch (e) {
      log('ERROR AT registerVerifyOtp(): $e');
      responseModel = ResponseModel(false, "Error while registerVerifyOtp  $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> logout() async {
    log('----------- logout Called ----------');

    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Response response = await authRepo.postLogout();

      if (response.statusCode == 200) {
        responseModel =
            ResponseModel(true, response.body['message'] ?? "logout ");
        await authRepo.sharedPreferences.remove(AppConstants.token);
        userModel = null;
        firstNameController.clear();
        lastNameController.clear();
        emailController.clear();
        passwordController.clear();
        referralCodeController.clear();
      } else {
        responseModel = ResponseModel(
            false, response.body['error'] ?? "Error while logout");
      }
    } catch (e) {
      log("****** Error in logout() ******", name: "logout");
      responseModel = ResponseModel(false, "Error while  logout $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> deleteAccount({String? pin, String? password, String? reason}) async {
    log('----------- deleteAccount Called ----------');
    _isLoading = true;
    update();
    ResponseModel responseModel;
    try {
      Map<String, dynamic> data = {
        if (pin != null && pin.isNotEmpty) "pin": pin,
        if (password != null && password.isNotEmpty) "password": password,
        if (reason != null && reason.isNotEmpty) "reason": reason,
      };

      Response response = await authRepo.postDeleteAccount(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == true) {
        responseModel = ResponseModel(
            true, response.body['message'] ?? "Account deleted successfully");
        await authRepo.sharedPreferences.remove(AppConstants.token);
        userModel = null;
        firstNameController.clear();
        lastNameController.clear();
        emailController.clear();
        passwordController.clear();
        numberController.clear();
      } else {
        responseModel = ResponseModel(
            false,
            response.body['message'] ??
                response.body['error'] ??
                "Failed to delete account");
      }
    } catch (e) {
      log("****** Error in deleteAccount() ****** $e", name: "deleteAccount");
      responseModel = ResponseModel(false, "Error while deleting account: $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> updateMarketingConsent(bool consent) async {
    log('----------- updateMarketingConsent Called: $consent ----------');
    ResponseModel responseModel;
    try {
      Map<String, dynamic> data = {
        "marketing_consent": consent ? "1" : "0",
      };

      Response response = await authRepo.postUpdateConsent(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == true) {
        if (userModel != null) {
          userModel = UserModel(
            id: userModel!.id,
            firstName: userModel!.firstName,
            lastName: userModel!.lastName,
            gender: userModel!.gender,
            isVerified: userModel!.isVerified,
            image: userModel!.image,
            email: userModel!.email,
            mobile: userModel!.mobile,
            referralCode: userModel!.referralCode,
            createdAt: userModel!.createdAt,
            updatedAt: userModel!.updatedAt,
            dob: userModel!.dob,
            currentWallet: userModel!.currentWallet,
            mainWallet: userModel!.mainWallet,
            cashbackWallet: userModel!.cashbackWallet,
            shoppingWallet: userModel!.shoppingWallet,
            rechargeWallet: userModel!.rechargeWallet,
            referralLink: userModel!.referralLink,
            rewardPoint: userModel!.rewardPoint,
            referralLinks: userModel!.referralLinks,
            subscription: userModel!.subscription,
            referredLevel: userModel!.referredLevel,
            walletPinSet: userModel!.walletPinSet,
            marketingConsent: consent,
          );
          update();
        }

        responseModel = ResponseModel(
            true,
            response.body['message'] ??
                (consent
                    ? "Marketing consent enabled. You will receive promotional updates."
                    : "Marketing consent withdrawn. You will not receive promotional messages."));
      } else {
        responseModel = ResponseModel(
            false, response.body['message'] ?? "Failed to update consent preferences");
      }
    } catch (e) {
      log("****** Error in updateMarketingConsent() ****** $e",
          name: "updateMarketingConsent");
      responseModel = ResponseModel(false, "Error: $e");
    }
    return responseModel;
  }

  UserModel? userModel;
  Future<ResponseModel> fetchUserProfile() async {
    log('-----------  fetchUserProfile() -------------');
    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      Response response = await authRepo.fetchUserProfile();

      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['data'] is Map) {
        responseModel =
            ResponseModel(true, response.body['message'] ?? "fetchUserProfile");
        userModel = UserModel.fromJson(response.body["data"]);
        lastNameController.text = userModel?.lastName ?? "";
        firstNameController.text = userModel?.firstName ?? "";
        emailController.text = userModel?.email ?? "";
        numberController.text = userModel?.mobile ?? "";
        birthdayCodeController.text = userModel?.dobFormat ?? "";
        setGender(value: userModel?.gender ?? "");
      } else {
        log("raw datat");
        responseModel = ResponseModel(
            false, response.body['error'] ?? "Something Went Wrong");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchUserProfile");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  File? profileImage;

  void updateImages(File? image) {
    profileImage = image;
    update();
  }

  bool updateProfileLoading = false;

  Future<ResponseModel> updateProfile() async {
    log('----------- updateProfile Called ----------');
    updateProfileLoading = true;
    update();
    ResponseModel responseModel;

    try {
      Map<String, dynamic> data = {
        "first_name": firstNameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "email": emailController.text.trim(),
        'dob': birthdayCodeController.text.trim(),
        'gender': gender,
      };
      if (profileImage != null) {
        String fileName = profileImage!.path.split(RegExp(r'[\\/]')).last;
        if (fileName.isEmpty) {
          fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        }
        String ext = fileName.contains('.') ? fileName.split('.').last.toLowerCase() : 'jpg';
        String mimeType = 'image/jpeg';
        if (ext == 'png') mimeType = 'image/png';
        if (ext == 'webp') mimeType = 'image/webp';
        if (ext == 'gif') mimeType = 'image/gif';

        data.addAll({
          "image": MultipartFile(
            profileImage!.readAsBytesSync(),
            filename: fileName,
            contentType: mimeType,
          )
        });
      }

      Response response =
          await authRepo.postUpdateProfile(data: FormData(data));

      if (response.statusCode == 200 && (response.body is! Map || response.body['status'] != false)) {
        fetchUserProfile();

        responseModel = ResponseModel(
            true, response.body is Map ? (response.body['message'] ?? "Profile updated successfully") : "Profile updated successfully");
      } else {
        String errorMsg = "Error while updating profile";
        if (response.body is Map) {
          if (response.body['message'] != null && response.body['message'].toString().isNotEmpty) {
            errorMsg = response.body['message'].toString();
          } else if (response.body['error'] != null && response.body['error'].toString().isNotEmpty) {
            errorMsg = response.body['error'].toString();
          } else if (response.body['errors'] != null) {
            final errs = response.body['errors'];
            if (errs is Map && errs.isNotEmpty) {
              final first = errs.values.first;
              errorMsg = first is List && first.isNotEmpty ? first.first.toString() : first.toString();
            }
          }
        } else if (response.statusText != null &&
            response.statusText!.isNotEmpty &&
            !response.statusText!.contains('{')) {
          errorMsg = response.statusText!;
        }
        responseModel = ResponseModel(false, errorMsg);
      }
    } catch (e) {
      log("****** Error in updateProfile() ******", name: "updateProfile");
      responseModel = ResponseModel(false, "Error while updating profile $e");
    }

    updateProfileLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> updatePassword() async {
    log('----------- updatePassword Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "password": passwordController.text.trim(),
        "password_confirmation": confirmPasswordController.text.trim(),
        "mobile": numberController.text.trim(),
      };

      Response response = await authRepo.postUpdatePassword(
        data: FormData(data),
      );

      log("Raw Response: ${response.body}");

      if (response.statusCode == 200 && response.body['status'] == true) {
        responseModel = ResponseModel(
            true, response.body['message'] ?? "updatePassword updated");
        numberController.clear();
        emailController.clear();
        passwordController.clear();
      } else {
        responseModel = ResponseModel(
            false, response.body['message'] ?? "Error while updatePassword ");
      }
    } catch (e) {
      log('ERROR AT updatePassword(): $e');
      responseModel = ResponseModel(false, "Error while updatePassword  $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  String? gender;

  List<String>? genderList = [
    "Male",
    "Female",
    "Other",
  ];

  void setGender({required String value}) {
    gender = value;
    update();
  }

  Future<ResponseModel> generateOtpFoUpdateMobileNo(
      {required String mobile}) async {
    log('----------- generateOtpFoUpdateMobileNo Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "mobile": mobile,
      };

      Response response = await authRepo.generateOtpFoUpdateMobileNo(
        data: FormData(data),
      );

      if (response.body['status'] == true) {
        responseModel = ResponseModel(true,
            response.body['message'] ?? "generateOtpFoUpdateMobileNo updated");
      } else {
        responseModel = ResponseModel(
            false,
            response.body['error'] ??
                "Error while generateOtpFoUpdateMobileNo user");
      }
    } catch (e) {
      log('ERROR AT generateOtpFoUpdateMobileNo(): $e');
      responseModel = ResponseModel(
          false, "Error while generateOtpFoUpdateMobileNo user $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyOtpFoUpdateMobileNo({required String otp}) async {
    log('----------- verifyOtpFoUpdateMobileNo Called ----------');

    ResponseModel responseModel;
    _isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "otp": otp,
        "mobile": numberController.text.trim(),
      };

      Response response =
          await authRepo.verifyOtpFoUpdateMobileNo(data: FormData(data));

      if (response.body['status'] == true || response.body['success'] == true) {
        responseModel = ResponseModel(true,
            response.body['message'] ?? "verifyOtpFoUpdateMobileNo successful");
      } else {
        responseModel = ResponseModel(
            false,
            response.body['message'] ??
                "Error while verifyOtpFoUpdateMobileNo");
      }
    } catch (e) {
      log('ERROR AT verifyOtpFoUpdateMobileNo(): $e');
      responseModel =
          ResponseModel(false, "Error while verifyOtpFoUpdateMobileNo  $e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> checkReferral() async {
    try {
      ReferrerDetails referrerDetails =
          await AndroidPlayInstallReferrer.installReferrer;
      String? referrerString = referrerDetails.installReferrer;

      if (referrerString != null && referrerString.isNotEmpty) {
        String? finalCode = _extractCode(referrerString);
        if (finalCode != null && finalCode.isNotEmpty) {
          debugPrint("Successfully found referral code: $finalCode");
          referralCodeController.text = finalCode;
          update();
        } else {
          debugPrint("No referral code in referrer: $referrerString");
        }
      }
    } catch (e) {
      debugPrint("Failed to get referrer: $e");
    }
  }

  // Helper method to extract the code from the Play Store referrer string
  String? _extractCode(String rawString) {
    if (rawString.isEmpty) return null;

    String decoded = rawString;
    try {
      decoded = Uri.decodeComponent(rawString);
    } catch (_) {}

    Map<String, String> queryParams = {};

    if (decoded.contains('?')) {
      try {
        queryParams = Uri.parse(decoded).queryParameters;
      } catch (_) {}
    }

    if (queryParams.isEmpty && decoded.contains('=')) {
      try {
        queryParams = Uri.splitQueryString(decoded);
      } catch (_) {}
    }

    // Check specific known referral query parameters
    const candidateKeys = [
      'ref',
      'referral',
      'referral_code',
      'referralCode',
      'code',
      'referrer',
      'invited_by',
    ];

    for (final key in candidateKeys) {
      if (queryParams.containsKey(key)) {
        final val = queryParams[key]?.trim();
        if (val != null && _isValidReferralCode(val)) {
          return val;
        }
      }
    }

    // Also check if any query parameter value itself has 'referrer=' or candidate keys
    if (queryParams.containsKey('referrer')) {
      final inner = queryParams['referrer'];
      if (inner != null && inner != decoded) {
        final nested = _extractCode(inner);
        if (nested != null) return nested;
      }
    }

    // Check if the raw string itself is a clean referral code
    final cleaned = decoded.trim();
    if (_isValidReferralCode(cleaned)) {
      return cleaned;
    }

    return null;
  }

  bool _isValidReferralCode(String code) {
    if (code.isEmpty) return false;

    final lower = code.toLowerCase();
    // Reject tracking/analytics parameters from Play Store or ad networks
    if (lower.contains('utm_') ||
        lower.contains('google-play') ||
        lower.contains('organic') ||
        lower.contains('(not set)') ||
        lower.contains('not%20set') ||
        lower.contains('play.google.com') ||
        lower.contains('http') ||
        lower.contains('=') ||
        lower.contains('&') ||
        lower.contains('?')) {
      return false;
    }

    // Referral code should be alphanumeric between 3 and 25 characters
    final regex = RegExp(r'^[a-zA-Z0-9_-]{3,25}$');
    return regex.hasMatch(code);
  }

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }
}
