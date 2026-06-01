import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Color primaryColor = const Color(0xFF341EB2);
Color secondaryColor = const Color(0xFFf97316);
Color backgroundDark = const Color(0xff231F20);
Color backgroundLight = const Color(0xffffffff);

const Color appbarBlueLight = Color(0xFFEFF4FF);

const Color textPrimary = Color(0xff000000);
const Color textSecondary = Color(0xff838383);

const Color loginPageBg = Color(0xfff0f2f5);
const Color white = Colors.white;
const Color grey = Colors.grey;

const Color greyDark = Color(0xFF64748B);
const Color greyVeryDark = Color(0xFF555555);
const Color greyBorder = Color(0xFFE5E7EB);
const Color greyLight = Color(0xFF637587);
const Color greyBillText = Color(0xFF5E788C);
const Color greyNumberBg = Color(0xFF8B8A89);
const Color greyAccountText = Color(0xFFABABAB);
const Color greyMember = Color(0xFF787878);
Color greyText = const Color(0xFF5C5B5B);
Color greyText2 = const Color(0xFF414753);
Color greyText3 = const Color(0xFFC1C6D6);
Color greyText4 = const Color(0xFF717785);
Color greyExpired = const Color(0xFF958B8B);
const Color whiteBg2 = Color(0xFFFAFAFA);
const Color yellow = Color(0xFFFFDB4C);
const Color blueDark = Color(0xFF005BB1);
const Color blueLight = Color(0xFF0B1C300F);

const Color black = Colors.black;
const Color blackText = Color(0xFF0B1C30);
const Color blackBillingText = Color(0xFF0F1417);
const Color red = Colors.red;
const Color green = Colors.green;
const Color rustyOrange = Color(0xFF9D4300);

//Order Status color

Color getStatusColor(String? status) {
  switch (status?.toLowerCase()) {
    case 'processing':
      return Colors.amber; // yellow
    case 'delivered':
      return Colors.green;
    case 'shipped':
      return Colors.blue;
    case 'cancelled':
      return Colors.red;
    default:
      return Colors.grey; // fallback color
  }
}

Map<int, Color> color = const {
  50: Color.fromRGBO(255, 244, 149, .1),
  100: Color.fromRGBO(255, 244, 149, .2),
  200: Color.fromRGBO(255, 244, 149, .3),
  300: Color.fromRGBO(255, 244, 149, .4),
  400: Color.fromRGBO(255, 244, 149, .5),
  500: Color.fromRGBO(255, 244, 149, .6),
  600: Color.fromRGBO(255, 244, 149, .7),
  700: Color.fromRGBO(255, 244, 149, .8),
  800: Color.fromRGBO(255, 244, 149, .9),
  900: Color.fromRGBO(255, 244, 149, 1),
};
MaterialColor colorCustom = MaterialColor(0XFFFFF495, color);

class CustomTheme {
  static ThemeData light = ThemeData(
    fontFamily: "Montserrat",
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundLight,
    hintColor: Colors.grey[700],
    primarySwatch: colorCustom,
    canvasColor: secondaryColor,
    primaryColorLight: secondaryColor,
    splashColor: secondaryColor,
    shadowColor: Colors.grey[600],
    cardColor: Colors.grey[100],
    primaryColor: primaryColor,
    dividerColor: Colors.grey[600],
    primaryColorDark: Colors.black,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      error: const Color(0xFFCF6679),
      onError: const Color(0xFFCF6679),
      background: backgroundLight,
      onBackground: Colors.black,
      surface: backgroundLight,
      onSurface: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      actionsIconTheme: IconThemeData(
        color: backgroundLight,
      ),
      iconTheme: IconThemeData(
        color: black,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: primaryColor,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    typography: Typography.material2021(),
    textTheme: TextTheme(
      labelLarge: GoogleFonts.openSans(
        fontWeight: FontWeight.w400,
        color: textSecondary,
        fontSize: 14.0,
      ),
      headlineLarge: GoogleFonts.openSans(),
      headlineMedium: GoogleFonts.cactusClassicalSerif(),
      headlineSmall: GoogleFonts.inter(),
      displayLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      displayMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      displaySmall:
          GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.w500),
      titleLarge: GoogleFonts.openSans(),
      titleMedium: GoogleFonts.poppins(
        fontSize: 30,
        fontWeight: FontWeight.w800,
      ),
      titleSmall: GoogleFonts.openSans(
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: black,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 16,
        color: black,
      ),
      bodySmall: GoogleFonts.openSans(
        fontSize: 12,
      ),
    ),
  );
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundDark,
    hintColor: Colors.grey[700],
    primarySwatch: colorCustom,
    canvasColor: secondaryColor,
    primaryColorLight: secondaryColor,
    splashColor: secondaryColor,
    shadowColor: Colors.black45,
    cardColor: Colors.grey[800],
    primaryColor: primaryColor,
    dividerColor: Colors.grey[200],
    primaryColorDark: Colors.white,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      error: const Color(0xFFCF6679),
      onError: const Color(0xFFCF6679),
      background: backgroundDark,
      onBackground: Colors.white,
      surface: backgroundDark,
      onSurface: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      actionsIconTheme: IconThemeData(
        color: backgroundLight,
      ),
      iconTheme: IconThemeData(
        color: backgroundLight,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: primaryColor,
        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    typography: Typography.material2021(),
    textTheme: TextTheme(
      labelLarge: GoogleFonts.openSans(
        fontWeight: FontWeight.w400,
        color: textSecondary,
        fontSize: 14.0,
      ),
      headlineLarge: GoogleFonts.openSans(),
      headlineMedium: GoogleFonts.openSans(),
      headlineSmall: GoogleFonts.openSans(),
      displayLarge: GoogleFonts.openSans(),
      displayMedium: GoogleFonts.openSans(),
      displaySmall: GoogleFonts.openSans(),
      titleLarge: GoogleFonts.openSans(),
      titleMedium: GoogleFonts.openSans(),
      titleSmall: GoogleFonts.openSans(),
      bodyLarge: GoogleFonts.openSans(),
      bodyMedium: GoogleFonts.openSans(),
      bodySmall: GoogleFonts.openSans(),
    ),
  );
}
