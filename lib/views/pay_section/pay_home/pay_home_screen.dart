import 'package:flutter/material.dart';
import 'package:lekra/views/pay_section/pay_home/components/pay_home_recent_transaction_section.dart';
import 'package:lekra/views/pay_section/pay_home/components/pay_home_top_section.dart';
import 'package:lekra/views/pay_section/pay_home/components/recharge_and_bills_section.dart';

class PayHomeScreen extends StatefulWidget {
  const PayHomeScreen({super.key});

  @override
  State<PayHomeScreen> createState() => _PayHomeScreenState();
}

class _PayHomeScreenState extends State<PayHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PayTopSection(),
            RechargeAndBillsSection(),
            PayHomeRecentTransactionSection()
          ],
        ),
      ),
    );
  }
}
