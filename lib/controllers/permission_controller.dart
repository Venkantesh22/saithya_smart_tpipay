import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:permission_handler/permission_handler.dart';

import '../views/base/dialogs/request_permission_dialog.dart';

class PermissionController extends GetxController implements GetxService {
  Future<bool> getPermission(
      Permission permission, BuildContext context) async {
    PermissionStatus? status;
    await (Future.value(
            await permission.isGranted || await permission.isLimited))
        .then((value) async {
      if (!value) {
        bool result = await showDialog(
              context: context,
              builder: (context) => RequestPermissionDialog(
                permission: permission.toString().split('.').last.toString(),
              ),
            ) ??
            false;
        if (result) {
          status = await permission.request();
        }
        log("-----$status-----", name: permission.toString());
      } else {
        log("-----Granted-----", name: permission.toString());
      }
    });

    bool isGranted = permission == Permission.photos
        ? (await permission.isLimited || await permission.isGranted)
        : await permission.isGranted;
    return Future.value(isGranted);
  }

  Future<bool> askWithDialogIfPermanentlyDenied() async {
    final granted = await checkAndRequestContactsPermission();
    if (granted) return true;

    final status = await Permission.contacts.status;
    if (status.isPermanentlyDenied) {
      await Get.defaultDialog(
        title: 'Permission required',
        middleText:
            'Please enable Contacts permission from app settings to pick a number.',
        textConfirm: 'Open Settings',
        textCancel: 'Cancel',
        onConfirm: () {
          openAppSettings();
          Get.back(); // close dialog
        },
      );
    }
    return false;
  }

  Future<bool> checkAndRequestContactsPermission() async {
    try {
      final status = await Permission.contacts.status;

      if (status.isGranted) {
        return true;
      }

      if (status.isDenied) {
        final result = await Permission.contacts.request();
        return result.isGranted;
      }

      if (status.isPermanentlyDenied) {
        // Open app settings so user can enable permission manually.
        // You can show a dialog before opening settings.
        final opened = await openAppSettings();
        log('Opened app settings: $opened');
        return false;
      }

      // handle restricted / limited (iOS) case
      if (status.isRestricted || status.isLimited) {
        // attempt request anyway
        final result = await Permission.contacts.request();
        return result.isGranted;
      }

      // default: ask
      final result = await Permission.contacts.request();
      return result.isGranted;
    } catch (e) {
      log('Error requesting contacts permission: $e');
      return false;
    }
  }
}
