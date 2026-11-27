import 'dart:developer';

import 'package:get/get.dart';
import 'package:lekra/data/models/card_model.dart';
import 'package:lekra/data/models/pagination/pagination_model.dart';
import 'package:lekra/data/models/pagination/pagination_state.dart';
import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/repositories/product_repo.dart';

enum CateFilterBarEnum { all, price, none }

enum PriceSortOrder { lowToHigh, highToLow, none }

class ProductController extends GetxController implements GetxService {
  final ProductRepo productRepo;
  ProductController({required this.productRepo});
  bool isLoading = false;

// FEATURED: Pagination state
  PaginationState<ProductModel> cateProductListState =
      PaginationState<ProductModel>();

  // convenient getter for UI
  List<ProductModel> get cateProductList => cateProductListState.items;

  // List<ProductModel> cateProductList = [];
  Future<ResponseModel> fetchCategory({
    int? categoryId,
    bool loadMore = false,
    bool refresh = false,
    bool lowToHight = false,
    bool hightToLow = false,
  }) async {
    log('fetchCategory called (loadMore: $loadMore, refresh: $refresh)');
    ResponseModel responseModel;
    if (refresh) {
      cateProductListState.reset();
      cateProductListState.page = 1;
    }
    if (loadMore) {
      if (!cateProductListState.canLoadMore) {
        return ResponseModel(false, "No more pages");
      }
      // prepare for next page
      cateProductListState.page += 1;
      cateProductListState.isMoreLoading = true;
    } else {
      // initial load (or refresh)
      cateProductListState.isInitialLoading = true;
      cateProductListState.page = 1;
    }

    isLoading = true;
    update();

    try {
      Response response = await productRepo.fetchCategoryDetails(
          categoryId: categoryId,
          page: cateProductListState.page,
          lowToHight: lowToHight,
          hightToLow: hightToLow);

      if (response.statusCode == 200 &&
          response.body['success'] == true &&
          response.body['products']['data'] is List) {
        final pagination = PaginationModel<ProductModel>.fromJson(
          response.body['products'],
          (json) => ProductModel.fromJson(json),
        );

        cateProductListState.lastPage = pagination.lastPage;
        cateProductListState.page = pagination.currentPage;
        if (loadMore) {
          // dedupe by id (if your ProductModel has `id`)
          for (final p in pagination.data) {
            if (!cateProductListState.dedupeIds.contains(p.id)) {
              cateProductListState.dedupeIds.add(p.id);
              cateProductListState.items.add(p);
            }
          }
        } else {
          cateProductListState.items
            ..clear()
            ..addAll(pagination.data);
          cateProductListState.dedupeIds.clear();
          cateProductListState.dedupeIds
              .addAll(pagination.data.map((e) => e.id));
        }

        responseModel =
            ResponseModel(true, response.body['message'] ?? "fetchCategory");
      } else {
        log("Product length else ${cateProductList.length}");

        responseModel = ResponseModel(
            false, response.body['error'] ?? "Something Went Wrong");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchCategory");
      if (loadMore && cateProductListState.page > 1) {
        cateProductListState.page -= 1;
      }
    } finally {
      cateProductListState.isInitialLoading = false;
      cateProductListState.isMoreLoading = false;
      isLoading = false;
      update();
    }

    return responseModel;
  }

  ProductModel? productModel;
  Future<ResponseModel> fetchProduct({required int? productId}) async {
    log('-----------  fetchProduct() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response =
          await productRepo.fetchProductDetails(productId: productId);

      if (response.statusCode == 200 &&
          response.body['success'] == true &&
          response.body['data'] is Map) {
        productModel = ProductModel.fromJson(response.body['data']);

        responseModel =
            ResponseModel(true, response.body['message'] ?? "fetchProduct");
      } else {
        responseModel = ResponseModel(
            false, response.body['error'] ?? "Something Went Wrong");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchProduct");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> postAddToCard({required ProductModel? product}) async {
    log('----------- postAddToCard Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "productName": product?.name ?? "",
        "productPrice": product?.discountedPrice ?? "",
        "productId": product?.id ?? "",
      };
      log("Disc price ${product?.discountedPrice}");
      Response response = await productRepo.postAddToCard(
          data: FormData(data), productId: product?.id);

      if (response.body['status'] == true) {
        responseModel = ResponseModel(
            true, response.body['message'] ?? "Add to Card success");
        await fetchCard();
      } else {
        responseModel = ResponseModel(
            false, response.body['error'] ?? "Error while postAddToCard user");
      }
    } catch (e) {
      log('ERROR AT postAddToCard(): $e');
      responseModel = ResponseModel(false, "Error while postAddToCard user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> postRemoveToCard(
      {required ProductModel? product}) async {
    log('----------- postRemoveToCard Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response =
          await productRepo.postRemoveToCard(productId: product?.id);

      if (response.body['status'] == true) {
        responseModel = ResponseModel(true,
            response.body['message'] ?? "remove to postRemoveToCard success");
        await fetchCard();
      } else {
        responseModel = ResponseModel(false,
            response.body['error'] ?? "Error while postRemoveToCard user");
      }
    } catch (e) {
      log('ERROR AT postRemoveToCard(): $e');
      responseModel =
          ResponseModel(false, "Error while postRemoveToCard user $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  CardModel? cardModel;

  Future<ResponseModel> fetchCard({
    String? couponCode,
    bool? isUserRewardCoin,
  }) async {
    log('-----------  fetchCard() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "code": couponCode,
        "rewardcoins": isUserRewardCoin ?? false,
      };

      Response response = await productRepo.fetchCard(data: FormData(data));

      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['data'] is Map) {
        cardModel = CardModel.fromJson(response.body["data"]);

        log("cardModelList length ${cardModel?.products?.length} ");

        responseModel =
            ResponseModel(true, response.body['message'] ?? "fetchCard");
      } else {
        log("cardModelList length else ");
        responseModel = ResponseModel(
            false, response.body['error'] ?? "Something Went Wrong");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchCard");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  CateFilterBarEnum selectCateFilterBar = CateFilterBarEnum.all;

  void updateCateFilterBarEnum(CateFilterBarEnum value) {
    selectCateFilterBar = value;
    log("selectCateFilterBar  = $selectCateFilterBar");
    update();
  }

  PriceSortOrder selectedPriceSort = PriceSortOrder.none;

  void updatePriceSort(PriceSortOrder order) {
    selectedPriceSort = order;

    update();
  }

  void reSetCateFilter() {
    updateCateFilterBarEnum(CateFilterBarEnum.all);
    updatePriceSort(PriceSortOrder.none);
    update();
  }
}
