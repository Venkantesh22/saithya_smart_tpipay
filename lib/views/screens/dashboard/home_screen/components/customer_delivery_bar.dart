import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/location_controller.dart';
import 'package:lekra/services/theme.dart';
import 'location_selection_bottom_sheet.dart';

class CustomerDeliveryBar extends StatelessWidget {
  const CustomerDeliveryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (locCtrl) {
        String displayArea = "Select Location";
        if (locCtrl.pincode != null && locCtrl.pincode!.isNotEmpty) {
          if (locCtrl.city != null && locCtrl.city!.isNotEmpty) {
            displayArea = "${locCtrl.city} (${locCtrl.pincode})";
          } else {
            displayArea = "PIN: ${locCtrl.pincode}";
          }
        } else if (locCtrl.userLocation != 'Select Delivery Location') {
          displayArea = locCtrl.userLocation;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => showLocationSelectionBottomSheet(context),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withValues(alpha: 0.08),
                    const Color(0xFFEFF6FF),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Deliver to",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                displayArea,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        Text(
                          locCtrl.isGpsActive
                              ? "GPS Active • Showing nearby stores & instant delivery"
                              : "Tap to change PIN code, map or address",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue.shade900.withValues(alpha: 0.7),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bolt, size: 12, color: primaryColor),
                        const SizedBox(width: 2),
                        Text(
                          "Nearby",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
