// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/data/models/fund_reqests/bank_model.dart';
import 'package:lekra/data/models/fund_reqests/fund_ruquest_model.dart';
import 'package:lekra/data/models/fund_reqests/upi_qr_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/user_model.dart';
import 'package:lekra/data/repositories/fund_request_repo.dart';
import 'package:lekra/services/constants.dart';

class FundRequestController extends GetxController implements GetxService {
  final FundRequestRepo fundRequestRepo;
  FundRequestController({required this.fundRequestRepo});

  bool isLoading = false;

  final TextEditingController utrNoController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  BankModel? selectedBank;

  void setBank(String? value) {
    selectedBank = bankList.firstWhere((bank) => bank.accountName == value);
    update();
  }

  List<BankModel> bankList = [];
  Future<ResponseModel> getAssignBank() async {
    log('-----------  getAssignBank() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await fundRequestRepo.getAssignBank();

      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['data'] is List) {
        bankList = (response.body['data'] as List)
            .map((bank) => BankModel.fromJson(bank))
            .toList();
        selectedBank = bankList.first;
        responseModel =
            ResponseModel(true, response.body['message'] ?? "getAssignBank");
      } else {
        responseModel = ResponseModel(false,
            response.body['error'] ?? "getAssignBank Something Went Wrong");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "getAssignBank");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> postFundRequest() async {
    log('-----------  postFundRequest() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    Map<String, dynamic> data = {
      "bank_id": selectedBank?.id ?? "",
      "amount": amountController.text.trim(),
      "trans_date": dateController.text.trim(),
      "utr": utrNoController.text.trim(),
    };

    try {
      Response response =
          await fundRequestRepo.postFundRequest(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == true) {
        responseModel =
            ResponseModel(true, response.body['message'] ?? "postFundRequest");

        selectedBank = null;
        amountController.clear();
        dateController.clear();
        utrNoController.clear();
      } else {
        responseModel = ResponseModel(false,
            response.body['error'] ?? "postFundRequest Something Went Wrong");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "postFundRequest");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  List<FundRequestsModel> fundRequestsList = [];
  Future<ResponseModel> fetchFundStatus() async {
    log('-----------  fetchFundStatus() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await fundRequestRepo.fetchFundStatus();

      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['data'] is List) {
        fundRequestsList = (response.body['data'] as List)
            .map((fund) => FundRequestsModel.fromJson(fund))
            .toList();

        responseModel =
            ResponseModel(true, response.body['message'] ?? "fetchFundStatus");
      } else {
        responseModel = ResponseModel(false,
            response.body['error'] ?? "fetchFundStatus Something Went Wrong");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchFundStatus");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  FundRequestsModel? selectFundRequestModel;
  void setSelectFundRequestsModel(FundRequestsModel? value) {
    selectFundRequestModel = value;
    update();
  }

  Future<ResponseModel> fetchFundDetails() async {
    log('-----------  fetchFundDetails() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await fundRequestRepo.fetchFundDetails(
          id: selectFundRequestModel?.id);

      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['data'] is Map) {
        selectFundRequestModel =
            FundRequestsModel.fromJson(response.body['data']);

        responseModel =
            ResponseModel(true, response.body['message'] ?? "fetchFundDetails");
      } else {
        responseModel = ResponseModel(
            false,
            response.body['message'] ??
                "fetchFundDetails Something Went Wrong");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchFundDetails");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  void updateAmountControllerPrice(String value) {
    amountController.text = value;
    update();
  }

  UpiQrModel? upiQRModel;

  Future<ResponseModel> createUPIQR({required UserModel userModel}) async {
    log('-----------  createUPIQR() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "amount": amountController.text.trim(),
      };
      Response response =
          await fundRequestRepo.createUPIQR(data: FormData(data));

      if (response.statusCode == 200 &&
          response.body['status'] == "success" &&
          response.body['qrString'] != null) {
        upiQRModel = UpiQrModel(
          orderId: response.body['order_id'],
          amount: response.body['amount'],
          qrString: response.body['qrString'],
          gatewayOrderId: response.body['gateway_order_id'],
        );

        responseModel =
            ResponseModel(true, response.body['message'] ?? "createUPIQR");
      } else {
        responseModel = ResponseModel(
            false, response.body['message'] ?? "Something Went Wrong");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "createUPIQR");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  void updateUpiQRModel({required UpiQrModel? value}) {
    upiQRModel = value;
    // log("check 1 -- ${upiQRModel?.gatewayOrderId}");
    update();
  }

  bool isPaymentDone = false;

  void updateIsPaymentDone({required bool value}) {
    isPaymentDone = value;
    // log("Check 2 --- isPaymentDone == $isPaymentDone ");
    update();
  }

  Future<ResponseModel> uPIQRStatus() async {
    log('-----------  uPIQRStatus() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {};
      Response response = await fundRequestRepo.uPIQRStatus(
          data: FormData(data), gatewayOrderId: upiQRModel?.gatewayOrderId);

      if (response.statusCode == 200 && response.body['status'] == true) {
        isPaymentDone =
            response.body['payment_status'] == "success" ? true : false;
        responseModel =
            ResponseModel(true, response.body['message'] ?? "uPIQRStatus");
      } else {
        responseModel = ResponseModel(false,
            response.body['message'] ?? "Something Went Wrong in uPIQRStatus");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "uPIQRStatus");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Timer? _statusTimer;
  Timer? _countdownTimer;

  int totalSeconds = 5 * 60;
  int remainingSeconds = 0;

  void startPaymentFlow({
    required BuildContext context,
    bool isCheckPayment = false,
  }) {
    remainingSeconds = totalSeconds;
    isPaymentDone = false;

    update();

    _startCountdown(context);
    _startPolling(
      context: context,
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
  }) {
    _statusTimer?.cancel();
    _statusTimer = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (upiQRModel?.orderId == null) return;

      //* this For wallet recharge

      await uPIQRStatus();

      if (isPaymentDone) {
        stopAllTimers();

        await Get.find<WalletController>()
            .fetchWalletTransaction(refresh: true)
            .then((value) {
          if (value.isSuccess) {
            Get.find<WalletController>().fetchWallet();

            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }

            showToast(
              message: "Payment Successful 🎉",
              typeCheck: true,
            );
            upiQRModel = null;
          } else {
            showToast(
              message: value.message,
              typeCheck: value.isSuccess,
            );
          }
        });
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
    utrNoController.dispose();
    amountController.dispose();
    dateController.dispose();

    _statusTimer?.cancel();
    _countdownTimer?.cancel();
    super.onClose();
  }


  // Future<ResponseModel> fetchDynamicQRForFund() async {
  //   log('-----------  fetchDynamicQRForFund() -------------');
  //   ResponseModel responseModel;
  //   isLoading = true;
  //   update();

  //   try {
  //     Map<String, dynamic> data = {
  //       'order_id' : amountController.text.trim(),
  //     };
  //     Response response = await fundRequestRepo.fetchDynamicQRForFund(
  //         data: FormData(data), );

  //     if (response.statusCode == 200 && response.body['status'] == true) {
  //       // isPaymentDone =
  //       //     response.body['payment_status'] == "success" ? true : false;
  //       responseModel =
  //           ResponseModel(true, response.body['message'] ?? "uPIQRStatus");
  //     } else {
  //       responseModel = ResponseModel(false,
  //           response.body['message'] ?? "Something Went Wrong in uPIQRStatus");
  //     }
  //   } catch (e) {
  //     responseModel = ResponseModel(false, "Catch");
  //     log("****** Error ****** $e", name: "uPIQRStatus");
  //   }

  //   isLoading = false;
  //   update();
  //   return responseModel;
  // }
}
