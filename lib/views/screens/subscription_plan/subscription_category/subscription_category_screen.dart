import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/subscription_controller.dart';
import 'package:lekra/data/models/subscription_cate_model.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/shimmer.dart';
import 'package:lekra/views/screens/subscription_plan/subscription_history/subscription_history_screen/subscription_history_screen.dart';
import 'package:lekra/views/screens/subscription_plan/subscription_category/component/subscription_category_container.dart';
import 'package:lekra/views/screens/subscription_plan/subscrption_screen/subscription_plan_screen.dart';
import 'package:page_transition/page_transition.dart';

class SubscriptionCategoryPlan extends StatefulWidget {
  const SubscriptionCategoryPlan({super.key});

  @override
  State<SubscriptionCategoryPlan> createState() =>
      _SubscriptionCategoryPlanState();
}

class _SubscriptionCategoryPlanState extends State<SubscriptionCategoryPlan> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<SubscriptionController>().fetchSubscriptionCatePlan();
      Get.find<SubscriptionController>().fetchSubscriptionHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Subscription Plans",
          style: Helper(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Get.back();
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: black,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'History',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SubscriptionHistoryScreen()));
            },
            icon: const Icon(
              Icons.history,
              color: black,
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: AppConstants.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<SubscriptionController>(
              builder: (subscriptionController) {
                final active = subscriptionController.activeSubscription;
                if (active == null) return const SizedBox.shrink();

                final remDays = active.remainingDays ?? 30;
                final endDateStr = active.endDate != null
                    ? "${active.endDate!.day}/${active.endDate!.month}/${active.endDate!.year}"
                    : "Active";

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4338CA).withValues(alpha: 0.3),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBBF24),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, size: 13, color: Color(0xFF78350F)),
                                SizedBox(width: 4),
                                Text(
                                  "ACTIVE PLAN",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                    color: Color(0xFF78350F),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "$remDays Days Left",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        active.planName ?? "VIP Membership Pass",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Valid till: $endDateStr",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, size: 14, color: Color(0xFF34D399)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                active.features.isNotEmpty
                                    ? active.features.first
                                    : "Zero Delivery Fees on eligible orders & extra cashback",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SubscriptionHistoryScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long, size: 14, color: Color(0xFF312E81)),
                              SizedBox(width: 6),
                              Text(
                                "View Active Plan & Invoices",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF312E81),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            GetBuilder<SubscriptionController>(
                builder: (subscriptionController) {
              if (!subscriptionController.isLoading &&
                  subscriptionController.subscriptionCateList.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.category_outlined,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          "No subscription categories available",
                          style: Helper(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final subscriptionCategoryModel = subscriptionController
                            .isLoading
                        ? SubscriptionCategoryModel()
                        : subscriptionController.subscriptionCateList[index];
                    return CustomShimmer(
                      isLoading: subscriptionController.isLoading,
                      child: SubscriptionCategoryContainer(
                          onPressed: () {
                            if (subscriptionController.isLoading) {
                              return;
                            }
                            subscriptionController
                                .updateSelectSubscriptionCategoryModel(
                                    subscriptionCategoryModel);
                            navigate(
                                type: PageTransitionType.rightToLeft,
                                context: context,
                                page: SubscriptionPlanScreen(
                                  subscriptionPlanName:
                                      subscriptionCategoryModel.name,
                                ));
                          },
                          subscriptionCategoryModel: subscriptionCategoryModel),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: subscriptionController.isLoading
                      ? 2
                      : subscriptionController.subscriptionCateList.length);
            })
          ],
        ),
      ),
    );
  }
}
