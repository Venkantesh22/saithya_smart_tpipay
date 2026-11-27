import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api/api_client.dart';
import '../services/constants.dart';
import 'home_controller.dart';

/// Manages the user's selected delivery location.
///
/// Coordinates use latlong2.LatLng so this controller does not depend on
/// google_maps_flutter. The same coordinate type is used by flutter_map.
class LocationController extends GetxController implements GetxService {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  LocationController({
    required this.apiClient,
    required this.sharedPreferences,
  });

  bool isLoading = false;
  bool isGpsActive = false;

  String userLocation = 'Select Delivery Location';
  String? pincode;
  String? city;
  LatLng? latLng;

  static const String keyUserLat = 'user_current_lat';
  static const String keyUserLng = 'user_current_lng';
  static const String keyUserPin = 'user_current_pincode';
  static const String keyUserAddress = 'user_current_address';
  static const String keyUserCity = 'user_current_city';

  @override
  void onInit() {
    super.onInit();
    initLocation();
  }

  /// Restore the last selected location from SharedPreferences.
  Future<void> initLocation() async {
    try {
      final savedLat = sharedPreferences.getString(keyUserLat);
      final savedLng = sharedPreferences.getString(keyUserLng);
      final savedPin = sharedPreferences.getString(keyUserPin);
      final savedAddress = sharedPreferences.getString(keyUserAddress);
      final savedCity = sharedPreferences.getString(keyUserCity);

      final parsedLat = savedLat == null ? null : double.tryParse(savedLat);
      final parsedLng = savedLng == null ? null : double.tryParse(savedLng);

      if (parsedLat != null && parsedLng != null) {
        latLng = LatLng(parsedLat, parsedLng);
      }

      if (savedAddress != null && savedAddress.isNotEmpty) {
        userLocation = savedAddress;
      }

      pincode = savedPin;
      city = savedCity;

      if (latLng != null || (pincode?.isNotEmpty ?? false)) {
        apiClient.updateLocationHeaders(
          lat: latLng?.latitude.toString(),
          lng: latLng?.longitude.toString(),
          pincode: pincode,
        );
      }

      update();
    } catch (e, stackTrace) {
      developer.log(
        'Error initializing location',
        name: 'LocationController',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Detect the current GPS position, reverse geocode it, persist it,
  /// update API headers, sync it to the backend, and refresh products.
  Future<bool> fetchCurrentGPSLocation({bool showToastMessage = true}) async {
    isLoading = true;
    update();

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (showToastMessage) {
          showToast(
            message: 'Location services are disabled. Please turn on GPS.',
            typeCheck: false,
          );
        }
        await Geolocator.openLocationSettings();
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (showToastMessage) {
          showToast(
            message:
                'Location permission denied. Please allow location access.',
            typeCheck: false,
          );
        }
        return false;
      }

      if (permission == LocationPermission.deniedForever) {
        if (showToastMessage) {
          showToast(
            message:
                'Location permission permanently denied. Enable it in App Settings.',
            typeCheck: false,
          );
        }
        await Geolocator.openAppSettings();
        return false;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );

      latLng = LatLng(position.latitude, position.longitude);
      isGpsActive = true;

      String formattedAddress = '${position.latitude.toStringAsFixed(4)}, '
          '${position.longitude.toStringAsFixed(4)}';
      String? detectedPin;
      String? detectedCity;

      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          detectedPin = place.postalCode;
          detectedCity = place.locality?.isNotEmpty == true
              ? place.locality
              : place.subAdministrativeArea;

          final parts = <String>[];
          if (place.subLocality?.isNotEmpty == true) {
            parts.add(place.subLocality!);
          }
          if (place.locality?.isNotEmpty == true) {
            parts.add(place.locality!);
          }
          if (place.administrativeArea?.isNotEmpty == true) {
            parts.add(place.administrativeArea!);
          }
          if (detectedPin?.isNotEmpty == true) {
            parts.add(detectedPin!);
          }

          if (parts.isNotEmpty) {
            formattedAddress = parts.join(', ');
          }
        }
      } catch (e, stackTrace) {
        developer.log(
          'Reverse geocoding failed for GPS location',
          name: 'LocationController',
          error: e,
          stackTrace: stackTrace,
        );
      }

      userLocation = formattedAddress;
      pincode = detectedPin;
      city = detectedCity;

      await _persistLocation(
        lat: position.latitude.toString(),
        lng: position.longitude.toString(),
        pin: pincode ?? '',
        address: userLocation,
        cityName: city ?? '',
      );

      apiClient.updateLocationHeaders(
        lat: position.latitude.toString(),
        lng: position.longitude.toString(),
        pincode: pincode,
      );

      await _syncToBackend(
        position.latitude,
        position.longitude,
        pincode,
        city,
        userLocation,
      );

      if (showToastMessage) {
        showToast(
          message: 'Location updated: $userLocation',
          typeCheck: true,
        );
      }

      reloadServiceableProducts();
      return true;
    } catch (e, stackTrace) {
      developer.log(
        'fetchCurrentGPSLocation failed',
        name: 'LocationController',
        error: e,
        stackTrace: stackTrace,
      );

      if (showToastMessage) {
        showToast(
          message: 'Failed to detect GPS location: $e',
          typeCheck: false,
        );
      }
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }

