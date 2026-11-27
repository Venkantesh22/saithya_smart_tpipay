import 'dart:developer';

import 'package:get/get.dart';
import 'package:lekra/controllers/auth_controller.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/reward_transaction_model.dart';
import 'package:lekra/data/models/scratch_model.dart';
import 'package:lekra/data/models/spin_wheel_model.dart';
import 'package:lekra/data/repositories/reward_repo.dart';

class RewardsController extends GetxController implements GetxService {
  final RewardRepo rewardRepo;
  RewardsController({required this.rewardRepo});
  bool isLoading = false;

  List<ScratchCardModel> scratchCardList = [];
  Future<ResponseModel> fetchScratchCard() async {
    log('----------- fetchScratchCard Called() -------------');
    ResponseModel responseModel = ResponseModel(false, "Unknown error");
    isLoading = true;
    update();

    try {
      Response response = await rewardRepo.fetchScratchCard();

      // ✅ Correct key is 'status'
      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['data']['active_scratch_cards'] is List) {
        scratchCardList =
            (response.body['data']['active_scratch_cards'] as List)
                .map((item) => ScratchCardModel.fromJson(item))
                .toList();
        scratchCardList.sort((a, b) {
          if (a.isScratch == false && b.isScratch == true) return -1;
          if (a.isScratch == true && b.isScratch == false) return 1;

          if (a.isExpiry == true && b.isExpiry == false) return 1;
          if (a.isExpiry == false && b.isExpiry == true) return -1;

          return 0;
        });

        log("scratch_cards list : ${scratchCardList.length}");
        responseModel = ResponseModel(
            true, response.body['message'] ?? "Success fetch fetchScratchCard");
      } else {
        log("scratch_cards list else : ${scratchCardList.length}");

        responseModel = ResponseModel(
          false,
          response.body['error'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchScratchCard");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> postScratchCardRedeem({required int? scratchId}) async {
    log('----------- postScratchCardRedeem Called() -------------');
    ResponseModel responseModel = ResponseModel(false, "Unknown error");
    isLoading = true;
    update();

    try {
      Response response =
          await rewardRepo.postScratchCardRedeem(scratchId: scratchId);

      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['data'] is Map) {
        responseModel = ResponseModel(true,
            response.body['message'] ?? "Success fetch postScratchCardRedeem");
        fetchScratchCard();
        Get.find<AuthController>().fetchUserProfile();
      } else {
        responseModel = ResponseModel(
          false,
          response.body['error'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "postScratchCardRedeem");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  List<RewardsTransactionModel> rewardTransactionList = [];
  bool isRewardHistoryLoading = false;

  Future<ResponseModel> fetchRewardsWallerHistory() async {
    log('----------- fetchRewardsWallerHistory Called() -------------');
    ResponseModel responseModel = ResponseModel(false, "Unknown error");
    isRewardHistoryLoading = true;
    update();

    try {
      Response response = await rewardRepo.fetchRewardsWallerHistory();

      // ✅ Correct key is 'status'
      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['data'] is List) {
        rewardTransactionList = (response.body['data'] as List)
            .map((item) => RewardsTransactionModel.fromJson(item))
            .toList();

        log("rewardTransactionList list : ${rewardTransactionList.length}");
        responseModel = ResponseModel(
            true,
            response.body['message'] ??
                "Success fetch fetchRewardsWallerHistory");
      } else {
        log("rewardTransactionList list else : ${rewardTransactionList.length}");

        responseModel = ResponseModel(
          false,
          response.body['error'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchScratchCard");
    }

    isRewardHistoryLoading = false;
    update();
    return responseModel;
  }

  bool isConverting = false;
  Future<ResponseModel> convertRewardPoints({required int points}) async {
    log('----------- convertRewardPoints Called() -------------');
    ResponseModel responseModel = ResponseModel(false, "Unknown error");
    isConverting = true;
    update();

    try {
      Response response = await rewardRepo.postConvertPoints(points: points);

      if (response.body is Map && response.body['status'] == true) {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "Points converted to Cashback Wallet successfully!",
        );
        await fetchScratchCard();
        await fetchRewardsWallerHistory();
        if (Get.isRegistered<AuthController>()) {
          Get.find<AuthController>().fetchUserProfile();
        }
      } else {
        responseModel = ResponseModel(
          false,
          response.body?['message'] ?? response.body?['error'] ?? "Failed to convert points.",
        );
      }
    } catch (e) {
      log("****** Error ****** $e", name: "convertRewardPoints");
      responseModel = ResponseModel(false, "Error: $e");
    }

    isConverting = false;
    update();
    return responseModel;
  }

  List<SpinWheelModel> spinWheelList = [];
  Future<ResponseModel> fetchSpinWheel() async {
    log('----------- fetchSpinWheel Called() -------------');
    ResponseModel responseModel = ResponseModel(false, "Unknown error");
    isLoading = true;
    update();

    try {
      Response response = await rewardRepo.fetchSpinWheel();

      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['data'] is List) {
        spinWheelList = (response.body['data'] as List)
            .map((e) => SpinWheelModel.fromJson(e))
            .toList();
        winSpinWheelModel = null;
        responseModel = ResponseModel(
            true, response.body['message'] ?? "Success fetch fetchSpinWheel");
        log("spinWheelList  : ${spinWheelList.length}");

        Get.find<AuthController>().fetchUserProfile();
      } else {
        log("spinWheelList  else : ${spinWheelList.length}");

        responseModel = ResponseModel(
          false,
          response.body['error'] ?? "Something went wrong fetchSpinWheel()",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchSpinWheel");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  SpinWheelModel? winSpinWheelModel;
  void setWinSpinWheelModel(SpinWheelModel? value) {
    winSpinWheelModel = value;
    update();
  }

  Future<ResponseModel> postCreateScratchCard() async {
    log('----------- postCreateScratchCard Called() -------------');
    ResponseModel responseModel = ResponseModel(false, "Unknown error");
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "value": winSpinWheelModel?.offerValue ?? "",
        "type": winSpinWheelModel?.type ?? "",
      };
      Response response =
          await rewardRepo.postCreateScratchCard(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == true) {
        // spinWheelList = (response.body['data'] as List)
        //     .map((e) => SpinWheelModel.fromJson(e))
        //     .toList();
        // winSpinWheelModel = null;
        responseModel = ResponseModel(
            true, response.body['message'] ?? "Success postCreateScratchCard");
        // log("spinWheelList  : ${spinWheelList.length}");
      } else {
        // log("spinWheelList  else : ${spinWheelList.length}");

        responseModel = ResponseModel(
          false,
          response.body['error'] ??
              "Something went wrong postCreateScratchCard()",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "postCreateScratchCard");
    }

    isLoading = false;
    update();
    return responseModel;
  }
}
