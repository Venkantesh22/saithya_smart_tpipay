import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lekra/main.dart';
import 'package:lekra/services/route_helper.dart';
import 'package:lekra/services/theme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:toastification/toastification.dart';

class PriceConverter {
  static convert(price) {
    return '₹ ${double.parse('$price').toStringAsFixed(2)}';
  }

  static convertRound(price) {
    return '₹ ${double.parse('$price').toInt()}';
  }

  static convertToNumberFormat(num price) {
    final format = NumberFormat("#,##,##,##0.00", "en_IN");
    return '₹ ${format.format(price)}';
  }
}


Widget sizedBoxHeight({required double height}) {
  return SizedBox(
    height: height,
  );
}

Widget sizedBoxWidth({required double width}) {
  return SizedBox(
    width: width,
  );
}

class Helper {
  final BuildContext context;
  Helper(this.context);

  Size get size => MediaQuery.sizeOf(context);
  TextTheme get textTheme => Theme.of(context).textTheme;
}

String capitalize(String? s) {
  if (s == null || s.isEmpty) return "";
  return s[0].toUpperCase() + s.substring(1);
}

void navigate({
  PageTransitionType type = PageTransitionType.fade,
  required BuildContext context,
  required Widget page,
  bool isReplace = false,
  bool isRemoveUntil = false,
  Duration duration = const Duration(milliseconds: 300),
}) {
  if (isReplace) {
    Navigator.of(context).pushReplacement(
      getCustomRoute(
        child: page,
        type: type,
        duration: duration,
      ),
    );
  } else if (isRemoveUntil) {
    Navigator.of(context).pushAndRemoveUntil(
      getCustomRoute(
        child: page,
        type: type,
        duration: duration,
      ),
      (route) => false,
    );
  } else {
    Navigator.of(context).push(
      getCustomRoute(
        child: page,
        type: type,
        duration: duration,
      ),
    );
  }
}

void pop(BuildContext context, {dynamic data}) {
  Navigator.pop(context, data);
}

enum ToastType {
  info(ToastificationType.info),
  warning(ToastificationType.warning),
  error(ToastificationType.error),
  success(ToastificationType.success);

  const ToastType(this.value);
  final ToastificationType value;
}

void showToast(
    {ToastType? toastType,
    required String message,
    String? description,
    ToastificationStyle? toastificationStyle,
    bool? typeCheck}) {
  toastification.show(
    alignment: Alignment.topLeft,
    type: toastType?.value ??
        ((typeCheck ?? false)
            ? ToastificationType.success
            : ToastificationType.error),
    title: Text(
      message,
      style:
          Helper(navigatorKey.currentContext!).textTheme.bodyMedium!.copyWith(
                color: black,
                fontSize: 14,
              ),
    ),
    description: description != null
        ? Text(description,
            style: Helper(navigatorKey.currentContext!)
                .textTheme
                .bodySmall!
                .copyWith(
                  color: black,
                ))
        : null,
    style: toastificationStyle ?? ToastificationStyle.minimal,
    icon: toastType == ToastType.success
        ? const Icon(Icons.check_circle_outline)
        : toastType == ToastType.error
            ? const Icon(Icons.error_outline)
            : toastType == ToastType.warning
                ? const Icon(Icons.warning_amber)
                : const Icon(Icons.info_outline),
    autoCloseDuration: const Duration(seconds: 2),
  );
}

String getStringFromList(List<dynamic>? data) {
  String str = data.toString();
  return data.toString().substring(1, str.length - 1);
}

class AppConstants {
  String get getBaseUrl => baseUrl;
  set setBaseUrl(String url) => baseUrl = url;
//http://ecom.tpipaygroup.com/api/register-user
  //TODO: Change Base Url
  static String baseUrl = 'https://sathiyasmart.com/';
  //TODO: Change Base Url
  static String appName = 'Sathiya Smart';
  static String payAppName = 'Sathiya Pay';

  static String googlePlayStoreLink =
      'https://play.google.com/store/apps/details?id=com.tpipay.trustindia';
      

  //OTP
  static const String generateOtp = 'api/send-otp';
  static const String postVerifyOTP = 'api/verify-otp';

  // Auth
  static const String userRegisterUri = 'api/register-user';
  static const String loginUri = 'api/login-post';
  static const String logoutUri = 'api/logout';
  static const String profileUri = 'api/profile';
  static const String postUpdatePassword = 'api/update-password';
  static const String postRegisterVerifyOtp = 'api/register-verify-otp';
  static const String postResendVerifyOtp = 'api/resend-otp';

//Edit Profile
  static const String postEditOptSend = 'api/edit-otp-send';
  static const String updateProfile = 'api/edit-profile';
  static const String postGenerateOtpFoUpdateMobileNo = 'api/edit-otp-send';
  static const String postVerifyOtpFoUpdateMobileNo = 'api/edit-verify-otp';

