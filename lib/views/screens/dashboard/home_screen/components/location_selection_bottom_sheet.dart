import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/controllers/location_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/address/screen/add_address_screen.dart';
import 'package:lekra/views/screens/address/screen/location_picker_map_screen.dart';

void showLocationSelectionBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const LocationSelectionBottomSheet(),
  );
}

class LocationSelectionBottomSheet extends StatefulWidget {
  const LocationSelectionBottomSheet({super.key});

  @override
  State<LocationSelectionBottomSheet> createState() =>
      _LocationSelectionBottomSheetState();
}

class _LocationSelectionBottomSheetState
    extends State<LocationSelectionBottomSheet> {
  final TextEditingController _pinController = TextEditingController();
  bool _isPinSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final loc = Get.find<LocationController>();
      if (loc.pincode != null) {
        _pinController.text = loc.pincode!;
      }
      // Refresh saved addresses
      if (Get.isRegistered<BasicController>()) {
        Get.find<BasicController>().fetchAddress();
      }
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            const SizedBox(height: 10),
            Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 14),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    "Choose Delivery Location",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close,
                        size: 22, color: Colors.black54),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                children: [
                  // 1. Current GPS Location Action Card
                  GetBuilder<LocationController>(builder: (locCtrl) {
                    return InkWell(
                      onTap: locCtrl.isLoading
                          ? null
                          : () async {
                              final success =
                                  await locCtrl.fetchCurrentGPSLocation();
                              if (success && mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Color(0xFF2563EB),
                                shape: BoxShape.circle,
                              ),
                              child: locCtrl.isLoading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Icon(Icons.my_location,
                                      color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Use Current GPS Location",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF1E3A8A)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    locCtrl.isGpsActive
                                        ? "Currently active: ${locCtrl.userLocation}"
                                        : "Auto-detect via satellite GPS for fast local delivery",
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.blue.shade900
                                            .withValues(alpha: 0.7)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right,
                                color: Color(0xFF2563EB)),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 12),

                  // 2. Interactive OpenStreetMap Action Card
                  InkWell(
                    onTap: () {
                      // Keep the NavigatorState before closing the bottom sheet.
                      // This avoids using the bottom-sheet context after pop.
                      final navigator = Navigator.of(context);
                      navigator.pop();
                      navigator.push(
                        MaterialPageRoute<void>(
                          builder: (_) => const LocationPickerMapScreen(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xFFECFDF5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.map_rounded,
                                color: Color(0xFF059669), size: 18),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Select on Map",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black87),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Drag pin to choose exact delivery doorstep",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // 3. PIN Code Input Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Enter Delivery PIN Code",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 44,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: TextField(
                                  controller: _pinController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  decoration: const InputDecoration(
                                    hintText: "Enter 6-digit PIN (e.g. 452001)",
                                    hintStyle: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                    counterText: "",
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 44,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  elevation: 0,
                                ),
                                onPressed: _isPinSubmitting
                                    ? null
                                    : () async {
                                        if (_pinController.text.trim().length !=
                                            6) {
                                          showToast(
                                              message:
                                                  "Please enter a valid 6-digit PIN",
                                              typeCheck: false);
                                          return;
                                        }
                                        setState(() => _isPinSubmitting = true);
                                        await Get.find<LocationController>()
                                            .setPinCode(
                                                _pinController.text.trim());
                                        setState(
                                            () => _isPinSubmitting = false);
                                        if (mounted)
                                          Navigator.of(context).pop();
                                      },
                                child: _isPinSubmitting
                                    ? const SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white),
                                      )
                                    : const Text(
                                        "Apply",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. Saved Addresses Header & List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Saved Addresses",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          navigate(
                              context: context, page: const AddAddressScreen());
                        },
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text("Add New",
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  GetBuilder<BasicController>(builder: (basic) {
                    if (basic.isLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }

                    if (basic.addressList.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: const Text(
                          "No saved addresses found. Add an address to save it for quick checkout.",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return Column(
                      children: basic.addressList.map((addr) {
                        final String title = addr.type?.isNotEmpty == true
                            ? addr.type!.toUpperCase()
                            : "SAVED ADDRESS";
                        final String fullText =
                            "${addr.street ?? ''}, ${addr.city ?? ''} - ${addr.pincode ?? ''}"
                                .trim();
                        final String pin = addr.pincode ?? '';
                        final double? lat = addr.latitude != null
                            ? double.tryParse(addr.latitude.toString())
                            : null;
                        final double? lng = addr.longitude != null
                            ? double.tryParse(addr.longitude.toString())
                            : null;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 4),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryColor.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                title.contains("HOME")
                                    ? Icons.home
                                    : (title.contains("WORK")
                                        ? Icons.work
                                        : Icons.location_on),
                                color: primaryColor,
                                size: 18,
                              ),
                            ),
                            title: Text(
                              title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            subtitle: Text(
                              fullText,
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey.shade700),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios,
                                size: 14, color: Colors.grey),
                            onTap: () {
                              Get.find<LocationController>()
                                  .setFromSavedAddress(
                                addressText: fullText,
                                pin: pin,
                                cityName: addr.city,
                                latitude: lat,
                                longitude: lng,
                              );
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
