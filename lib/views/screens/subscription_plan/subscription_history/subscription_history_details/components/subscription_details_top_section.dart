import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/subscription_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/subscription_plan/subscription_history/subscription_history_details/components/row_of_subscription_details.dart';
import 'package:lekra/views/screens/subscription_plan/subscription_history/subscription_history_screen/components/subscription_status_container.dart';

class SubscriptionDetailsTopSection extends StatelessWidget {
  const SubscriptionDetailsTopSection({super.key});

  Future copyText({required String text, required BuildContext context}) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      showToast(message: "Copied: $text", toastType: ToastType.info);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(
      builder: (controller) {
        final model = controller.selectSubscriptionHistoryModel;
        final planName = model?.effectivePlanName ?? "VIP Membership";
        final txnId = (model?.paymentReference?.isNotEmpty == true)
            ? model!.paymentReference!
            : (model?.subscriptionId != null ? "SUB-REF-${model!.subscriptionId}" : "TXN-PAID");
        final dateStr = model?.createdDateFormat ?? model?.startDateFormat ?? "";
        final paymentStatus = model?.paymentStatus ?? (model?.isActive == true ? "Paid" : "Completed");

        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            color: white,
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 2),
                blurRadius: 8,
                color: black.withValues(alpha: 0.03),
              ),
            ],
          ),
          child: Column(
            children: [
              RowOfSubscriptionDetails(
                label: planName,
                value: SubscriptionStatusContainer(
                  isActive: model?.isActive ?? true,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(color: Color(0xFFF1F5F9), height: 1),
              ),
              RowOfSubscriptionDetails(
                label: "Transaction ID",
                value: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      txnId,
                      style: Helper(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color: const Color(0xFF475569),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                      tooltip: "Copy ID",
                      onPressed: () {
                        copyText(text: txnId, context: context);
                      },
                      icon: const Icon(
                        Icons.copy_rounded,
                        size: 16,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(color: Color(0xFFF1F5F9), height: 1),
              ),
              RowOfSubscriptionDetails(
                label: "Date & Time",
                value: Text(
                  dateStr,
                  style: Helper(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(
                        color: const Color(0xFF475569),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Divider(color: Color(0xFFF1F5F9), height: 1),
              ),
              RowOfSubscriptionDetails(
                label: "Payment Status",
                value: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Text(
                    paymentStatus,
                    style: const TextStyle(
                      color: Color(0xFF059669),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
