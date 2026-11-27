import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import 'package:lekra/controllers/location_controller.dart';
import 'package:lekra/services/theme.dart';

class LocationPickerMapScreen extends StatefulWidget {
  final LatLng? initialPosition;
  final bool returnOnly;

  const LocationPickerMapScreen({
    super.key,
    this.initialPosition,
    this.returnOnly = false,
  });

  @override
  State<LocationPickerMapScreen> createState() =>
      _LocationPickerMapScreenState();
}

class _LocationPickerMapScreenState extends State<LocationPickerMapScreen> {
  late final MapController _mapController;
  late LatLng _currentCenter;

  bool _isLoadingAddress = true;
  bool _isMovingToCurrentLocation = false;
  bool _mapReady = false;

  String _detectedAddress = 'Locating address...';
  String? _detectedPincode;
  String? _detectedCity;

  Timer? _debounceTimer;
  int _geocodeRequestId = 0;

  static const LatLng _defaultLocation = LatLng(22.7196, 75.8577);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    final locationController = Get.find<LocationController>();
    _currentCenter =
        widget.initialPosition ?? locationController.latLng ?? _defaultLocation;

    _reverseGeocodeCenter(_currentCenter);
  }

  void _onPositionChanged(MapCamera camera, bool hasGesture) {
    _currentCenter = camera.center;

    if (hasGesture) {
      _scheduleReverseGeocode(_currentCenter);
    }
  }

  void _scheduleReverseGeocode(LatLng position) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 650), () {
      if (mounted) {
        _reverseGeocodeCenter(position);
      }
    });
  }

  Future<void> _reverseGeocodeCenter(LatLng position) async {
    if (!mounted) return;

    final requestId = ++_geocodeRequestId;
    setState(() => _isLoadingAddress = true);

    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!mounted || requestId != _geocodeRequestId) return;

      if (placemarks.isEmpty) {
        setState(() {
          _detectedAddress = _coordinatesText(position);
          _detectedPincode = null;
          _detectedCity = null;
          _isLoadingAddress = false;
        });
        return;
      }

      final place = placemarks.first;
      final pincode = place.postalCode;
      final city = place.locality?.isNotEmpty == true
          ? place.locality
          : place.subAdministrativeArea;

      final parts = <String>[];
      if (place.name?.isNotEmpty == true && place.name != place.subLocality) {
        parts.add(place.name!);
      }
      if (place.subLocality?.isNotEmpty == true) {
        parts.add(place.subLocality!);
      }
      if (place.locality?.isNotEmpty == true) {
        parts.add(place.locality!);
      }
      if (place.administrativeArea?.isNotEmpty == true) {
        parts.add(place.administrativeArea!);
      }
      if (pincode?.isNotEmpty == true) {
        parts.add(pincode!);
      }

      if (!mounted || requestId != _geocodeRequestId) return;

      setState(() {
        _detectedAddress =
            parts.isNotEmpty ? parts.join(', ') : _coordinatesText(position);
        _detectedPincode = pincode;
        _detectedCity = city;
        _isLoadingAddress = false;
      });
    } catch (e, stackTrace) {
      developer.log(
        'Map reverse geocoding failed',
        name: 'LocationPickerMapScreen',
        error: e,
        stackTrace: stackTrace,
      );

      if (!mounted || requestId != _geocodeRequestId) return;

      setState(() {
        _detectedAddress = _coordinatesText(position);
        _detectedPincode = null;
        _detectedCity = null;
        _isLoadingAddress = false;
      });
    }
  }

  String _coordinatesText(LatLng position) {
    return '${position.latitude.toStringAsFixed(5)}, '
        '${position.longitude.toStringAsFixed(5)}';
  }

  Future<void> _goToCurrentLocation() async {
    if (_isMovingToCurrentLocation) return;

    setState(() => _isMovingToCurrentLocation = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        _showMessage('Please enable your device location.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        _showMessage('Location permission denied.');
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        _showMessage('Enable location permission in app settings.');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );

      if (!mounted) return;

      final target = LatLng(position.latitude, position.longitude);
      _currentCenter = target;

      if (_mapReady) {
        _mapController.move(target, 16.5);
      }

      _scheduleReverseGeocode(target);
    } catch (e, stackTrace) {
      developer.log(
        'Could not move map to current location',
        name: 'LocationPickerMapScreen',
        error: e,
        stackTrace: stackTrace,
      );
      _showMessage('Unable to get your current location.');
    } finally {
      if (mounted) {
        setState(() => _isMovingToCurrentLocation = false);
      }
    }
  }

  Future<void> _confirmLocation() async {
    if (_isLoadingAddress) return;

    if (widget.returnOnly) {
      Navigator.of(context).pop({
        'latLng': _currentCenter,
        'address': _detectedAddress,
        'pincode': _detectedPincode ?? '',
        'city': _detectedCity ?? '',
      });
      return;
    }

    await Get.find<LocationController>().setLocationFromMap(
      coords: _currentCenter,
      address: _detectedAddress,
      pin: _detectedPincode,
      cityName: _detectedCity,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _geocodeRequestId++;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Select Delivery Location',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentCenter,
              initialZoom: 15.5,
              minZoom: 3,
              maxZoom: 19,
              onMapReady: () => _mapReady = true,
              onPositionChanged: _onPositionChanged,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.saithya',
                maxZoom: 19,
              ),
              RichAttributionWidget(
                alignment: AttributionAlignment.bottomRight,
                attributions: [
                  TextSourceAttribution('© OpenStreetMap contributors'),
                ],
              ),
            ],
          ),

          // This pin stays fixed while the map moves underneath it.
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Text(
                      'Delivery Point',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Icon(
                    Icons.location_pin,
                    size: 46,
                    color: Color(0xFFDC2626),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            right: 16,
            bottom: 230,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              foregroundColor: primaryColor,
              elevation: 4,
              onPressed:
                  _isMovingToCurrentLocation ? null : _goToCurrentLocation,
              child: _isMovingToCurrentLocation
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: primaryColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _detectedCity?.isNotEmpty == true
                                    ? _detectedCity!
                                    : 'Delivery Address',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _isLoadingAddress
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      _detectedAddress,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                              if (_detectedPincode?.isNotEmpty == true) ...[
                                const SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 7,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'PIN: $_detectedPincode',
                                    style: TextStyle(
                                      color: Colors.blue.shade800,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _isLoadingAddress ? null : _confirmLocation,
                        child: const Text(
                          'Confirm Delivery Location',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
