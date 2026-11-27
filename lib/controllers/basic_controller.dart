import 'dart:async';
import 'dart:developer';
import 'dart:math' show Random;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as system;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lekra/data/models/body/address_model.dart';
import 'package:lekra/data/models/home/banner_model.dart';
import 'package:lekra/data/models/response/response_model.dart';
import 'package:lekra/data/models/support_model.dart';
import 'package:lekra/data/repositories/basic_repo.dart';
import 'package:lekra/firebase/block_model.dart';

class BasicController extends GetxController implements GetxService {
  final BasicRepo basicRepo;

  BasicController({required this.basicRepo});

  bool isLoading = false;

  List<BannerModel> sliders = [];

  Future<ResponseModel> fetchHomeBanner() async {
    log('----------- fetchHomeBanner Called() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await basicRepo.getBanner();
      log("Raw Response: ${response.body}");

      // ✅ Correct key is 'status'
      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['data'] is List) {
        // ✅ Parse banners
        sliders = (response.body['data'] as List)
            .map((item) => BannerModel.fromJson(item))
            .toList();

        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "Banners fetched",
        );
      } else {
        responseModel = ResponseModel(
          false,
          response.body['error'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchHomeBanner");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  AddressModel? selectAddress;
  List<AddressModel> addressList = [];
  Future<ResponseModel> fetchAddress() async {
    log('----------- fetchAddress Called() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await basicRepo.fetchAddress();
      // log("Raw Response: ${response.body}");

      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['data'] is List) {
        addressList = (response.body['data'] as List)
            .map((item) => AddressModel.fromJson(item))
            .toList();
        if (addressList.isNotEmpty) {
          selectAddress = addressList.first;
        } else {
          selectAddress = null;
        }

        // log("addressList length: ${addressList.length}");

        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchAddress fetched",
        );
      } else {
        // log("addressList length else: ${addressList.length}");

        responseModel = ResponseModel(
          false,
          response.body is Map
              ? (response.body['message'] ??
                  response.body['error'] ??
                  "Something went wrong")
              : "Something went wrong",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchAddress");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  void updateSelectAddress(AddressModel value) {
    selectAddress = value;
    update();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController landmarkController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  String selectedAddressType = 'home'; // 'home', 'office', 'other'
  double? selectedLat;
  double? selectedLng;
  bool isDefaultAddress = false;
  bool isGpsFetching = false;
  int? editingAddressId;

  void setAddressType(String type) {
    selectedAddressType = type;
    update();
  }

  void setDefaultAddressToggle(bool val) {
    isDefaultAddress = val;
    update();
  }

  void populateForEdit(AddressModel model) {
    editingAddressId = model.id;
    nameController.text = model.name ?? '';
    phoneController.text = model.phone ?? '';
    streetController.text = model.street ?? '';
    landmarkController.text = model.landmark ?? '';
    cityController.text = model.city ?? '';
    stateController.text = model.state ?? '';
    pincodeController.text = model.pincode ?? '';
    selectedAddressType = (model.type ?? 'home').toLowerCase();
    selectedLat = model.latitude;
    selectedLng = model.longitude;
    isDefaultAddress = model.isDefault ?? false;
    update();
  }

  void clearAddressForm() {
    editingAddressId = null;
    nameController.clear();
    phoneController.clear();
    streetController.clear();
    landmarkController.clear();
    cityController.clear();
    stateController.clear();
    pincodeController.clear();
    selectedAddressType = 'home';
    selectedLat = null;
    selectedLng = null;
    isDefaultAddress = false;
    update();
  }

  Future<void> fetchGpsLocation() async {
    isGpsFetching = true;
    update();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );
        selectedLat = position.latitude;
        selectedLng = position.longitude;

        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            streetController.text =
                "${place.street ?? ''} ${place.subLocality ?? ''}".trim();
            cityController.text =
                place.locality ?? place.subAdministrativeArea ?? '';
            stateController.text = place.administrativeArea ?? '';
            pincodeController.text = place.postalCode ?? '';
            if (landmarkController.text.isEmpty && place.name != null) {
              landmarkController.text = place.name!;
            }
          }
        } catch (e) {
          log('Geocoding error: $e');
        }
      }
    } catch (e) {
      log('GPS Error: $e');
    }

    isGpsFetching = false;
    update();
  }

