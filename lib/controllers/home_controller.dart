import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/data/models/home/category_model.dart';

import 'package:lekra/data/models/product_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/repositories/home_repo.dart';
import 'package:lekra/data/models/pagination/index.dart';

class HomeController extends GetxController implements GetxService {
  final HomeRepo homeRepo;
  HomeController({required this.homeRepo});
  bool isLoading = false;

  TextEditingController searchController = TextEditingController();

  List<CategoryModel> categoryList = [];

  Future<ResponseModel> fetchHomeCategory() async {
    log('----------- fetchHomeCategory Called() -------------');
    ResponseModel responseModel = ResponseModel(false, "Unknown error");
    isLoading = true;
    update();

    try {
      Response response = await homeRepo.getCategory();

      // ✅ Correct key is 'status'
      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['data']['data'] is List) {
        categoryList = (response.body['data']['data'] as List)
            .map((item) => CategoryModel.fromJson(item))
            .toList();

        log("Category list : ${categoryList.length}");
        log("First category created_at: ${categoryList.first.createdAt}");
        responseModel = ResponseModel(true, "Success");
      } else {
        responseModel = ResponseModel(
          false,
          response.body['error'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchHomeCategory");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  CategoryModel? selectCategoryModel;
  void updateSelectCategoryModel(CategoryModel value){
    selectCategoryModel = value;
    update();
  }

  // FEATURED: Pagination state
  final PaginationState<ProductModel> featuredState =
      PaginationState<ProductModel>();

  // convenient getter for UI
  List<ProductModel> get featuredProductList => featuredState.items;

  /// Fetch featured products.
  /// - loadMore: true => fetch next page
  /// - refresh: true => reset and fetch page 1
  Future<ResponseModel> fetchFeaturedProducts({
    bool loadMore = false,
    bool refresh = false,
  }) async {
    log('fetchFeaturedProducts called (loadMore: $loadMore, refresh: $refresh)');
    ResponseModel responseModel = ResponseModel(false, "Unknown error");

    if (refresh) {
      featuredState.reset();
      featuredState.page = 1;
    }

    if (loadMore) {
      if (!featuredState.canLoadMore) {
        return ResponseModel(false, "No more pages");
      }
      // advance page for load more
      featuredState.page += 1;
      featuredState.isMoreLoading = true;
    } else {
      featuredState.isInitialLoading = true;
      featuredState.page = 1;
    }

    update();

    try {
      final response =
          await homeRepo.getFeaturedProducts(page: featuredState.page);

      if (response.statusCode == 200 && response.body['status'] == true) {
        // Parse pagination from response
        final pagination = PaginationModel<ProductModel>.fromJson(
          response.body,
          (json) => ProductModel.fromJson(json),
        );

        // update state
        featuredState.lastPage = pagination.lastPage;
        featuredState.page = pagination.currentPage;

        if (loadMore) {
          // dedupe by id (if your ProductModel has `id`)
          for (final p in pagination.data) {
            if (!featuredState.dedupeIds.contains(p.id)) {
              featuredState.dedupeIds.add(p.id);
              featuredState.items.add(p);
            }
          }
        } else {
          featuredState.items
            ..clear()
            ..addAll(pagination.data);
          featuredState.dedupeIds.clear();
          featuredState.dedupeIds.addAll(pagination.data.map((e) => e.id));
        }

        responseModel = ResponseModel(true, "Fetched featured products");
      } else {
        responseModel =
            ResponseModel(false, response.body['message'] ?? "Failed");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Error: $e");
      log("****** Error ****** $e", name: "fetchFeaturedProducts");
      // if loadMore failed, step back page to avoid skipping
      if (loadMore && featuredState.page > 1) {
        featuredState.page -= 1;
      }
    } finally {
      featuredState.isInitialLoading = false;
      featuredState.isMoreLoading = false;
      update();
    }

    return responseModel;
  }

  List<ProductModel> hotDealsTodayProductList = [];

  Future<ResponseModel> fetchHotDealsTodayProducts() async {
    log('----------- fetchHotDealsTodayProducts Called() -------------');
    ResponseModel responseModel = ResponseModel(false, "Unknown error");
    isLoading = true;
    update();

    try {
      Response response = await homeRepo.fetchHotDealsTodayProducts();

      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['data']['data'] is List) {
        hotDealsTodayProductList = (response.body['data']['data'] as List)
            .map((item) => ProductModel.fromJson(item))
            .toList();

        print("hot deals list : ${hotDealsTodayProductList.length}");
      } else {
        print("No hot deals found or invalid response structure");
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchHotDealsTodayProducts");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  List<ProductModel> searchProductList = [];

  Future<ResponseModel> fetchSearchProduct({required String query}) async {
    log('----------- fetchSearchProduct Called() -------------');
    ResponseModel responseModel = ResponseModel(false, "Unknown error");
    isLoading = true;
    update();

    try {
      Response response = await homeRepo.fetchSearchProduct(query: query);

      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['products'] is List) {
        searchProductList.clear();
        searchProductList = (response.body['products'] as List)
            .map((item) => ProductModel.fromJson(item))
            .toList();

        log("searchProductList list : ${searchProductList.length}");
        responseModel = ResponseModel(
            true, "Successfully fetched fetchSearchProduct products");
      } else {
        log("searchProductList list else : ${searchProductList.length}");

        responseModel = ResponseModel(
          false,
          response.body['error'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Error: $e");
      log("****** Error ****** $e", name: "fetchSearchProduct");
    }

    isLoading = false;
    update();
    return responseModel;
  }
}
