import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static final themeData = ThemeData(
      scaffoldBackgroundColor: const Color(0xff1d1449),
      primaryColor: const Color(0xffe16e03),
      textTheme: TextTheme(
          bodyText2: GoogleFonts.lora(
        color: Colors.white,
      )),
      appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xff1d1449),
          titleTextStyle: GoogleFonts.lora(
            color: Colors.white,
            fontSize: 24,
          )));
}
