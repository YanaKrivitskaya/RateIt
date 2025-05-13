import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sizer/sizer.dart';

final double fullWidth = 100.w;
final double fullHeight = 100.h;

//ANCHOR Width
final double width40 = 40.w;
final double width60 = 60.w;
final double width70 = 70.w;
final double width80 = 80.w;
final double width90 = 90.w;

// ANCHOR Height
final double sizerHeight = 15.h;
final double formPaddingHeight = 5.h;
final double scrollViewHeightXs = 15.h;
final double scrollViewHeightSm = 30.h;
final double scrollViewHeightMd = 35.h;
final double scrollViewHeightLg = 60.h;

//ANCHOR Font Size
final double headerFontSize = 25.sp; // View headers
final double smallHeaderFontSize = 20.sp; // View headers
final double accentFontSize = 16.sp; // Form headers
final double fontSize = 14.sp; // Form fields
final double fontSizesm = 12.sp;
final double fontSizexs = 10.sp;

TextStyle headerTextStyle({Color? color, double? fontSize, FontWeight? weight, TextDecoration? decoration}) =>
    GoogleFonts.playpenSans(textStyle: TextStyle(
        color: color ?? Colors.black,
        fontSize: fontSize,
        fontWeight: weight ?? FontWeight.normal,
        decoration: decoration));

TextStyle appTextStyle({Color? color, double? fontSize, FontWeight? weight, TextDecoration? decoration}) =>
    GoogleFonts.quicksand(textStyle: TextStyle(
        color: color ?? Colors.black,
        fontSize: fontSize,
        fontWeight: weight ?? FontWeight.normal,
        decoration: decoration));