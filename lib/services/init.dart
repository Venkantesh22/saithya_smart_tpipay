import 'dart:developer';
import 'package:get/instance_manager.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/controllers/coupon_controller.dart';
import 'package:lekra/controllers/dynamic_qr_controller.dart';
import 'package:lekra/controllers/fund_request_controller.dart';
import 'package:lekra/controllers/order_controlller.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/controllers/dashboard_controller.dart';
import 'package:lekra/controllers/home_controller.dart';
import 'package:lekra/controllers/recharge_controller.dart';
import 'package:lekra/controllers/referral_controller.dart';
import 'package:lekra/controllers/reward_controller.dart';
import 'package:lekra/controllers/subscription_controller.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/controllers/notification_controller.dart';
import 'package:lekra/controllers/location_controller.dart';
import 'package:lekra/data/repositories/dynamic_qr_repo.dart';
import 'package:lekra/data/repositories/fund_request_repo.dart';
import 'package:lekra/data/repositories/order_repo.dart';
import 'package:lekra/data/repositories/coupon_repo.dart';
import 'package:lekra/data/repositories/product_repo.dart';
import 'package:lekra/data/repositories/home_repo.dart';
import 'package:lekra/data/repositories/recharge_repo.dart';
import 'package:lekra/data/repositories/refarral_repo.dart';
import 'package:lekra/data/repositories/reward_repo.dart';
import 'package:lekra/data/repositories/subscription_repo.dart';
import 'package:lekra/data/repositories/wallet_repo.dart';
import 'package:lekra/data/repositories/notification_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth_controller.dart';
import '../controllers/permission_controller.dart';
import '../data/api/api_client.dart';
import '../data/repositories/auth_repo.dart';
import '../data/repositories/basic_repo.dart';
import 'constants.dart';

class Init {
  initialize() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      Get.lazyPut<SharedPreferences>(() => sharedPreferences);

      // ApiClient
      Get.lazyPut(() => ApiClient(
          appBaseUrl: AppConstants.baseUrl,
          sharedPreferences: sharedPreferences));

      Get.lazyPut(() => PermissionController());

      // Get Repo's...
      Get.lazyPut(
          () => AuthRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
      Get.lazyPut(() => BasicRepo(
          apiClient: Get.find(), sharedPreferences: sharedPreferences));
      Get.lazyPut(() => HomeRepo(apiClient: Get.find()));
      Get.lazyPut(() => ProductRepo(apiClient: Get.find()));
      Get.lazyPut(() => OrderRepo(apiClient: Get.find()));
      Get.lazyPut(() => RewardRepo(apiClient: Get.find()));
      Get.lazyPut(() => SubscriptionRepo(apiClient: Get.find()));
      Get.lazyPut(() => WallerRepo(apiClient: Get.find()));
      Get.lazyPut(() => CouponRepo(apiClient: Get.find()));
      Get.lazyPut(() => DynamicQrRepo(apiClient: Get.find()));
      Get.lazyPut(() => FundRequestRepo(apiClient: Get.find()));
      Get.lazyPut(() => ReferralRepo(apiClient: Get.find()));
      Get.lazyPut(() => RechargeRepo(apiClient: Get.find()));
      Get.lazyPut(() => NotificationRepo(apiClient: Get.find()));

      // Get Controller's...
      Get.lazyPut(() => DashBoardController());
      Get.lazyPut(() => AuthController(authRepo: Get.find()));
      Get.lazyPut(() => HomeController(homeRepo: Get.find()));
      Get.lazyPut(() => BasicController(basicRepo: Get.find()));
      Get.lazyPut(() => ProductController(productRepo: Get.find()));
      Get.lazyPut(() => OrderController(orderRepo: Get.find()));
      Get.lazyPut(() => RewardsController(rewardRepo: Get.find()));
      Get.lazyPut(() => SubscriptionController(subscriptionRepo: Get.find()));
      Get.lazyPut(() => WalletController(wallerRepo: Get.find()));
      Get.lazyPut(() => CouponController(couponRepo: Get.find()));
      Get.lazyPut(() => DynamicQRController(dynamicQrRepo: Get.find()));
      Get.lazyPut(() => FundRequestController(fundRequestRepo: Get.find()));
      Get.lazyPut(() => ReferralController(referralRepo: Get.find()));
      Get.lazyPut(() => RechargeController(rechargeRepo: Get.find()));
      Get.lazyPut(() => LocationController(
          apiClient: Get.find(), sharedPreferences: sharedPreferences), fenix: true);
      Get.lazyPut(() => NotificationController(
          notificationRepo: Get.find(), sharedPreferences: sharedPreferences));
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT initialize()");
    }
  }
}
