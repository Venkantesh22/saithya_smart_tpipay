import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/service/mobile_recharge_service_models/network_service_model.dart';
import 'package:lekra/data/models/service/mobile_recharge_service_models/recharge_plan_model.dart';
import 'package:lekra/data/models/service/mobile_recharge_service_models/recharge_state_area_model.dart';
import 'package:lekra/data/models/service/mobile_recharge_service_models/recharge_success_model.dart';
import 'package:lekra/data/repositories/recharge_repo.dart';
import 'package:lekra/views/base/custom_image.dart';

class RechargeController extends GetxController implements GetxService {
  final RechargeRepo rechargeRepo;

  RechargeController({required this.rechargeRepo});

  bool isLoading = false;
  TextEditingController mobileNoController = TextEditingController();

  NetworkServiceModel? selectNetworkOperate;

  List<NetworkServiceModel> networkServiceModelList = [
    NetworkServiceModel(
        networkName: "Airtel",
        operatorRechargeCode: "1",
        logo: Assets.imagesAritelLogo,
        operatorId: "2"),
    NetworkServiceModel(
        networkName: "BSNL",
        operatorRechargeCode: "2",
        logo: Assets.imagesBSNLLogo,
        operatorId: "4"),
    NetworkServiceModel(
        networkName: "Jio",
        operatorRechargeCode: "167",
        logo: Assets.imagesJioLogo,
        operatorId: "5"),
    NetworkServiceModel(
        networkName: "Vodafone",
        operatorRechargeCode: "5",
        logo: Assets.imagesVodafoneLogo,
        operatorId: "1"),
  ];

  RechargeStateAreaModel? selectRechargeStateAreaModel;

  TextEditingController rechargeAmountController = TextEditingController();

  RechargeSuccessModel? rechargeSuccessModel;
  Future<ResponseModel> mobileRecharge() async {
    log('----------- mobileRecharge Called() -------------');
    if (isLoading) {
      return ResponseModel(false, "Recharge is already in progress, please wait...");
    }
    ResponseModel responseModel = ResponseModel(false, "Unknown error");
    isLoading = true;
    update();

    try {
      final walletController = Get.find<WalletController>();
      Map<String, dynamic> data = {
        'mobile': mobileNoController.text.trim(),
        'amount': selectRechargePlan?.rs ?? "",
        'operator_id': selectNetworkOperate?.operatorRechargeCode,
        "wallet_pin": walletController.walletPin,
      };

      Response response =
          await rechargeRepo.mobileRecharge(data: FormData(data));

      // ✅ Correct key is 'status'
      if (response.statusCode == 200 && response.body['status'] == true) {
        rechargeSuccessModel =
            RechargeSuccessModel.fromJson(response.body['data']);

        responseModel = ResponseModel(
            true,
            response.body['message'] ??
                "Success fetch fetchReferralLevelDataByID");
      } else {
        responseModel = ResponseModel(
          false,
          response.body['message'] ??
              "Something went wrong fetchReferralLevelDataByID",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchReferralLevelDataByID");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  RechargePlanResponse? rechargePlanResponseList;
  List<String> rechargeCategoriesList = [];

  Future<ResponseModel> fetchMobileRechargePlan() async {
    log('----------- fetchMobileRechargePlan Called() -------------');

    ResponseModel responseModel = ResponseModel(false, "Unknown error");
    isLoading = true;
    update();

    try {
      Response response = await rechargeRepo.fetchMobileRechargePlan(
        operatorCode: selectNetworkOperate?.operatorId,
        circleCode: selectRechargeStateAreaModel?.id,
      );

      if (response.statusCode == 200 &&
          (response.body['status'] == true ||
              response.body['success'] == true)) {
        /// 🔥 PARSE MODEL
        rechargePlanResponseList = RechargePlanResponse.fromJson(response.body);

        /// 🔥 EXTRACT CATEGORY LIST
        rechargeCategoriesList =
            rechargePlanResponseList?.plans?.keys.toList() ?? [];

        selectRechargeCategories = rechargeCategoriesList.first;

        log("Categories: $rechargeCategoriesList");

        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "Success fetchMobileRechargePlan",
        );
      } else {
        responseModel = ResponseModel(
          false,
          response.body['message'] ??
              "Something went wrong fetchMobileRechargePlan",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch error");
      log("****** Error ****** $e", name: "fetchMobileRechargePlan");
    }

    isLoading = false;
    update();

    return responseModel;
  }

  String? selectRechargeCategories;

  void updateSelectRechargeCategories(String value) {
    selectRechargeCategories = value;
    update();
  }

  List<RechargePlan> get selectedPlans {
    final query = mobileRechargeSearchController.text.trim();

    /// 👉 If search is EMPTY → show selected category (normal flow)
    if (query.isEmpty) {
      if (selectRechargeCategories == null) return [];

      return rechargePlanResponseList?.plans?[selectRechargeCategories] ?? [];
    }

    /// 🔥 NUMERIC ONLY SEARCH
    final allPlans = rechargePlanResponseList?.plans?.values
            .expand((list) => list)
            .toList() ??
        [];

    return allPlans.where((plan) {
      final amount = plan.rs ?? "";
      final validity = plan.validity ?? "";

      return amount.contains(query) || validity.contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();

    mobileRechargeSearchController.addListener(() {
      update(); // 🔥 rebuild UI on search
    });
  }

  RechargePlan? selectRechargePlan;

  void updateSelectRechargePlan(RechargePlan? value) {
    selectRechargePlan = value;
    update();
  }

  int selectedPaymentIndex = 0;

  void selectPaymentMethod(int index) {
    selectedPaymentIndex = index;
    update();
  }

  TextEditingController mobileRechargeSearchController =
      TextEditingController();
}