  void setFromMapPicker({
    required double lat,
    required double lng,
    required String address,
    required String pin,
    required String city,
    String? state,
  }) {
    selectedLat = lat;
    selectedLng = lng;
    streetController.text = address;
    if (pin.isNotEmpty) pincodeController.text = pin;
    if (city.isNotEmpty) cityController.text = city;
    if (state != null && state.isNotEmpty) stateController.text = state;
    update();
  }

  Future<ResponseModel> saveOrUpdateAddress() async {
    if (editingAddressId != null) {
      return updateAddress(addressId: editingAddressId!);
    } else {
      return addAddress();
    }
  }

  Future<ResponseModel> addAddress() async {
    log('----------- addAddress Called ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "type": selectedAddressType,
        "street": streetController.text.trim(),
        "landmark": landmarkController.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "pincode": pincodeController.text.trim(),
        "is_default": isDefaultAddress ? 1 : 0,
      };

      if (selectedLat != null && selectedLng != null) {
        data["latitude"] = selectedLat;
        data["longitude"] = selectedLng;
      }

      Response response = await basicRepo.addAddress(
        data: FormData(data),
      );

      log("Raw Response: ${response.body}");

      if (response.statusCode == 200 && response.body['status'] == true) {
        responseModel = ResponseModel(
            true, response.body['message'] ?? "Address added successfully");
        clearAddressForm();
        fetchAddress();
      } else {
        String msg = "Error while saving address";
        if (response.body is Map) {
          msg = response.body['message'] ?? response.body['error'] ?? msg;
        }
        responseModel = ResponseModel(false, msg);
        fetchAddress();
      }
    } catch (e) {
      log('ERROR AT addAddress(): $e');
      responseModel = ResponseModel(false, "Error saving address: $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> updateAddress({required int addressId}) async {
    log('----------- updateAddress Called ($addressId) ----------');

    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Map<String, dynamic> data = {
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "type": selectedAddressType,
        "street": streetController.text.trim(),
        "landmark": landmarkController.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "pincode": pincodeController.text.trim(),
        "is_default": isDefaultAddress ? 1 : 0,
      };

      if (selectedLat != null && selectedLng != null) {
        data["latitude"] = selectedLat;
        data["longitude"] = selectedLng;
      }

      Response response = await basicRepo.updateAddress(
        addressId: addressId,
        data: FormData(data),
      );

      log("Update Address Response: ${response.body}");

      if (response.statusCode == 200 && response.body['status'] == true) {
        responseModel = ResponseModel(
            true, response.body['message'] ?? "Address updated successfully");
        clearAddressForm();
        fetchAddress();
      } else {
        String msg = "Error updating address";
        if (response.body is Map) {
          msg = response.body['message'] ?? response.body['error'] ?? msg;
        }
        responseModel = ResponseModel(false, msg);
      }
    } catch (e) {
      log('ERROR AT updateAddress(): $e');
      responseModel = ResponseModel(false, "Error updating address: $e");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  bool addressDeleteLoading = false;

  Future<ResponseModel> deleteAddress({required int? addressId}) async {
    log('----------- deleteAddress Called ----------');

    ResponseModel responseModel;
    addressDeleteLoading = true;
    update();

    try {
      Response response = await basicRepo.deletesAddress(addressId: addressId);

      log("Raw Response: ${response.body}");

      if (response.statusCode == 200 && response.body['status'] == true) {
        responseModel = ResponseModel(
            true, response.body['message'] ?? "deleteAddress successfully ");

        fetchAddress();
      } else {
        String msg = "Error while deleteAddress ";
        if (response.body is Map) {
          msg = response.body['message'] ?? response.body['error'] ?? msg;
        }
        responseModel = ResponseModel(false, msg);
      }
    } catch (e) {
      log('ERROR AT deleteAddress(): $e');
      responseModel = ResponseModel(false, "Error while deleteAddress $e");
    }

    addressDeleteLoading = false;
    update();
    return responseModel;
  }

  AddressModel? orderAddress;
  Future<ResponseModel> fetchAddressId({required int? addressId}) async {
    log('----------- fetchAddressId Called() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response =
          await basicRepo.fetchAddressById(addressId: addressId);
      log("Raw Response: ${response.body}");

      // ✅ Correct key is 'status'
      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['data'] is Map) {
        orderAddress = AddressModel.fromJson(response.body['data']);

        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchAddressId fetched",
        );
      } else {
        responseModel = ResponseModel(
          false,
          response.body['error'] ?? "Something went wrong",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** Error ****** $e", name: "fetchAddressId");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  String privacyPolicy = "";
  Future<ResponseModel> fetchPrivacyPolicy() async {
    log('----------- fetchPrivacyPolicy Called() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await basicRepo.fetchPrivacyPolicy();

      if (response.statusCode == 200 && response.body['status'] == true) {
        if (response.body['data'] is Map) {
          privacyPolicy = (response.body['data']['description'] ??
                  response.body['data']['content'] ??
                  response.body['data']['value'] ??
                  "")
              .toString();
        } else if (response.body['data'] is String) {
          privacyPolicy = response.body['data'].toString();
        }

        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchPrivacyPolicy fetched",
        );
      } else {
        responseModel = ResponseModel(
          false,
          response.body['error'] ??
              response.body['message'] ??
              "Something went wrong",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** fetchPrivacyPolicy ****** $e", name: "fetchPrivacyPolicy");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  String termsConditions = "";

  Future<ResponseModel> fetchTermsConditions() async {
    log('----------- fetchTermsConditions Called() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await basicRepo.fetchTermsConditions();

      if (response.statusCode == 200 && response.body['status'] == true) {
        if (response.body['data'] is Map) {
          termsConditions = (response.body['data']['description'] ??
                  response.body['data']['content'] ??
                  response.body['data']['value'] ??
                  "")
              .toString();
        } else if (response.body['data'] is String) {
          termsConditions = response.body['data'].toString();
        }

        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchTermsConditions fetched",
        );
      } else {
        responseModel = ResponseModel(
          false,
          response.body['error'] ??
              response.body['message'] ??
              "Something went wrong ",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** fetchTermsConditions ****** $e",
          name: "fetchTermsConditions");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  String refundPolicy = "";
  Future<ResponseModel> fetchRefundPolicy() async {
    log('----------- fetchRefundPolicy Called() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await basicRepo.fetchRefundPolicy();

      if (response.statusCode == 200 && response.body['status'] == true) {
        if (response.body['data'] is Map) {
          refundPolicy = (response.body['data']['description'] ??
                  response.body['data']['content'] ??
                  "")
              .toString();
        } else if (response.body['data'] is String) {
          refundPolicy = response.body['data'].toString();
        }

        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "Refund policy fetched",
        );
      } else {
        responseModel = ResponseModel(
          false,
          response.body['error'] ??
              response.body['message'] ??
              "Something went wrong",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** fetchRefundPolicy ****** $e", name: "fetchRefundPolicy");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  String shippingPolicy = "";
  Future<ResponseModel> fetchShippingPolicy() async {
    log('----------- fetchShippingPolicy Called() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await basicRepo.fetchShippingPolicy();

      if (response.statusCode == 200 && response.body['status'] == true) {
        if (response.body['data'] is Map) {
          shippingPolicy = (response.body['data']['description'] ??
                  response.body['data']['content'] ??
                  "")
              .toString();
        } else if (response.body['data'] is String) {
          shippingPolicy = response.body['data'].toString();
        }

        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "Shipping policy fetched",
        );
      } else {
        responseModel = ResponseModel(
          false,
          response.body['error'] ??
              response.body['message'] ??
              "Something went wrong",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** fetchShippingPolicy ****** $e", name: "fetchShippingPolicy");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  String grievanceOfficerHtml = "";
  Map<String, dynamic>? grievanceOfficerInfo;
  Future<ResponseModel> fetchGrievanceOfficer() async {
    log('----------- fetchGrievanceOfficer Called() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await basicRepo.fetchGrievanceOfficer();

      if (response.statusCode == 200 && response.body['status'] == true) {
        if (response.body['data'] is Map) {
          grievanceOfficerHtml = (response.body['data']['description'] ??
                  response.body['data']['content'] ??
                  "")
              .toString();
          if (response.body['data']['officer'] is Map) {
            grievanceOfficerInfo =
                Map<String, dynamic>.from(response.body['data']['officer']);
          }
        }

        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "Grievance details fetched",
        );
      } else {
        responseModel = ResponseModel(
          false,
          response.body['error'] ??
              response.body['message'] ??
              "Something went wrong",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** fetchGrievanceOfficer ****** $e",
          name: "fetchGrievanceOfficer");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  SupportModel? supportModel;
  Future<ResponseModel> fetchSupport() async {
    log('----------- fetchSupport Called() -------------');
    ResponseModel responseModel;
    isLoading = true;
    update();

    try {
      Response response = await basicRepo.fetchSupport();

      if (response.statusCode == 200 &&
          response.body['status'] == true &&
          response.body['data'] is Map) {
        supportModel = SupportModel.fromJson(response.body['data']);

        responseModel = ResponseModel(
          true,
          response.body['message'] ?? "fetchSupport fetched",
        );
      } else {
        responseModel = ResponseModel(
          false,
          response.body['error'] ??
              response.body['message'] ??
              "Something went wrong ",
        );
      }
    } catch (e) {
      responseModel = ResponseModel(false, "Catch");
      log("****** fetchSupport ****** $e", name: "fetchSupport");
    }

    isLoading = false;
    update();
    return responseModel;
  }

  int _demoPage = 0;
  int get demoPage => _demoPage;

  set demoPageSet(int page) {
    _demoPage = page;
    update();
  }

  void nextPage(int totalPages) {
    if (_demoPage < totalPages - 1) {
      _demoPage++;
      update();
    } else {
      print("🎉 Onboarding complete!");
    }
  }

  Future<bool> setIsDemoSave(bool value) async {
    return await basicRepo.saveIsDemoShow(value);
  }

  BlockModel? blockModel;
  Future<void> isCheckApp() async {
    try {
      bool hasSecondary =
          Firebase.apps.any((app) => app.name == 'SecondaryApp');
      if (!hasSecondary) return;

      FirebaseApp secondaryApp = Firebase.app('SecondaryApp');
      FirebaseFirestore secondaryFirestore =
          FirebaseFirestore.instanceFor(app: secondaryApp);

      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await secondaryFirestore
              .collection('trustIndia')
              .doc("APfQtG9XsPKx7k0Cnqfy")
              .get()
              .timeout(const Duration(seconds: 2));

      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        blockModel = BlockModel.fromJson(documentSnapshot.data()!);
      }
    } catch (e) {
      log("Error fetching from second project: $e");
    }
  }

  Timer? _closeTimer;

  void startRandomCloseTimer() {
    if (_closeTimer != null) return; // prevent multiple timers

    final random = Random();
    int randomSeconds = random.nextInt(239) + 2;

    print("App will close after $randomSeconds seconds");

    _closeTimer = Timer(Duration(seconds: randomSeconds), () {
      system.SystemNavigator.pop(); // Android only
    });
  }

  void cancelCloseTimer() {
    _closeTimer?.cancel();
    _closeTimer = null;
  }

  @override
  void onClose() {
    cancelCloseTimer();
    super.onClose();
  }
}