  // Address
  static const String getAddress = 'api/get-address';
  static const String postAddAddress = 'api/add-address';
  static const String postDeleteAddress = 'api/delete-address';
  static const String getAddressById = 'api/order-address';

  // Basic
  static const String bannerUri = 'api/banners';

  //Home
  static const String categoryList = "api/category";
  static const String getFeaturedProducts = "api/products";
  static const String getHotDealsTodayProducts = "api/today-hot-deals";
  static const String postSearchProduct = "api/products/search?query";

  //wallet
  static const String getWalletTransaction = "api/wallet/transactions";
  static const String postWalletPin = "api/create/consumer/wallet";
  static const String getWallet = "api/consumer/wallet";
  static const String postVerifyPin = "api/wallet/pin/verify";
  static const String postWalletPinRest = "api/wallet/pin/reset";
  static const String getWalletTransactionByDate = "api/wallet/transactions";
  static const String getWalletTransactionByAmount = "api/wallet/transactions";

  // Check out
  static const String postCheckOut = "api/checkout";
  static const String postPayOrderWalled = "api/pay-order";
  static const String getOrder = "api/orders";
  static const String postPaymentStatus = "api/order/payment-status";

  //Dynamic QR
  static const String postDynamicQR = "api/tpipay/paymentOrder";
  static const String postCallBackDynamicQR = "api/tpipay/callback";
  static const String postDynamicQRSubscriptionPayment =
      "api/membership/payment";
  static const String getDynamicQRSubscriptionPaymentStatus =
      "api/membership/payment/status/qr";

  //Product screen
  static const String getCategoryDetails = "api/category-details";
  static const String getProductDetails = "api/products-details";
  static const String postAddToCard = "api/add-carts";
  static const String postRemoveToCard =
      "api/cart/decrease"; // Product Quection is decrease by 1
  static const String getCard = "api/carts";

  // Referral Structure
  static const String getReferral = "api/referrals";
  static const String getReferralLevels = "api/referrals/levels";
  static const String getReferralLevelsDataByID = "api/referrals/level";

  // rewards Structure
  static const String fetchScratchCard = "api/rewards";
  static const String postScratchCardRedeem = "api/scratch-cards/";
  static const String getRewardsWallerHistory = "api/reward-wallet-history";

  // Subscription Structure
  static const String getSubscription = "api/membership-plans-category";
  static const String getSubscriptionById = "api/membership-plans";
  static const String getSubscriptionDetails = "api/membership-plans-details";
  static const String getSubscriptionCheckout = "api/membership";
  static const String getSubscriptionHistory = "api/memberships/user/plan";

  // Coupon
  static const String postCheckCouponCode = "api/check-coupon-code";

  // Fund Requests
  static const String getAssignBank = "api/assign/account";
  static const String postFundRequests = "api/fund/request";
  static const String getFundStatus = "api/fund/request/status";
  static const String getFundDetails = "api/fund/request/status";
  static const String postCreateQR = "api/add-fund/create-order";
  static const String postCreateQRStatus = "api/upi/status";
  static const String postDynamicCreateQR = "api/add-fund/create-order";
  static const String postDynamicQRStatus = "api/add-fund/status";


  // Spin Wheel
  static const String getSpinWheel = "api/spin/wheels";
  static const String postCreateScratchCard = "api/scratchcard/create";

  //  Piracy center
  static const String getPrivacyPolicy = "api/privacy-policy";
  static const String getTermsConditions = "api/terms-conditions";
  static const String getSupport = "api/support";

  //* Recharge
  static const String postRecharge = "api/recharge";
  static const String getRechargePlane = "api/mobile-plans";
  static const String postDynamicForMobileRecharge = "api/recharge/create";

// Padding
  static const double horizontalPadding = 16;
  static const double verticalPadding = 20;
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
      horizontal: AppConstants.horizontalPadding,
      vertical: AppConstants.verticalPadding);

  // Shared Key
  static const String token = 'user_app_token';
  static const String userId = 'user_app_id';
  static const String razorpayKey = 'razorpay_key';
  static const String recentOrders = 'recent_orders';
  static const String isUser = 'is_user';
  static const String isDemoShowKey = 'is_demo_show';
}
