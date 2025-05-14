import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateit/helpers/colors.dart';
import 'package:rateit/views/login/login_page.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const RateItApp());
}

class RateItApp extends StatelessWidget {
  const RateItApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: ColorsPalette.flirtatious,
          scaffoldBackgroundColor: ColorsPalette.white,
          textTheme: GoogleFonts.playpenSansTextTheme(Theme.of(context).textTheme),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: ColorsPalette.turquoiseTopaz,
              outline: ColorsPalette.boyzone
          ),
        ),
        home: const LoginPage(),
      );
    });
  }
}