import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/data/models/pagination/pagination_model.dart';
import 'package:lekra/data/models/pagination/pagination_state.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/transaction_model.dart.dart';
import 'package:lekra/data/models/wallet_model.dart';
import 'package:lekra/data/repositories/wallet_repo.dart';
import 'package:lekra/views/screens/dashboard/dashboard_screen.dart';

enum WalletFilterType { none, date, amount }

class WalletController extends GetxController implements GetxService {
  final WallerRepo wallerRepo;
  WalletController({required this.wallerRepo});
  bool isLoading = false;

  final PaginationState<TransactionModel> walletTxnState =
      PaginationState<TransactionModel>();

  /// UI should ALWAYS read from this
  List<TransactionModel> get transactionList => walletTxnState.items;

  WalletFilterType _activeFilter = WalletFilterType.none;
  String? _filterValue;

  /// MAIN FUNCTION (use everywhere)
  // Future<ResponseModel> fetchWalletTransaction({
  //   bool refresh = false,
  //   bool loadMore = false,
  //   WalletFilterType filterType = WalletFilterType.none,
  //   String? filterValue,
  // }) async {
  //   try {
  //     if (refresh) {
  //       walletTxnState.reset();
  //     }

  //     if (loadMore) {
  //       if (!walletTxnState.canLoadMore || walletTxnState.isMoreLoading) {
  //         return ResponseModel(false, "No more pages");
  //       }
  //       walletTxnState.page++;
  //       walletTxnState.isMoreLoading = true;
  //     } else {
  //       walletTxnState.isInitialLoading = true;
  //       walletTxnState.page = 1;
  //       _activeFilter = filterType;
  //       _filterValue = filterValue;
  //     }

  //     update(['wallet_txn']);

  //     final Response response = await _fetchByFilter();

  //     if (response.statusCode == 200 && (response.body['status'] == true)) {
  //       // 1. Pass the ENTIRE 'transactions' map to the PaginationModel
  //     final data = response.body['data'] ?? {};

  //       final transactionPagination =
  //           PaginationModel<TransactionModel>.fromJson(
  //         data['transactions'] ?? {},
  //         (json) => TransactionModel.fromJson(json),
  //       );

  //       final addFundList = (data['addfund'] ?? [])
  //           .map<TransactionModel>((e) => TransactionModel.fromJson(e))
  //           .toList();

  //       final rechargeList = (data['recharge'] ?? [])
  //           .map<TransactionModel>((e) => TransactionModel.fromJson(e))
  //           .toList();

  //       final combinedList = [
  //         ...transactionPagination.data,
  //         ...addFundList,
  //         ...rechargeList,
  //       ];

  //       combinedList.sort((a, b) => (b.createdAt ??
  //               DateTime.fromMillisecondsSinceEpoch(0))
  //           .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)));
  //       walletTxnState.lastPage = transactionPagination.lastPage;
  //       walletTxnState.page = transactionPagination.currentPage;

  //       if (loadMore) {
  //         for (final item in combinedList) {
  //           // NOTE: Ensure IDs don't overlap between 'transactions' and 'addfund'
  //           // Consider prefixing IDs if they do (e.g., 'txn_1', 'fund_1')
  //           if (!walletTxnState.dedupeIds.contains(item.id)) {
  //             walletTxnState.dedupeIds.add(item.id!);
  //             walletTxnState.items.add(item);
  //           }
  //         }
  //       } else {
  //         walletTxnState.items
  //           ..clear()
  //           ..addAll(combinedList);

  //         walletTxnState.dedupeIds
  //           ..clear()
  //           ..addAll(combinedList.map((e) => e.id!));
  //       }

  //       return ResponseModel(true, "Success");
  //     }

  //     return ResponseModel(false, "Failed");
  //   } catch (e) {
  //     if (loadMore && walletTxnState.page > 1) {
  //       walletTxnState.page--;
  //     }
  //     return ResponseModel(false, e.toString());
  //   } finally {
  //     walletTxnState.isInitialLoading = false;
  //     walletTxnState.isMoreLoading = false;
  //     update(['wallet_txn']);
  //   }
  // }

