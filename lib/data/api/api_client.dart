// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:lekra/data/repositories/auth_repo.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../services/constants.dart';

// class ApiClient extends GetConnect implements GetxService {
//   final String appBaseUrl;
//   final SharedPreferences sharedPreferences;

//   String? token;
//   Map<String, String>? _mainHeaders;

//   ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
//     try {
//       baseUrl = appBaseUrl;
//       timeout = const Duration(seconds: 30);
//       token = sharedPreferences.getString(AppConstants.token) ?? '';
//       if (kDebugMode) {
//         log('Token: $token');
//         log('BaseUrl: $baseUrl');
//       }
//       _mainHeaders = {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       };
//     } catch (e) {
//       log('******** ${e.toString()} ********+', name: "ERROR AT ApiClient()");
//     }
//   }

//   void updateHeader(String? token) {
//     _mainHeaders = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };
//   }

//   Future<Response> getData(
//     String uri, {
//     Map<String, dynamic>? query,
//     String? contentType,
//     Map<String, String>? headers,
//     Function(dynamic)? decoder,
//   }) async {
//     try {
//       if (kDebugMode) {
//         log('====> GetX Call: $uri\nToken: $token');
//       }
//       Response response = await get(
//         uri,
//         contentType: contentType,
//         query: query,
//         headers: headers ?? _mainHeaders,
//         decoder: decoder,
//       );
//       JsonEncoder jsonEncoder = const JsonEncoder();
//       checkForUnauthorized(response);
//       response = handleResponse(response);
//       log('====> GetX Response: [${response.statusCode}] $uri\n');
//       return response;
//     } catch (e) {
//       return Response(statusCode: 1, body: {'message': e.toString()});
//     }
//   }

//   Future<Response> postData(
//     String uri,
//     dynamic body, {
//     Map<String, dynamic>? query,
//     String? contentType,
//     Map<String, String>? headers,
//     Function(dynamic)? decoder,
//     Function(double)? uploadProgress,
//   }) async {
//     try {
//       if (kDebugMode) {
//         log('====> GetX Call: $uri\nToken: $token');
//         log('====> GetX Body: ${body is FormData ? body.fields : body}', name: uri);
//       }
//       Response response = await post(
//         uri,
//         body,
//         query: query,
//         contentType: contentType,
//         headers: headers ?? _mainHeaders,
//         decoder: decoder,
//         uploadProgress: uploadProgress,
//       );
//       JsonEncoder jsonEncoder = const JsonEncoder();
//       checkForUnauthorized(response);
//       response = handleResponse(response);
//       log('====> GetX Response: [${response.statusCode}] $uri\n${jsonEncoder.convert(response.body)}');
//       log('====> GetX Response: [${response.statusCode}] $uri');

//       return response;
//     } catch (e) {
//       log('$e', name: 'ERROR AT POST');
//       return Response(statusCode: 1, body: {'message': e.toString()});
//     }
//   }

//   Future<Response> putData(
//     String uri,
//     dynamic body, {
//     Map<String, dynamic>? query,
//     String? contentType,
//     Map<String, String>? headers,
//     Function(dynamic)? decoder,
//     Function(double)? uploadProgress,
//   }) async {
//     try {
//       if (kDebugMode) {
//         print('====> GetX Call: $uri\nToken: $token');
//         print('====> GetX Body: $body');
//       }
//       Response response = await put(
//         uri,
//         body,
//         query: query,
//         contentType: contentType,
//         headers: headers ?? _mainHeaders,
//         decoder: decoder,
//         uploadProgress: uploadProgress,
//       );
//       response = handleResponse(response);
//       log('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
//       return response;
//     } catch (e) {
//       return Response(statusCode: 1, body: {'message': e.toString()});
//     }
//   }

//   Future<Response> patchData(
//     String uri,
//     dynamic body, {
//     Map<String, dynamic>? query,
//     String? contentType,
//     Map<String, String>? headers,
//     Function(dynamic)? decoder,
//     Function(double)? uploadProgress,
//   }) async {
//     try {
//       if (kDebugMode) {
//         print('====> GetX Call: $uri\nToken: $token');
//         print('====> GetX Body: $body');
//       }
//       Response response = await patch(
//         uri,
//         body,
//         query: query,
//         contentType: contentType,
//         headers: headers ?? _mainHeaders,
//         decoder: decoder,
//         uploadProgress: uploadProgress,
//       );
//       response = handleResponse(response);
//       log('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
//       return response;
//     } catch (e) {
//       return Response(statusCode: 1, body: {'message': e.toString()});
//     }
//   }

