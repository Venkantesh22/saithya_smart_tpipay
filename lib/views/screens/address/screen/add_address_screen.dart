import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lekra/controllers/basic_controller.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/input_decoration.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/address/screen/location_picker_map_screen.dart';
import 'package:lekra/views/screens/checkout/checkout_screen/components/textbox_title.dart';
import 'package:lekra/views/screens/widget/custom_appbar/custom_appbar2.dart';
import 'package:latlong2/latlong.dart' as ll;

class AddAddressScreen extends StatefulWidget {
  final bool isEdit;
  const AddAddressScreen({super.key, this.isEdit = false});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _fromkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar2(
        title: widget.isEdit ? "Edit Delivery Address" : "Add New Address",
      ),
      body: GetBuilder<BasicController>(builder: (basicController) {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. GPS Auto-Detect Button Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.my_location_rounded,
                                  color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Use Current Location (GPS)",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF1E3A8A),
                                    ),
                                  ),
                                  Text(
                                    "Auto-fill address and detect precise GPS coordinates",
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  onPressed: basicController.isGpsFetching
                                      ? null
                                      : () async {
                                          await basicController
                                              .fetchGpsLocation();
                                          if (basicController.selectedLat !=
                                              null) {
                                            showToast(
                                                message:
                                                    "Location detected successfully!",
                                                typeCheck: true);
                                          }
                                        },
                                  child: basicController.isGpsFetching
                                      ? const SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white),
                                        )
                                      : const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.gps_fixed,
                                                size: 12, color: Colors.white),
                                            SizedBox(width: 4),
                                            Text(
                                              "GPS",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo.shade600,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final result = await Navigator.of(context)
                                        .push<Object?>(
                                      MaterialPageRoute(
                                        builder: (_) => LocationPickerMapScreen(
                                          returnOnly: true,
                                          initialPosition: basicController
                                                          .selectedLat !=
                                                      null &&
                                                  basicController.selectedLng !=
                                                      null
                                              ? ll.LatLng(
                                                  basicController.selectedLat!,
                                                  basicController.selectedLng!,
                                                )
                                              : null,
                                        ),
                                      ),
                                    );

                                    if (!context.mounted) return;

                                    if (result is Map) {
                                      final coordinates = result['latLng'];

                                      final String address =
                                          result['address'] as String? ?? '';

                                      final String pin =
                                          result['pincode'] as String? ?? '';

                                      final String city =
                                          result['city'] as String? ?? '';

                                      if (coordinates is ll.LatLng) {
                                        basicController.setFromMapPicker(
                                          lat: coordinates.latitude,
                                          lng: coordinates.longitude,
                                          address: address,
                                          pin: pin,
                                          city: city,
                                        );

                                        showToast(
                                          message: "Location set from map!",
                                          typeCheck: true,
                                        );
                                      }
                                    }
                                  },
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.map_outlined,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Map",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (basicController.selectedLat != null &&
                            basicController.selectedLng != null) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded,
                                    color: Colors.green, size: 14),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    "GPS Coordinates: ${basicController.selectedLat!.toStringAsFixed(5)}, ${basicController.selectedLng!.toStringAsFixed(5)}",
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 2. Address Details Form Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: black.withOpacity(0.06),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Form(
                      key: _fromkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Address Type Selector (Home, Office, Other)
                          Text(
                            "Address Type",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildTypeChip("home", "Home", Icons.home_rounded,
                                  basicController),
                              const SizedBox(width: 10),
                              _buildTypeChip("office", "Office",
                                  Icons.business_rounded, basicController),
                              const SizedBox(width: 10),
                              _buildTypeChip("other", "Other",
                                  Icons.location_on_rounded, basicController),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // Contact Name & Phone
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextboxWithTitle(
                                  title: "Receiver Name",
                                  controller: basicController.nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter name";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Mobile Number",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller:
                                          basicController.phoneController,
                                      keyboardType: TextInputType.phone,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration:
                                          CustomDecoration.inputDecoration(
                                        hint: "10-digit mobile",
                                        hintStyle: const TextStyle(
                                            fontSize: 13, color: Colors.grey),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.length != 10) {
                                          return "Enter 10-digit phone";
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          CustomTextboxWithTitle(
                            title:
                                "Flat, House no., Building, Company, Apartment *",
                            controller: basicController.streetController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your Street / Flat Address";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          CustomTextboxWithTitle(
                            title: "Landmark (Optional)",
                            controller: basicController.landmarkController,
                            validator: (value) => null,
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: CustomTextboxWithTitle(
                                  title: "City / Town *",
                                  controller: basicController.cityController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter your City";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: CustomTextboxWithTitle(
                                  title: "State *",
                                  controller: basicController.stateController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter State";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Text(
                            "PIN Code (6 digits) *",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: basicController.pincodeController,
                            decoration: CustomDecoration.inputDecoration(
                              hint: "e.g. 400604",
                              hintStyle: const TextStyle(
                                  fontSize: 13, color: Colors.grey),
                            ),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(6),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.length != 6) {
                                return "Pincode should be 6 digits";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),

                          // Default Address Checkbox
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text(
                              "Set as Default Delivery Address",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            value: basicController.isDefaultAddress,
                            activeColor: primaryColor,
                            onChanged: (val) =>
                                basicController.setDefaultAddressToggle(val),
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: basicController.isLoading
                                  ? null
                                  : () async {
                                      if (_fromkey.currentState?.validate() ??
                                          false) {
                                        final res = await basicController
                                            .saveOrUpdateAddress();
                                        showToast(
                                            message: res.message,
                                            typeCheck: res.isSuccess);
                                        if (res.isSuccess) {
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                              child: Text(
                                widget.isEdit
                                    ? "Update Address"
                                    : "Save Delivery Address",
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (basicController.isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black26,
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildTypeChip(
      String key, String label, IconData icon, BasicController controller) {
    final isSelected = controller.selectedAddressType == key;
    return Expanded(
      child: InkWell(
        onTap: () => controller.setAddressType(key),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor.withOpacity(0.1)
                : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 14,
                  color: isSelected ? primaryColor : Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? primaryColor : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
