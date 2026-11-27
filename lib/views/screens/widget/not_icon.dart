import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/notification_controller.dart';
import 'package:lekra/data/models/notification/notification_model.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/base/custom_image.dart';

class NotIcon extends StatelessWidget {
  const NotIcon({super.key});

  void _showNotificationsSheet(BuildContext context) {
    if (Get.isRegistered<NotificationController>()) {
      Get.find<NotificationController>().fetchNotifications(showLoading: false);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Notifications",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GetBuilder<NotificationController>(
                          builder: (controller) {
                            if (controller.unreadCount <= 0) {
                              return const SizedBox.shrink();
                            }
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "${controller.unreadCount}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    GetBuilder<NotificationController>(
                      builder: (controller) {
                        return TextButton(
                          onPressed: () {
                            controller.markAllAsRead();
                            Get.snackbar(
                              "Notifications",
                              "All notifications marked as read",
                              backgroundColor: Colors.white,
                              colorText: Colors.black,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          child: const Text(
                            "Mark all read",
                            style: TextStyle(fontSize: 12, color: primaryColor),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: GetBuilder<NotificationController>(
                  builder: (controller) {
                    if (controller.isLoading && controller.notifications.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (controller.notifications.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.notifications_none_rounded,
                                  size: 36,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "No new notifications",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Marketing promotions, offers, and order updates will appear right here.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => controller.fetchNotifications(showLoading: false),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        itemCount: controller.notifications.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = controller.notifications[index];
                          return _buildNotificationCard(context, controller, item);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationCard(
    BuildContext context,
    NotificationController controller,
    NotificationModel item,
  ) {
    IconData iconData = Icons.campaign_rounded;
    Color iconColor = Colors.blue.shade700;
    String tagLabel = "Announcement";
    Color tagBg = Colors.blue.shade50;
    Color tagText = Colors.blue.shade700;

    if (item.type == 'promotion' || (item.imageUrl != null && item.imageUrl!.isNotEmpty)) {
      iconData = Icons.local_offer_rounded;
      iconColor = Colors.amber.shade800;
      tagLabel = "Special Promotion";
      tagBg = Colors.amber.shade50;
      tagText = Colors.amber.shade900;
    } else if (item.type == 'order') {
      iconData = Icons.shopping_bag_rounded;
      iconColor = Colors.green.shade700;
      tagLabel = "Order Update";
      tagBg = Colors.green.shade50;
      tagText = Colors.green.shade800;
    }

    return InkWell(
      onTap: () {
        if (item.id != null && !item.isRead) {
          controller.markAsRead(item.id!);
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.grey.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: item.isRead ? Colors.grey.shade200 : primaryColor.withValues(alpha: 0.35),
            width: item.isRead ? 1 : 1.2,
          ),
          boxShadow: item.isRead
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(iconData, color: iconColor, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: tagBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              tagLabel,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: tagText,
                              ),
                            ),
                          ),
                          Text(
                            item.timeAgo ?? "",
                            style: TextStyle(
                              fontSize: 10.5,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.title ?? "",
                        style: TextStyle(
                          fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                          fontSize: 13.5,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!item.isRead) ...[
                  const SizedBox(width: 6),
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
            if (item.message != null && item.message!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 38),
                child: Text(
                  item.message!,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
            if (item.imageUrl != null && item.imageUrl!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 38),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CustomImage(
                    path: item.imageUrl!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(
      builder: (controller) {
        final hasUnread = controller.unreadCount > 0;
        return InkWell(
          onTap: () => _showNotificationsSheet(context),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                const CustomImage(
                  path: Assets.imagesNotification,
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                ),
                if (hasUnread)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Text(
                        controller.unreadCount > 9 ? "9+" : "${controller.unreadCount}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