//   Future<Response> deleteData(
//     String uri, {
//     Map<String, dynamic>? query,
//     String? contentType,
//     Map<String, String>? headers,
//     Function(dynamic)? decoder,
//   }) async {
//     try {
//       if (kDebugMode) {
//         print('====> GetX Call: $uri\nToken: $token');
//       }
//       Response response = await delete(
//         uri,
//         headers: headers ?? _mainHeaders,
//         contentType: contentType,
//         query: query,
//         decoder: decoder,
//       );
//       response = handleResponse(response);
//       log('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
//       return response;
//     } catch (e) {
//       return Response(statusCode: 1, body: {'message': e.toString()});
//     }
//   }

//   Response handleResponse(Response response) {
//     Response _response = response;
//     if (_response.hasError && _response.body == null) {
//       log(_response.statusCode.toString(), name: "STATUS CODE");
//       _response = const Response(statusCode: 0, body: {'message': 'Connection to API server failed due to internet connection'});
//     }
//     return _response;
//   }

//   void checkForUnauthorized(Response response) async {
//     if (response.statusCode == 401) {
//       Get.find<AuthRepo>().clearSharedData();
//       // Navigator.pushAndRemoveUntil(navigatorKey.currentContext!, getCustomRoute(child: const LoginScreen()), (route) => false);
//       // showCustomToast(msg: 'Unauthenticated!', toastType: ToastType.error);
//     }
//   }
// }
// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/constants.dart';
import '../repositories/auth_repo.dart';
import '../../views/screens/auth_screens/login_screen.dart';

class ApiClient extends GetConnect implements GetxService {
  final String appBaseUrl;

  final SharedPreferences sharedPreferences;

  String? token;
  Map<String, String>? _mainHeaders;
  String? currentLat;
  String? currentLng;
  String? currentPincode;

