import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/data/models/transaction_model.dart.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/wallet/wallet_screen/components/transaction_container.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final ScrollController _scrollController = ScrollController();

  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<WalletController>().fetchWallet().then((value) {
        Get.find<WalletController>().fetchWalletTransaction();
      });
      Get.find<WalletController>().walletSearchController.clear();
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final controller = Get.find<WalletController>();
    final state = controller.walletTxnState;

    if (_scrollController.position.extentAfter < 300 &&
        !state.isMoreLoading &&
        state.canLoadMore) {
      controller.fetchWalletTransaction(loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: white,
      onRefresh: () async {
        final res = await Get.find<WalletController>()
            .fetchWalletTransaction(refresh: true);
        Get.find<WalletController>().fetchWallet();
        // Optionally show a snackbar on failure
        if (!res.isSuccess) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res.message)),
          );
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: const CustomAppBar2(
            title: "All Transactions",
            centerTitle: false,
          ),
          // appBar: AppBar(
          //   backgroundColor: Colors.transparent,
          //   actions: [
          //     PopupMenuButton<String>(
          //       icon: const Icon(Icons.more_vert, color: black),
          //       onSelected: (value) {
          //         if (value == 'change_pin') {
          //           navigate(
          //               context: context,
          //               page: const WalletEnterPinScreen(
          //                 isForResetPin: true,
          //               ));
          //         }
          //       },
          //       itemBuilder: (BuildContext context) {
          //         return [
          //           const PopupMenuItem<String>(
          //             value: 'change_pin',
          //             child: Text('Change Wallet PIN'),
          //           ),
          //         ];
          //       },
          //     ),
          //   ],
          // ),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: AppConstants.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GetBuilder<WalletController>(
                      id: 'wallet_txn',
                      builder: (walletController) {
                        final state = walletController.walletTxnState;
                        final items = walletController.transactionList;

                        // 1️⃣ FIRST LOAD → shimmer list
                        if (state.isInitialLoading) {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            itemBuilder: (_, __) {
                              return CustomShimmer(
                                isLoading: true,
                                child: TransactionsContainer(
                                  transactionModel: TransactionModel(),
                                ),
                              );
                            },
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                          );
                        }

                        // 2️⃣ EMPTY STATE
                        if (items.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                "No transactions found",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        }

                        // 3️⃣ DATA + PAGINATION
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              items.length + (state.isMoreLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            // pagination loader (bottom)
                            if (state.isMoreLoading && index == items.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }

                            return TransactionsContainer(
                              transactionModel: items[index],
                            );
                          },
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
