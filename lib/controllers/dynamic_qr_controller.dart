import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/order_controlller.dart';
import 'package:lekra/data/models/dynamic_qr_model/dynamic_model.dart';
import 'package:lekra/data/models/fund_reqests/dynamic_wallet_payment_done_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/service/mobile_recharge_service_models/dynamic_for_reacharge_moble.dart';
import 'package:lekra/data/repositories/dynamic_qr_repo.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/screens/fund_requent_qr/fund_add_success/fund_add_success_screen.dart';

class DynamicQRController extends GetxController implements GetxService {
  final DynamicQrRepo dynamicQrRepo;
  DynamicQRController({required this.dynamicQrRepo});
  bool isLoading = false;

  DynamicModel? dynamicModel;
  Future<ResponseModel> dynamicQR() async {
    log('----------- dynamicQR Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await dynamicQrRepo.postGenerateDynamicQR(
          orderId: Get.find<OrderController>().orderId);

      if (response.statusCode == 200 && response.body['status'] == true) {
        dynamicModel = DynamicModel.fromJson(response.body['data']);
        responseModel = ResponseModel(
            true, response.body['message'] ?? " dynamicQR success");
      } else {
        responseModel = ResponseModel(
            false, response.body['error'] ?? "Error while dynamicQR user");
      }
    } catch (e) {
      log('ERROR AT dynamicQR(): $e');
      responseModel = ResponseModel(false, "Error while dynamicQR user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  bool isDynamicQRPaymentDone = false;
  Future<ResponseModel> checkPaymentStatus() async {
    log('----------- checkPaymentStatus Called ----------');

    ResponseModel responseModel;

    try {
      Map<String, dynamic> data = {
        'gateway_order_id': dynamicModel?.orderId,
      };

      Response response =
          await dynamicQrRepo.checkPaymentStatus(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == true) {
        isDynamicQRPaymentDone =
            response.body['transaction_status'] == "success" ? true : false;

        responseModel = ResponseModel(
            true, response.body['message'] ?? " checkPaymentStatus success");
      } else {
        responseModel = ResponseModel(false,
            response.body['error'] ?? "Error while checkPaymentStatus user");
      }
    } catch (e) {
      log('ERROR AT checkPaymentStatus(): $e');
      responseModel =
          ResponseModel(false, "Error while checkPaymentStatus user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> checkoutDynamicQRSubscriptionPayment({
    required int? subscriptionID,
  }) async {
    log('----------- checkoutDynamicQRSubscriptionPayment Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    Map<String, dynamic> data = {};

    try {
      Response response =
          await dynamicQrRepo.checkoutDynamicQRSubscriptionPayment(
              subscriptionID: subscriptionID, data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == true) {
        dynamicModel = DynamicModel.fromJson(response.body['data']);

        responseModel = ResponseModel(
            true,
            response.body['message'] ??
                " checkoutDynamicQRSubscriptionPayment success");
      } else {
        responseModel = ResponseModel(
            false,
            response.body['error'] ??
                "Error while checkoutDynamicQRSubscriptionPayment user");
      }
    } catch (e) {
      log('ERROR AT checkoutDynamicQRSubscriptionPayment(): $e');
      responseModel = ResponseModel(
          false, "Error while checkoutDynamicQRSubscriptionPayment user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> checkDynamicQRSubscriptionPaymentStatus() async {
    log('----------- checkDynamicQRSubscriptionPaymentStatus Called ----------');

    ResponseModel responseModel;

    try {
      Response response =
          await dynamicQrRepo.checkDynamicQRSubscriptionPaymentStatus(
              orderID: dynamicModel?.orderId);

      if (response.statusCode == 200 && response.body['status'] == true) {
        isDynamicQRPaymentDone =
            response.body['transaction_status'] == "success" ? true : false;

        responseModel = ResponseModel(
            true,
            response.body['message'] ??
                " checkDynamicQRSubscriptionPaymentStatus success");
      } else {
        responseModel = ResponseModel(
            false,
            response.body['error'] ??
                "Error while checkDynamicQRSubscriptionPaymentStatus user");
      }
    } catch (e) {
      log('ERROR AT checkPaymentStatus(): $e');
      responseModel = ResponseModel(
          false, "Error while checkDynamicQRSubscriptionPaymentStatus user $e");
    }

    // isLoading = false;
    // update();
    return responseModel;
  }

  DynamicForRechargeMobileModel? dynamicForRechargeMobileModel;
  Future<ResponseModel> fetchDynamicForMobileRecharge({
    required String mobileNumber,
    required String operatorId,
    required String amount,
    required BuildContext context,
  }) async {
    log('----------- fetchDynamicForMobileRecharge Called() -------------');

    ResponseModel responseModel = ResponseModel(false, "Unknown error");
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "mobile": mobileNumber,
        'operator_id': operatorId,
        'amount': amount,
      };

      Response response = await dynamicQrRepo.fetchDynamicForMobileRecharge(
        data: FormData(data),
      );

      if (response.statusCode == 200 && (response.body['status'] == true)) {
        dynamicModel = DynamicModel.fromJson(response.body['data']);

        // dynamicModel = DynamicModel(
        //   qrString: dynamicForRechargeMobileModel?.qr ?? "",
        //   amount: double.tryParse(dynamicForRechargeMobileModel?.amount ?? ""),
        //   vpa: dynamicForRechargeMobileModel?.vpa ?? "",
        //   orderId: dynamicForRechargeMobileModel?.orderId,
        // );

        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "Success fetchDynamicForMobileRecharge",
        );
      } else {
        responseModel = ResponseModel(
          false,
          response.body['message'] ??
              "Something went wrong fetchDynamicForMobileRecharge",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch error");
      log("****** Error ****** $e", name: "fetchDynamicForMobileRecharge");
    }

    isLoading = false;
    update();

    return responseModel;
  }

  Timer? _statusTimer;
  Timer? _countdownTimer;

  int totalSeconds = 5 * 60;
  int remainingSeconds = 0;
  bool isPaymentDone = false;

  void startPaymentFlow({
    required BuildContext context,
    bool isForWalletFundAdd = false,
  }) {
    remainingSeconds = totalSeconds;
    isPaymentDone = false;

    update();

    _startCountdown(context);
    _startPolling(
      context: context,
      isForWalletFundAdd: isForWalletFundAdd,
    );
  }

  void _startCountdown(BuildContext context) {
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds <= 1) {
        stopAllTimers();
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        return;
      }

      remainingSeconds--;
      update();
    });
  }

  void _startPolling({
    required BuildContext context,
    bool isForWalletFundAdd = false,
  }) {
    _statusTimer?.cancel();
    _statusTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (dynamicModel?.orderId == null) return;

      //* this For wallet recharge
      if (isForWalletFundAdd) {
        fetchDynamicQRStatusForWalletAddFund(context: context);
      }

      if (isPaymentDone) {
        stopAllTimers();

        showToast(
          message: "Payment Successful 🎉",
          typeCheck: true,
        );

        dynamicModel = null;
      }
      if (isPaymentDone) {
        stopAllTimers();

        if (isForWalletFundAdd) {
          navigate(context: context, page: const FundAddSuccessScreen());
        }

        // showToast(
        //   message: "Payment Successful 🎉",
        //   typeCheck: true,
        // );

        dynamicModel = null;
      }
    });
  }