  void updateLocationHeaders({String? lat, String? lng, String? pincode}) {
    if (lat != null) currentLat = lat;
    if (lng != null) currentLng = lng;
    if (pincode != null) currentPincode = pincode;

    _mainHeaders ??= {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    if (currentLat != null && currentLat!.isNotEmpty) {
      _mainHeaders!['lat'] = currentLat!;
    }
    if (currentLng != null && currentLng!.isNotEmpty) {
      _mainHeaders!['long'] = currentLng!;
    }
    if (currentPincode != null && currentPincode!.isNotEmpty) {
      _mainHeaders!['pincode'] = currentPincode!;
    }
  }

  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    try {
      String url = appBaseUrl.trim();
      if (!url.endsWith('/')) {
        url = '$url/';
      }
      baseUrl = url;
      timeout = const Duration(seconds: 30);
      token = sharedPreferences.getString(AppConstants.token) ?? '';
      currentLat = sharedPreferences.getString('user_current_lat');
      currentLng = sharedPreferences.getString('user_current_lng');
      currentPincode = sharedPreferences.getString('user_current_pincode');
      if (kDebugMode) {
        print('Token: $token');
        print('BaseUrl: $baseUrl');
      }
      _mainHeaders = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };
      if (currentLat != null && currentLat!.isNotEmpty) {
        _mainHeaders!['lat'] = currentLat!;
      }
      if (currentLng != null && currentLng!.isNotEmpty) {
        _mainHeaders!['long'] = currentLng!;
      }
      if (currentPincode != null && currentPincode!.isNotEmpty) {
        _mainHeaders!['pincode'] = currentPincode!;
      }
    } catch (e) {
      log('******** ${e.toString()} ********+', name: "ERROR AT ApiClient()");
    }
  }

  String _normalizeUri(String uri) {
    if (uri.startsWith('http://') || uri.startsWith('https://')) {
      return uri;
    }
    String base = baseUrl ?? '';
    if (base.endsWith('/api/') || base.endsWith('/api')) {
      if (uri.startsWith('/api/')) {
        return uri.substring(5);
      } else if (uri.startsWith('api/')) {
        return uri.substring(4);
      }
    }
    return uri;
  }

  void updateHeader(
    String? token, 
  ) {
    this.token = token ?? this.token;
    _mainHeaders = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    if (currentLat != null && currentLat!.isNotEmpty) {
      _mainHeaders!['lat'] = currentLat!;
    }
    if (currentLng != null && currentLng!.isNotEmpty) {
      _mainHeaders!['long'] = currentLng!;
    }
    if (currentPincode != null && currentPincode!.isNotEmpty) {
      _mainHeaders!['pincode'] = currentPincode!;
    }
  }
 
  Future<Response> getData(
    String uri,
    String name, {
    Map<String, dynamic>? query,
    String? contentType,
    Map<String, String>? headers,
    Function(dynamic)? decoder,
  }) async {
    try {
      final reqUri = _normalizeUri(uri);
      if (kDebugMode) {
        log('====> GetX Call: $reqUri (original: $uri)\nToken: $token');
      }
      Response response = await get(
        reqUri,
        contentType: contentType,
        query: query,
        headers: headers ?? _mainHeaders,
        decoder: decoder,
      );
      log("====> API Header: ${headers ?? _mainHeaders}", name: "apiHeaders");
      // log('aasdas'+response.bodyString!+'aasdas',name: '$uri');

      log('====> GetX Response: [${response.statusCode}] $uri', name: name);
      log('${response.bodyString}', name: name);
      response = handleResponse(response);
      if (kDebugMode) {
        // log('====> GetX Response: [${response.statusCode}] $u ri\n${uri.contains('astros') || uri.contains('shop') || uri.contains('shop') ? response.body[0] : response.body}');
      }
      return response;
    } catch (e) {
      // log("$e",name: 'ERROR $uri');
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(
    String uri,
    String name,
    dynamic body, {
    Map<String, dynamic>? query,
    String? contentType,
    Map<String, String>? headers,
    Function(dynamic)? decoder,
    Function(double)? uploadProgress,
  }) async {
    try {
      final reqUri = _normalizeUri(uri);
      if (kDebugMode) {
        log('====> GetX Call: $reqUri (original: $uri)\nToken: $token');
        log('====> GetX Body: ${body is FormData ? body.fields : body}', name: uri);
      }
      Response response = await post(
        reqUri,
        body,
        query: query,
        contentType: contentType,
        headers: headers ?? _mainHeaders,
        decoder: decoder,
        uploadProgress: uploadProgress,
      );
      log('====> GetX Response: [${response.statusCode}] $uri\n${response.bodyString}', name: name);
      response = handleResponse(response, uri);
      log('====> GetX Response: [${response.statusCode}] $uri');
      if (kDebugMode) {
        // print('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
      }
      return response;
    } catch (e) {
      log('$e', name: 'ERROR AT POST');
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> putData(
    String uri,
    String name,
    dynamic body, {
    Map<String, dynamic>? query,
    String? contentType,
    Map<String, String>? headers,
    Function(dynamic)? decoder,
    Function(double)? uploadProgress,
  }) async {
    try {
      final reqUri = _normalizeUri(uri);
      if (kDebugMode) {
        print('====> GetX Call: $reqUri (original: $uri)\nToken: $token');
        print('====> GetX Body: $body');
      }
      Response response = await put(
        reqUri,
        body,
        query: query,
        contentType: contentType,
        headers: headers ?? _mainHeaders,
        decoder: decoder,
        uploadProgress: uploadProgress,
      );
      response = handleResponse(response);
      log('====> GetX Response: [${response.statusCode}] $uri\n${response.bodyString}');
      if (kDebugMode) {
        // print('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
      }
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> patchData(
    String uri,
    String name,
    dynamic body, {
    Map<String, dynamic>? query,
    String? contentType,
    Map<String, String>? headers,
    Function(dynamic)? decoder,
    Function(double)? uploadProgress,
  }) async {
    try {
      final reqUri = _normalizeUri(uri);
      if (kDebugMode) {
        print('====> GetX Call: $reqUri (original: $uri)\nToken: $token');
        print('====> GetX Body: $body');
      }
      Response response = await patch(
        reqUri,
        body,
        query: query,
        contentType: contentType,
        headers: headers ?? _mainHeaders,
        decoder: decoder,
        uploadProgress: uploadProgress,
      );
      response = handleResponse(response);
      log('====> GetX Response: [${response.statusCode}] $uri\n${response.bodyString}');
      if (kDebugMode) {
        // print('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
      }
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> deleteData(
    String uri,
    String name, {
    Map<String, dynamic>? query,
    String? contentType,
    Map<String, String>? headers,
    Function(dynamic)? decoder,
  }) async {
    try {
      final reqUri = _normalizeUri(uri);
      if (kDebugMode) {
        print('====> GetX Call: $reqUri (original: $uri)\nToken: $token');
      }
      Response response = await delete(
        reqUri,
        headers: headers ?? _mainHeaders,
        contentType: contentType,
        query: query,
        decoder: decoder,
      );
      response = handleResponse(response);
      log('====> GetX Response: [${response.statusCode}] $uri\n${response.bodyString}');
      if (kDebugMode) {
        // print('====> GetX Response: [${response.statusCode}] $uri\n${response.body}');
      }
      return response;
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  void checkForUnauthorized(Response response, [String? requestUri]) async {
    if (response.statusCode == 401) {
      if (requestUri != null &&
          (requestUri.contains('login') ||
              requestUri.contains('register') ||
              requestUri.contains('send-otp') ||
              requestUri.contains('verify-otp') ||
              requestUri.contains('password'))) {
        return;
      }
      if (token == null || token!.trim().isEmpty) {
        return;
      }
      try {
        if (Get.isRegistered<AuthRepo>()) {
          Get.find<AuthRepo>().clearSharedData();
        }
        Get.offAll(() => const LoginScreen());
        showToast(
          message: 'Session expired or logged in from another device. Please login again.',
          typeCheck: false,
        );
      } catch (e) {
        log('Error during 401 session expiry handling: $e');
      }
    }
  }

  Response handleResponse(Response response, [String? uri]) {
    Response _response = response;

    // Single active device session enforcement
    if (_response.statusCode == 401) {
      checkForUnauthorized(_response, uri);
    }

    if (_response.hasError) {
      String? extractedMsg;
      if (_response.body != null) {
        if (_response.body is Map) {
          final map = _response.body as Map;
          if (map['message'] != null && map['message'].toString().isNotEmpty) {
            extractedMsg = map['message'].toString();
          } else if (map['error'] != null && map['error'].toString().isNotEmpty) {
            extractedMsg = map['error'].toString();
          } else if (map['errors'] != null) {
            final errs = map['errors'];
            if (errs is Map && errs.isNotEmpty) {
              final firstVal = errs.values.first;
              extractedMsg = firstVal is List && firstVal.isNotEmpty
                  ? firstVal.first.toString()
                  : firstVal.toString();
            } else if (errs is List && errs.isNotEmpty) {
              extractedMsg = errs.first is Map && errs.first['message'] != null
                  ? errs.first['message'].toString()
                  : errs.first.toString();
            }
          }
        } else if (_response.body is String) {
          try {
            final decoded = jsonDecode(_response.body as String);
            if (decoded is Map) {
              extractedMsg = decoded['message']?.toString() ??
                  decoded['error']?.toString();
            }
          } catch (_) {}
        }
      }

      if (extractedMsg != null && extractedMsg.isNotEmpty) {
        _response = Response(
          statusCode: _response.statusCode,
          body: _response.body,
          statusText: extractedMsg,
        );
      } else if (_response.body == null || _response.statusText == null) {
        log(_response.statusCode.toString(), name: "STATUS CODE");
        _response = Response(
          statusCode: _response.statusCode,
          body: _response.body,
          statusText: 'Connection to API server failed due to internet connection',
        );
      }
    }
    return _response;
  }

  Future<dynamic> commonApiCall(String urlR, Map<String, dynamic> body) async {
    String targetUrl = urlR;
    if (!targetUrl.startsWith('http')) {
      String base = baseUrl ?? AppConstants.baseUrl;
      if (!base.endsWith('/')) base = '$base/';
      targetUrl = base + _normalizeUri(targetUrl);
    }
    var postUri = Uri.parse(targetUrl);
    log(urlR);
    log(body.toString());
    late http.Response response;
    try {
      response = await http.post(
        postUri,
        body: body,
        headers: _mainHeaders,
      );
      log('response.bodyresponse.body');
      log(response.body);
      // log(response.body.length.toString());
      // log(response.body.substring(0,response.body.length));
      log("/${response.request!.url.path.split('/').last} ============ ${response.statusCode}\n", name: "API SUCCESS PATH CAC");

      return response;
    } catch (e) {
      log("/${postUri.path.split('/').last} ============ " /*+ getResponseStatus(response)*/, name: "API FAILURE PATH CAC");
      log('+++++++ ${e.toString().replaceAll('\n', ' ')} +++++++\n',
          name: "API ERROR CAC(/${"${postUri.path.split('/').last} ============ " /*+ getResponseStatus(response)*/})", level: 1);
      return null;
    }
  }

  Future<dynamic> commonApiCallGet(String url) async {
    String targetUrl = url;
    if (!targetUrl.startsWith('http')) {
      String base = baseUrl ?? AppConstants.baseUrl;
      if (!base.endsWith('/')) base = '$base/';
      targetUrl = base + _normalizeUri(targetUrl);
    }
    var postUri = Uri.parse(targetUrl);
    // log(urlR);
    // log(body.toString());
    late http.Response response;
    try {
      response = await http.get(
        postUri,
        headers: _mainHeaders,
      );
      log('response.bodyresponse.body');
      log(response.body);
      // log(response.body.length.toString());
      // log(response.body.substring(0,response.body.length));
      log("/${response.request!.url.path.split('/').last} ============ ${response.statusCode}\n", name: "API SUCCESS PATH CAC");

      return response;
    } catch (e) {
      log("/${postUri.path.split('/').last} ============ " /*+ getResponseStatus(response)*/, name: "API FAILURE PATH CAC");
      log('+++++++ ${e.toString().replaceAll('\n', ' ')} +++++++\n',
          name: "API ERROR CAC(/${"${postUri.path.split('/').last} ============ " /*+ getResponseStatus(response)*/})", level: 1);
      return null;
    }
  }
}