  Future<ResponseModel> fetchWalletTransaction({
    bool refresh = false,
    bool loadMore = false,
    WalletFilterType filterType = WalletFilterType.none,
    String? filterValue,
  }) async {
    try {
      /// 🔄 RESET
      if (refresh) {
        walletTxnState.reset();
      }

      /// 📄 PAGINATION CONTROL
      if (loadMore) {
        if (!walletTxnState.canLoadMore || walletTxnState.isMoreLoading) {
          return ResponseModel(false, "No more pages");
        }
        walletTxnState.page++;
        walletTxnState.isMoreLoading = true;
      } else {
        walletTxnState.isInitialLoading = true;
        walletTxnState.page = 1;
        _activeFilter = filterType;
        _filterValue = filterValue;
      }

      update(['wallet_txn']);

      /// 🌐 API CALL
      final Response response = await _fetchByFilter();

      if (response.statusCode == 200 && (response.body['status'] == true)) {
        final data = response.body['data'] ?? {};

        /// 🔹 PAGINATED TRANSACTIONS
        final transactionsMap = data['transactions'] ?? {};

        final transactionPagination =
            PaginationModel<TransactionModel>.fromJson(
          transactionsMap,
          (json) => TransactionModel.fromJson(json),
        );

        /// 🔹 ADD FUND LIST
        final List<TransactionModel> addFundList = (data['addfund'] ?? [])
            .map<TransactionModel>((json) => TransactionModel.fromJson(json))
            .toList();

        /// 🔹 RECHARGE LIST
        final List<TransactionModel> rechargeList = (data['recharge'] ?? [])
            .map<TransactionModel>((json) => TransactionModel.fromJson(json))
            .toList();

        /// 🔥 OPTIONAL: PREVENT ID COLLISION
        List<TransactionModel> prefixList(
            List<TransactionModel> list, String prefix) {
          return list.map((e) {
            return e.copyWith(id: int.tryParse("$prefix${e.id}") ?? e.id);
          }).toList();
        }

        /// 🔹 COMBINE ALL DATA
        final combinedList = [
          ...prefixList(transactionPagination.data, "txn_"),
          ...prefixList(addFundList, "fund_"),
          ...prefixList(rechargeList, "recharge_"),
        ];

        /// 🔽 SORT (LATEST FIRST)
        combinedList.sort((a, b) => (b.createdAt ??
                DateTime.fromMillisecondsSinceEpoch(0))
            .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0)));

        /// 🔄 UPDATE PAGINATION STATE
        walletTxnState.lastPage = transactionPagination.lastPage;
        walletTxnState.page = transactionPagination.currentPage;

        if (loadMore) {
          for (final item in combinedList) {
            if (!walletTxnState.dedupeIds.contains(item.id)) {
              walletTxnState.dedupeIds.add(item.id!);
              walletTxnState.items.add(item);
            }
          }
        } else {
          walletTxnState.items
            ..clear()
            ..addAll(combinedList);

          walletTxnState.dedupeIds
            ..clear()
            ..addAll(combinedList.map((e) => e.id!));
        }

        return ResponseModel(true, "Success");
      }

