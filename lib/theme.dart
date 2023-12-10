import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  Map<int, Color> blueColors = <int, Color>{
    50: const Color(0xffE3F2FD),
    100: const Color(0xffBBDEFB),
    200: const Color(0xff90CAF9),
    300: const Color(0xff64B5F6),
    400: const Color(0xff42A5F5),
    500: const Color(0xff2196F3),
    600: const Color(0xff1E88E5),
    700: const Color(0xff1976D2),
    800: const Color(0xff1565C0),
    900: const Color(0xff0D47A1)
  };

  Map<int, Color> grayColors = <int, Color>{
    50: const Color(0xffFAFAFA),
    100: const Color(0xffF5F5F5),
    200: const Color(0xffEEEEEE),
    300: const Color(0x0ffee0e0),
    400: const Color(0xffBDBDBD),
    500: const Color(0xff9E9E9E),
    600: const Color(0xff757575),
    700: const Color(0xff616161),
    800: const Color(0xff424242),
    900: const Color(0xff212121)
  };

  ThemeData getAppTheme() {
    return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: blueColors[500],
        hintColor: blueColors[800],
        scaffoldBackgroundColor: grayColors[50],
        textTheme: GoogleFonts.sourceSerif4TextTheme(),
        tabBarTheme: TabBarTheme(
          dividerColor: grayColors[50],
          labelColor: grayColors[900],
          unselectedLabelColor: grayColors[50],
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
              border: const Border(
                  left: BorderSide(color: Color(0xff1565C0)),
                  right: BorderSide(color: Color(0xff1565C0)),
                  top: BorderSide(color: Color(0xff1565C0)),
                  bottom: BorderSide.none),
              color: grayColors[50]),
        ),
        appBarTheme: AppBarTheme(
            backgroundColor: blueColors[500],
            centerTitle: true,
            titleTextStyle: GoogleFonts.sourceSerif4(
                color: grayColors[50],
                fontSize: 22,
                fontWeight: FontWeight.w600,
                height: 0.06),
            iconTheme: IconThemeData(color: blueColors[900])),
        iconTheme: IconThemeData(color: blueColors[900], size: 30),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: blueColors[100],
                textStyle: GoogleFonts.sourceSerif4(
                    color: grayColors[50],
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 0.06),
                )
        )
    );
  }
}