  void stopAllTimers() {
    _countdownTimer?.cancel();
    _statusTimer?.cancel();

    _countdownTimer = null;
    _statusTimer = null;
  }

  @override
  void onClose() {
    _statusTimer?.cancel();
    _countdownTimer?.cancel();
    super.onClose();
  }

  Future<ResponseModel> fetchDynamicQRForFund({required String amount}) async {
    log('-----------  fetchDynamicQRForFund() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        'amount': amount,
      };
      Response response = await dynamicQrRepo.fetchDynamicQRForFund(
        data: FormData(data),
      );

      if (response.statusCode == 200 && response.body['status'] == "success") {
        dynamicModel = DynamicModel.fromJson(response.body['data']);
        log("check 1 $amount  ${dynamicModel?.amount} ");
        dynamicModel = dynamicModel?.copyWith(amount: double.tryParse(amount));
        log("check 2   ${dynamicModel?.amount} ");

        responseModel = ResponseModel(
            true, response.body['message'] ?? "fetchDynamicQRForFund");
      } else {
        responseModel = ResponseModel(
            false,
            response.body['message'] ??
                "Something Went Wrong in fetchDynamicQRForFund");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchDynamicQRForFund");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  DynamicWalletPaymentDoneModel? dynamicWalletPaymentDoneModel;
  Future<ResponseModel> fetchDynamicQRStatusForWalletAddFund(
      {required BuildContext context}) async {
    log('----------- fetchDynamicQRStatusForWalletAddFund Called ----------');

    ResponseModel responseModel;

    try {
      Map<String, dynamic> data = {'order_id': dynamicModel?.orderId};

      Response response =
          await dynamicQrRepo.fetchDynamicQRStatusForFund(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == "success") {
        dynamicWalletPaymentDoneModel =
            DynamicWalletPaymentDoneModel.fromJson(response.body['data']);

        isPaymentDone =
            response.body['data']['status'] == "success" ? true : false;

        responseModel = ResponseModel(
            true,
            response.body['message'] ??
                " fetchDynamicQRStatusForWalletAddFund success");
      } else {
        responseModel = ResponseModel(
            false,
            response.body['error'] ??
                "Error while fetchDynamicQRStatusForWalletAddFund user");
      }
    } catch (e) {
      log('ERROR AT checkPaymentStatus(): $e');
      responseModel = ResponseModel(
          false, "Error while fetchDynamicQRStatusForWalletAddFund user $e");
    }

    // isLoading = false;
    // update();
    return responseModel;
  }
}
