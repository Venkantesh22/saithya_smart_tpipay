import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lekra/services/constants.dart';
import 'package:lekra/services/theme.dart';
import 'package:lekra/views/screens/splash_screen/splash_screen.dart';
import 'package:toastification/toastification.dart';
import 'services/init.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

//   AppPackage Name = "com.saithiya.smart"
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    log('FlutterError: ${details.exceptionAsString()}',
        stackTrace: details.stack);
  };

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    log("Firebase primary initialization error: $e");
  }

  // try {
  //   bool hasSecondary = Firebase.apps.any((app) => app.name == 'SecondaryApp');
  //   if (!hasSecondary) {
  //     await Firebase.initializeApp(
  //       name: 'SecondaryApp',
  //       options: second_config.DefaultFirebaseOptions.currentPlatform,
  //     );
  //   }
  // } catch (e) {
  //   log("Firebase secondary initialization error: $e");
  // }

  try {
    await Init().initialize();
  } catch (e) {
    log("Init initialize error: $e");
  }

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> snackBarKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    log('Current state = $state');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // initPlatForm();
  }

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        title: AppConstants.appName,
        navigatorKey: navigatorKey,
        themeMode: ThemeMode.light,
        theme: CustomTheme.light,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
