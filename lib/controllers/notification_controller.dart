import 'dart:developer';
import 'package:get/get.dart';
import 'package:lekra/data/models/notification/notification_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/repositories/notification_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationRepo notificationRepo;
  final SharedPreferences sharedPreferences;

  NotificationController({
    required this.notificationRepo,
    required this.sharedPreferences,
  });

  static const String _readIdsKey = 'read_notification_ids_set';

  List<NotificationModel> notifications = [];
  bool isLoading = false;
  int unreadCount = 0;

  Future<ResponseModel> fetchNotifications({bool showLoading = true}) async {
    if (showLoading) {
      isLoading = true;
      update();
    }

    ResponseModel responseModel = ResponseModel(false, "Unknown error");

    try {
      final response = await notificationRepo.fetchNotifications();
      if (response.statusCode == 200 && response.body['status'] == true) {
        final rawData = response.body['data'];
        if (rawData is List) {
          final readIds = (sharedPreferences.getStringList(_readIdsKey) ?? []).toSet();

          notifications = rawData.map((item) {
            final model = NotificationModel.fromJson(item);
            if (model.id != null && readIds.contains(model.id)) {
              model.isRead = true;
            }
            return model;
          }).toList();

          unreadCount = notifications.where((n) => !n.isRead).length;
          responseModel = ResponseModel(true, "Notifications fetched successfully");
        }
      } else {
        responseModel = ResponseModel(
          false,
          response.body['message'] ?? "Failed to fetch notifications",
        );
      }
    } catch (e) {
      log("Error fetching notifications: $e", name: "NotificationController");
      responseModel = ResponseModel(false, e.toString());
    } finally {
      isLoading = false;
      update();
    }

    return responseModel;
  }

  void markAllAsRead() {
    final readIds = (sharedPreferences.getStringList(_readIdsKey) ?? []).toSet();
    for (var n in notifications) {
      if (n.id != null) {
        readIds.add(n.id!);
      }
      n.isRead = true;
    }
    sharedPreferences.setStringList(_readIdsKey, readIds.toList());
    unreadCount = 0;
    update();
  }

  void markAsRead(String id) {
    final readIds = (sharedPreferences.getStringList(_readIdsKey) ?? []).toSet();
    readIds.add(id);
    sharedPreferences.setStringList(_readIdsKey, readIds.toList());

    for (var n in notifications) {
      if (n.id == id) {
        n.isRead = true;
        break;
      }
    }
    unreadCount = notifications.where((n) => !n.isRead).length;
    update();
  }
}