  /// Set a delivery location using a six-digit Indian PIN code.
  Future<void> setPinCode(String pin, {BuildContext? context}) async {
    final cleanPin = pin.trim();
    if (cleanPin.length != 6 || int.tryParse(cleanPin) == null) {
      showToast(
        message: 'Please enter a valid 6-digit PIN Code',
        typeCheck: false,
      );
      return;
    }

    isLoading = true;
    update();

    pincode = cleanPin;
    userLocation = 'PIN Code: $cleanPin';
    city = null;
    latLng = null;
    isGpsActive = false;

    try {
      final locations = await locationFromAddress('$cleanPin, India');
      if (locations.isNotEmpty) {
        final result = locations.first;
        latLng = LatLng(result.latitude, result.longitude);

        final placemarks = await placemarkFromCoordinates(
          result.latitude,
          result.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          city = place.locality?.isNotEmpty == true
              ? place.locality
              : place.subAdministrativeArea;
          userLocation = '${city ?? 'India'} - $cleanPin';
        }
      }

      await _persistLocation(
        lat: latLng?.latitude.toString() ?? '',
        lng: latLng?.longitude.toString() ?? '',
        pin: pincode ?? '',
        address: userLocation,
        cityName: city ?? '',
      );

      apiClient.updateLocationHeaders(
        lat: latLng?.latitude.toString(),
        lng: latLng?.longitude.toString(),
        pincode: pincode,
      );

      if (latLng != null) {
        await _syncToBackend(
          latLng!.latitude,
          latLng!.longitude,
          pincode,
          city,
          userLocation,
        );
      }

      showToast(
        message: 'Delivering to PIN: $cleanPin',
        typeCheck: true,
      );
      reloadServiceableProducts();
    } catch (e, stackTrace) {
      developer.log(
        'PIN code lookup failed for $cleanPin',
        name: 'LocationController',
        error: e,
        stackTrace: stackTrace,
      );

      // Still persist the PIN even when coordinate lookup is unavailable.
      await _persistLocation(
        lat: '',
        lng: '',
        pin: cleanPin,
        address: userLocation,
        cityName: city ?? '',
      );

      apiClient.updateLocationHeaders(
        lat: null,
        lng: null,
        pincode: cleanPin,
      );

      showToast(
        message: 'PIN saved, but its map coordinates could not be found.',
        typeCheck: false,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  /// Save a location selected by dragging the flutter_map map.
  Future<void> setLocationFromMap({
    required LatLng coords,
    required String address,
    String? pin,
    String? cityName,
  }) async {
    isLoading = true;
    update();

    try {
      latLng = coords;
      userLocation = address;
      pincode = pin;
      city = cityName;
      isGpsActive = false;

      await _persistLocation(
        lat: coords.latitude.toString(),
        lng: coords.longitude.toString(),
        pin: pin ?? '',
        address: address,
        cityName: cityName ?? '',
      );

      apiClient.updateLocationHeaders(
        lat: coords.latitude.toString(),
        lng: coords.longitude.toString(),
        pincode: pin,
      );

      await _syncToBackend(
        coords.latitude,
        coords.longitude,
        pin,
        cityName,
        address,
      );

      showToast(
        message: 'Delivery location set to: $address',
        typeCheck: true,
      );
      reloadServiceableProducts();
    } catch (e, stackTrace) {
      developer.log(
        'Could not save map-selected location',
        name: 'LocationController',
        error: e,
        stackTrace: stackTrace,
      );
      showToast(
        message: 'Unable to save the selected delivery location.',
        typeCheck: false,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  /// Set the active delivery location from an address already saved by user.
  Future<void> setFromSavedAddress({
    required String addressText,
    required String pin,
    String? cityName,
    double? latitude,
    double? longitude,
  }) async {
    isLoading = true;
    update();

    try {
      userLocation = addressText;
      pincode = pin;
      city = cityName;
      isGpsActive = false;
      latLng = null;

      if (latitude != null &&
          longitude != null &&
          latitude != 0.0 &&
          longitude != 0.0) {
        latLng = LatLng(latitude, longitude);
      } else {
        try {
          final query = pin.trim().isNotEmpty
              ? '$addressText, $pin, India'
              : '$addressText, India';
          final locations = await locationFromAddress(query);
          if (locations.isNotEmpty) {
            latLng = LatLng(
              locations.first.latitude,
              locations.first.longitude,
            );
          }
        } catch (e, stackTrace) {
          developer.log(
            'Could not geocode saved address',
            name: 'LocationController',
            error: e,
            stackTrace: stackTrace,
          );
        }
      }

      await _persistLocation(
        lat: latLng?.latitude.toString() ?? '',
        lng: latLng?.longitude.toString() ?? '',
        pin: pin,
        address: addressText,
        cityName: cityName ?? '',
      );

      apiClient.updateLocationHeaders(
        lat: latLng?.latitude.toString(),
        lng: latLng?.longitude.toString(),
        pincode: pin,
      );

      if (latLng != null) {
        await _syncToBackend(
          latLng!.latitude,
          latLng!.longitude,
          pin,
          cityName,
          addressText,
        );
      }

      showToast(
        message: 'Delivering to: $addressText ($pin)',
        typeCheck: true,
      );
      reloadServiceableProducts();
    } catch (e, stackTrace) {
      developer.log(
        'Could not activate saved address',
        name: 'LocationController',
        error: e,
        stackTrace: stackTrace,
      );
      showToast(
        message: 'Unable to select this saved address.',
        typeCheck: false,
      );
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> _persistLocation({
    required String lat,
    required String lng,
    required String pin,
    required String address,
    required String cityName,
  }) async {
    await sharedPreferences.setString(keyUserLat, lat);
    await sharedPreferences.setString(keyUserLng, lng);
    await sharedPreferences.setString(keyUserPin, pin);
    await sharedPreferences.setString(keyUserAddress, address);
    await sharedPreferences.setString(keyUserCity, cityName);
  }

  Future<void> _syncToBackend(
    double lat,
    double lng,
    String? pin,
    String? cityName,
    String address,
  ) async {
    try {
      await apiClient.postData(
        'user/set-active-location',
        'SyncLocation',
        {
          'latitude': lat,
          'longitude': lng,
          'pincode': pin ?? '',
          'city': cityName ?? '',
          'address': address,
        },
      );
    } catch (e, stackTrace) {
      developer.log(
        'Could not sync location to backend',
        name: 'LocationController',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void reloadServiceableProducts() {
    try {
      if (Get.isRegistered<HomeController>()) {
        final home = Get.find<HomeController>();
        home.fetchFeaturedProducts();
        home.fetchHomeCategory();
        home.fetchHotDealsTodayProducts();
      }
    } catch (e, stackTrace) {
      developer.log(
        'Could not refresh serviceable products',
        name: 'LocationController',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
