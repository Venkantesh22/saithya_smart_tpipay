import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/subscription_controller.dart';
import 'package:lekra/data/models/subscription_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/views/base/custom_refresh_indicator.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/subscription_plan/subscription_details_screen/subscription_details_screen.dart';
import 'package:lekra/views/screens/subscription_plan/subscrption_screen/components/subscription_container.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';
import 'package:page_transition/page_transition.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  final String? subscriptionPlanName;
  const SubscriptionPlanScreen({super.key, required this.subscriptionPlanName});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SubscriptionController>().fetchSubscriptionPlanById();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar2(title: widget.subscriptionPlanName ?? ""),
      body: CustomRefresh(
        onRefresh: () async {
          await Get.find<SubscriptionController>().fetchSubscriptionPlanById();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppConstants.screenPadding,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: GetBuilder<SubscriptionController>(
                  builder: (subscriptionController) {
                    if (!subscriptionController.isLoading &&
                        subscriptionController.subscriptionList.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 80),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.card_membership_outlined,
                                  size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              Text(
                                "No subscription packages available",
                                style: Helper(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Please check back later or pull down to refresh",
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
                    return ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final subscription = subscriptionController.isLoading
                            ? SubscriptionModel()
                            : subscriptionController.subscriptionList[index];

                        return CustomShimmer(
                          isLoading: subscriptionController.isLoading,
                          child: SubscriptionContainer(
                            onPressed: () {
                              if (subscriptionController.isLoading) {
                                return;
                              }

                              navigate(
                                type: PageTransitionType.rightToLeft,
                                context: context,
                                page: SubscriptionDetailsScreen(
                                  subscriptionId: subscription.id,
                                ),
                              );
                            },
                            subscription: subscription,
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemCount: subscriptionController.isLoading
                          ? 2
                          : subscriptionController.subscriptionList.length,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