      return ResponseModel(false, "Failed");
    } catch (e) {
      /// ⛔ ROLLBACK PAGE IF LOAD MORE FAILS
      if (loadMore && walletTxnState.page > 1) {
        walletTxnState.page--;
      }

      return ResponseModel(false, e.toString());
    } finally {
      /// 🔄 STOP LOADING STATES
      walletTxnState.isInitialLoading = false;
      walletTxnState.isMoreLoading = false;

      update(['wallet_txn']);
    }
  }

  /// Filter router (PRIVATE)
  Future<Response> _fetchByFilter() {
    switch (_activeFilter) {
      case WalletFilterType.date:
        return wallerRepo.fetchWalletTransactionByDate(
          date: _filterValue!,
          page: walletTxnState.page,
        );
      case WalletFilterType.amount:
        return wallerRepo.fetchWalletTransactionByAmount(
          amount: _filterValue!,
          page: walletTxnState.page,
        );
      default:
        return wallerRepo.fetchWalletTransaction(
          page: walletTxnState.page,
        );
    }
  }

  WalletModel? walletModel;
  Future<ResponseModel> fetchWallet() async {
    log('----------- fetchWallet Called() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await wallerRepo.fetchWallet();

      if (response.statusCode == 200 && response.body['status'] == true) {
        final Map<String, dynamic> walletData = {};
        if (response.body is Map) {
          walletData.addAll(Map<String, dynamic>.from(response.body));
        }
        if (response.body['data'] is Map) {
          walletData.addAll(Map<String, dynamic>.from(response.body['data']));
        }
        walletModel = WalletModel.fromJson(walletData);
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchWallet fetched",
        );
      } else {
        responseModel = ResponseModel(
          false,
          response.body['error'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchWallet");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  String createWalletPin = "";
  String createWalletPinConfirm = "";

  Future<ResponseModel> postCreateWalletPin() async {
    log('----------- createWalletPin Called() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();
    final data = {
      "wallet_pin": createWalletPin,
      "wallet_pin_confirmation": createWalletPinConfirm,
    };

    try {
      Response response =
          await wallerRepo.createWalletPin(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == true) {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "createWalletPin fetched",
        );
        createWalletPin = "";
        createWalletPinConfirm = "";
      } else {
        responseModel = ResponseModel(
          false,
          response.body['error'] ?? " Something went wrong createWalletPin",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "createWalletPin");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyWalletPin() async {
    log('----------- verifyWalletPin Called() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();
    final data = {
      "old_pin": walletPin,
    };

    try {
      Response response =
          await wallerRepo.verifyWalletPin(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == true) {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "verifyWalletPin fetched",
        );
        walletPin = "";
        log("walletPin = $walletPin");
      } else {
        responseModel = ResponseModel(
          false,
          response.body['error'] ?? " Something went wrong verifyWalletPin",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "verifyWalletPin");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> postWalletReSetPin() async {
    log('----------- postWalletReSetPin Called() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();
    final data = {
      "new_pin": createWalletPin,
      "confirm_pin": createWalletPinConfirm,
    };

    try {
      Response response =
          await wallerRepo.postWalletReSetPin(data: FormData(data));

      if (response.statusCode == 200 && response.body['status'] == true) {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "postWalletReSetPin fetched",
        );
        createWalletPin = "";
        createWalletPinConfirm = "";
      } else {
        responseModel = ResponseModel(
          false,
          response.body['error'] ?? " Something went wrong postWalletReSetPin",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "postWalletReSetPin");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Widget pageFormMove = const DashboardScreen();

  void updatePage(Widget value) {
    pageFormMove = value;
  }

  String walletPin = "";

  TextEditingController walletSearchController = TextEditingController();

  void setWalletSearchController(String value) {
    walletSearchController.text = value;
    update();
  }

  List<TransactionModel> filerTransactionModel = [];
  Future<ResponseModel> fetchWalletTransactionByDate(String date) async {
    log('----------- fetchWalletTransactionByDate Called() -------------');
    ResponseModel responseModel;
    isLoading = true;
    filerTransactionModel.clear();
    update();

    try {
      Response response =
          await wallerRepo.fetchWalletTransactionByDate(date: date);

      if (response.statusCode == 200 && response.body['status'] == true) {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchWalletTransactionByDate fetched",
        );
      } else {
        responseModel = ResponseModel(
          false,
          response.body['error'] ??
              " Something went wrong fetchWalletTransactionByDate",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** fetchWalletTransactionByDate ****** $e",
          name: "fetchWalletTransactionByDate");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> fetchWalletTransactionByAmount(String amount) async {
    log('----------- fetchWalletTransactionByAmount Called() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response =
          await wallerRepo.fetchWalletTransactionByAmount(amount: amount);

      if (response.statusCode == 200 && response.body['status'] == true) {
        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchWalletTransactionByAmount fetched",
        );
      } else {
        responseModel = ResponseModel(
          false,
          response.body['error'] ??
              " Something went wrong fetchWalletTransactionByAmount",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** fetchWalletTransactionByAmount ****** $e",
          name: "fetchWalletTransactionByAmount");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> transferBalance({
    required String target,
    required double amount,
    String? pin,
  }) async {
    isLoading = true;
    update();

    try {
      final response = await wallerRepo.transferWalletBalance(data: {
        'target': target,
        'amount': amount,
        if (pin != null && pin.isNotEmpty) 'pin': pin,
      });

      isLoading = false;
      update();

      if (response.statusCode == 200 && response.body['status'] == true) {
        await fetchWallet();
        await fetchWalletTransaction(refresh: true);
        return ResponseModel(
          true,
          response.body['message'] ?? "Balance transferred successfully.",
        );
      } else {
        return ResponseModel(
          false,
          response.body?['message'] ?? "Failed to transfer balance.",
        );
      }
    } catch (e) {
      isLoading = false;
      update();
      return ResponseModel(false, e.toString());
    }
  }
}
