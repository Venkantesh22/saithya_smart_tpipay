import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/data/models/transaction_model.dart.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/dashboard/wallet/create_wallet_pin_screen/wallet_create_pin_screen.dart';
import 'package:lekra/views/screens/dashboard/wallet/wallet_screen/components/profile-balalnce_section.dart';
import 'package:lekra/views/screens/dashboard/wallet/wallet_screen/components/row_of_search_add_fund_section.dart';
import 'package:lekra/views/screens/dashboard/wallet/wallet_screen/components/transaction_container.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool isWallPinCreate = true;
  final ScrollController _scrollController = ScrollController();
  String selectedTxFilter = 'all';

  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<WalletController>().fetchWallet().then((value) {
        if (value.isSuccess) {
          Get.find<WalletController>().fetchWalletTransaction();
          setState(() {
            isWallPinCreate = false;
          });
        } else {
          Get.find<WalletController>().updatePage(const WalletScreen());
          navigate(context: context, page: const WalletCreatePinScreen());
        }
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "My Wallet",
            style: Helper(context).textTheme.titleSmall?.copyWith(fontSize: 16),
          ),
          centerTitle: true,
          actions: [
            TextButton.icon(
              onPressed: () {
                navigate(
                  context: context,
                  page: const WalletCreatePinScreen(isForResetPin: true),
                );
              },
              icon: const Icon(Icons.lock_reset, size: 16, color: primaryColor),
              label: const Text(
                "Change PIN",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: isWallPinCreate
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                controller: _scrollController,
                padding: AppConstants.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProfileBalanceSection(),
                    const SizedBox(
                      height: 16,
                    ),
                    const RowOFSearchAndAddFundButtonSection(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Recent Transactions",
                              style:
                                  Helper(context).textTheme.titleSmall?.copyWith(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Quick filter chips (All, Credits, Debits, Subscriptions)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildChip('all', 'All'),
                              _buildChip('credit', 'Credits (+)'),
                              _buildChip('debit', 'Debits (-)'),
                              _buildChip('subscription', 'Subscriptions'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        GetBuilder<WalletController>(
                          id: 'wallet_txn',
                          builder: (walletController) {
                            final state = walletController.walletTxnState;
                            final rawItems = walletController.transactionList;
                            final items = _filterList(rawItems);

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
                                if (state.isMoreLoading &&
                                    index == items.length) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Center(
                                        child: CircularProgressIndicator()),
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
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildChip(String key, String label) {
    final isSelected = selectedTxFilter == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedTxFilter = key;
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? primaryColor : const Color(0xFFE2E8F0),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }

  List<TransactionModel> _filterList(List<TransactionModel> list) {
    if (selectedTxFilter == 'all') return list;
    if (selectedTxFilter == 'credit') {
      return list.where((tx) => (tx.type ?? '').toLowerCase() == 'credit').toList();
    }
    if (selectedTxFilter == 'debit') {
      return list.where((tx) => (tx.type ?? '').toLowerCase() == 'debit').toList();
    }
    if (selectedTxFilter == 'subscription') {
      return list.where((tx) {
        final prod = (tx.product ?? '').toLowerCase();
        final desc = (tx.description ?? '').toLowerCase();
        return prod.contains('subscription') ||
            desc.contains('subscription') ||
            desc.contains('membership');
      }).toList();
    }
    return list;
  }
}
