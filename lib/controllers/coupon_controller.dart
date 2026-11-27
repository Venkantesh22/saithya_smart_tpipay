import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/product_controller.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/repositories/coupon_repo.dart';

class CouponController extends GetxController implements GetxService {
  final CouponRepo couponRepo;
  CouponController({required this.couponRepo});

  bool isLoading = false;
  bool isLoadingCoupons = false;
  List<dynamic> availableCoupons = [];

  TextEditingController couponCodeController = TextEditingController();
  String couponCode = "";

  Future<void> getAvailableCoupons() async {
    isLoadingCoupons = true;
    update();
    try {
      Response response = await couponRepo.fetchCoupons();
      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['data'] is List) {
        availableCoupons = response.body['data'];
      }
    } catch (e) {
      log('ERROR AT getAvailableCoupons(): $e');
    }
    isLoadingCoupons = false;
    update();
  }

  Future<ResponseModel> validateCouponController([String? directCode]) async {
    log('----------- validateCouponController Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    if (directCode != null && directCode.isNotEmpty) {
      couponCodeController.text = directCode;
    }
    couponCode = couponCodeController.text.trim();
    try {
      Map<String, dynamic> data = {
        "code": couponCodeController.text.trim(),
      };

      log("code : ${couponCodeController.text.trim()}");
      Response response = await couponRepo.postCouponCode(data: FormData(data));

      if (response.body['status'] == true) {
        responseModel = ResponseModel(true,
            response.body['message'] ?? "validateCouponController success");
        await Get.find<ProductController>()
            .fetchCard(couponCode: couponCodeController.text.trim());
        couponCodeController.clear();
      } else {
        responseModel = ResponseModel(
            false,
            response.body['message'] ??
                "Error while validateCouponController user");
      }
    } catch (e) {
      log('ERROR AT validateCouponController(): $e');
      responseModel =
          ResponseModel(false, "Error while validateCouponController user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }
}
