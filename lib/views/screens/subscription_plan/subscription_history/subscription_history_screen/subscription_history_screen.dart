import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/subscription_controller.dart';
import 'package:lekra/data/models/subscription/subscription_history_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/subscription_plan/subscription_history/subscription_history_details/subscription_history_details_screen.dart';
import 'package:lekra/views/screens/subscription_plan/subscription_history/subscription_history_screen/components/subscription_history_widget.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';

class SubscriptionHistoryScreen extends StatefulWidget {
  const SubscriptionHistoryScreen({super.key});

  @override
  State<SubscriptionHistoryScreen> createState() =>
      _SubscriptionHistoryScreenState();
}

class _SubscriptionHistoryScreenState extends State<SubscriptionHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SubscriptionController>().fetchSubscriptionHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar2(
        title: "Subscription History",
      ),
      body:
          GetBuilder<SubscriptionController>(builder: (subscriptionController) {
        if (!subscriptionController.isLoading &&
            subscriptionController.subscriptionHistoryModelList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history_toggle_off_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    "No subscription history found",
                    style: Helper(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "You haven't subscribed to any membership yet",
                    style: Helper(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }
        return SingleChildScrollView(
          padding: AppConstants.screenPadding,
          child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final subscriptionHistoryModel =
                    subscriptionController.isLoading
                        ? SubscriptionHistoryModel()
                        : subscriptionController
                            .subscriptionHistoryModelList[index];
                return GestureDetector(
                  onTap: () {
                    if (subscriptionController.isLoading) {
                      return;
                    }
                    subscriptionController.updateSubscriptionHistoryModel(
                        value: subscriptionHistoryModel);
                    navigate(
                      context: context,
                      page: const SubscriptionHistoryDetailsScreen(),
                    );
                  },
                  child: CustomShimmer(
                    isLoading: subscriptionController.isLoading,
                    child: SubscriptionHistoryWidget(
                      subscriptionHistoryModel: subscriptionHistoryModel,
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemCount: subscriptionController.isLoading
                  ? 4
                  : subscriptionController.subscriptionHistoryModelList.length),
        );
      }),
    );
  }
}
