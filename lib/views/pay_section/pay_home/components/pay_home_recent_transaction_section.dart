import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/wallet_controller.dart';
import 'package:lekra/data/models/transaction_model.dart.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/common_button.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/pay_section/transaction_screen.dart/transaction_screen.dart';
import 'package:lekra/views/screens/dashboard/wallet/wallet_screen/components/transaction_container.dart';

class PayHomeRecentTransactionSection extends StatelessWidget {
  const PayHomeRecentTransactionSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Recent Transaction",
                  overflow: TextOverflow.ellipsis,
                  style: Helper(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              GetBuilder<WalletController>(builder: (walletController) {
                return walletController.transactionList.isNotEmpty
                    ? CustomButton(
                        onTap: () {
                          navigate(
                              context: context,
                              page: const TransactionScreen());
                        },
                        color: white,
                        borderColor: primaryColor,
                        radius: 100,
                        child: Row(
                          children: [
                            Text(
                              "view all",
                              style: Helper(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: primaryColor),
                            ),
                            const SizedBox(width: 6),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: primaryColor,
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: white,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox();
              })
            ],
          ),
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
                  padding: EdgeInsets.zero,
                  itemCount: 4,
                  itemBuilder: (_, __) {
                    return CustomShimmer(
                      isLoading: true,
                      child: TransactionsContainer(
                        transactionModel: TransactionModel(),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                );
              }

              // 2️⃣ EMPTY STATE
              if (items.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 60),
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
                itemCount: items.length + (state.isMoreLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  // pagination loader (bottom)
                  if (state.isMoreLoading && index == items.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return TransactionsContainer(
                    transactionModel: items[index],
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
              );
            },
          ),
        ],
      ),
    );
  }
}
