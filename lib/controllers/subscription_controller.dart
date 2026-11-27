import 'dart:developer';

import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/subscription/subscription_history_model.dart';
import 'package:lekra/data/models/subscription_cate_model.dart';
import 'package:lekra/data/models/subscription_model.dart';
import 'package:lekra/data/repositories/subscription_repo.dart';

class SubscriptionController extends GetxController implements GetxService {
  final SubscriptionRepo subscriptionRepo;

  SubscriptionController({required this.subscriptionRepo});

  bool isLoading = false;

  List<SubscriptionCategoryModel> subscriptionCateList = [];
  Future<ResponseModel> fetchSubscriptionCatePlan() async {
    log('-----------  fetchSubscriptionCatePlan() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response =
          await subscriptionRepo.fetchSubscriptionCategoryPlan();

      if (response.statusCode == 200 && response.body['status'] == true) {
        if (response.body['data'] is List) {
          subscriptionCateList = (response.body['data'] as List)
              .map((e) => SubscriptionCategoryModel.fromJson(e))
              .toList();
        } else if (response.body['data'] is Map) {
          subscriptionCateList = [
            SubscriptionCategoryModel.fromJson(response.body['data'])
          ];
        } else {
          subscriptionCateList = [];
        }

        log("subscriptionCateList length ${subscriptionCateList.length}");

        responseModel = ResponseModel(
            true, response.body['message'] ?? "fetchSubscriptionPlan");
      } else {
        log("subscriptionCateList length else ${subscriptionCateList.length}");
        responseModel = ResponseModel(
            false,
            response.body['message'] ??
                "Something Went Wrong fetchSubscriptionPlan");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchSubscriptionPlan");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  SubscriptionCategoryModel? selectSubscriptionCategoryModel;

  void updateSelectSubscriptionCategoryModel(SubscriptionCategoryModel value) {
    selectSubscriptionCategoryModel = value;
    // log("select subcateg ${selectSubscriptionCategoryModel?.id ?? 0}");
  }

  List<SubscriptionModel> subscriptionList = [];
  Future<ResponseModel> fetchSubscriptionPlanById() async {
    log('-----------  fetchSubscriptionPlanById() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await subscriptionRepo.fetchSubscriptionPlanById(
          id: selectSubscriptionCategoryModel?.id);

      if (response.statusCode == 200 && response.body['status'] == true) {
        if (response.body['data'] is List) {
          subscriptionList = (response.body['data'] as List)
              .map((e) => SubscriptionModel.fromJson(e))
              .toList();
        } else if (response.body['data'] is Map) {
          subscriptionList = [
            SubscriptionModel.fromJson(response.body['data'])
          ];
        } else {
          subscriptionList = [];
        }

        log("subscriptionList length ${subscriptionList.length}");

        responseModel = ResponseModel(
            true, response.body['message'] ?? "fetchSubscriptionPlan");
      } else {
        log("subscriptionList length else ${subscriptionList.length}");
        responseModel = ResponseModel(
            false,
            response.body['message'] ??
                "Something Went Wrong fetchSubscriptionPlan");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchSubscriptionPlan");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  SubscriptionModel? selectSubscription;

  Future<ResponseModel> fetchSubscriptionPlanDetails({required int? id}) async {
    log('-----------  fetchSubscriptionPlanDetails() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response =
          await subscriptionRepo.fetchSubscriptionPlanDetails(id: id);

      if (response.statusCode == 200 && response.body['status'] == true) {
        if (response.body['data'] is Map) {
          selectSubscription =
              SubscriptionModel.fromJson(response.body['data']);
        } else if (response.body['data'] is List &&
            (response.body['data'] as List).isNotEmpty) {
          selectSubscription =
              SubscriptionModel.fromJson((response.body['data'] as List).first);
        }

        responseModel = ResponseModel(
            true, response.body['message'] ?? "fetchSubscriptionPlanDetails");
      } else {
        responseModel = ResponseModel(
            false,
            response.body['message'] ??
                "Something Went Wrong fetchSubscriptionPlanDetails");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchSubscriptionPlanDetails");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> subscriptionCheckout({required int? id}) async {
    log('-----------  subscriptionCheckout() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    Map<String, dynamic> data = {
      "wallet_pin": Get.find<WalletController>().walletPin,
    };

    try {
      Response response = await subscriptionRepo.subscriptionCheckout(
          id: id, data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == true) {
        if (response.body['data'] is Map) {
          selectSubscription =
              SubscriptionModel.fromJson(response.body['data']);
        }

        // Refresh wallet balance and user profile immediately after subscription checkout
        try {
          Get.find<WalletController>().fetchWallet();
        } catch (_) {}
        try {
          Get.find<AuthController>().fetchUserProfile();
        } catch (_) {}

        responseModel = ResponseModel(
            true, response.body['message'] ?? "subscriptionCheckout");
      } else {
        responseModel = ResponseModel(
            false,
            response.body['message'] ??
                "Something Went Wrong subscriptionCheckout");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "subscriptionCheckout");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  List<SubscriptionHistoryModel> subscriptionHistoryModelList = [];

  SubscriptionHistoryModel? get activeSubscription {
    if (subscriptionHistoryModelList.isEmpty) return null;
    try {
      return subscriptionHistoryModelList.firstWhere(
        (sub) => sub.status == 1 && (sub.remainingDays == null || sub.remainingDays! > 0),
      );
    } catch (_) {
      return null;
    }
  }

  Future<ResponseModel> fetchSubscriptionHistory() async {
    log('-----------  fetchSubscriptionHistory() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await subscriptionRepo.fetchSubscriptionHistory();

      if (response.statusCode == 200 && response.body['status'] == true) {
        if (response.body['data'] is List) {
          subscriptionHistoryModelList = (response.body['data'] as List)
              .map((e) => SubscriptionHistoryModel.fromJson(e))
              .toList();
        } else if (response.body['data'] is Map) {
          subscriptionHistoryModelList = [
            SubscriptionHistoryModel.fromJson(response.body['data'])
          ];
        } else {
          subscriptionHistoryModelList = [];
        }
        responseModel = ResponseModel(
            true, response.body['message'] ?? "fetchSubscriptionHistory");
      } else {
        responseModel = ResponseModel(
            false,
            response.body['message'] ??
                "Something Went Wrong fetchSubscriptionHistory");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchSubscriptionHistory");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  SubscriptionHistoryModel? selectSubscriptionHistoryModel;

  void updateSubscriptionHistoryModel(
      {required SubscriptionHistoryModel value}) {
    selectSubscriptionHistoryModel = value;
    update();
  }
}
