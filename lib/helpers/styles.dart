import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sizer/sizer.dart';

final double fullWidth = 100.w;
final double fullHeight = 100.h;

//ANCHOR Width
final double width10 = 10.w;
final double width20 = 20.w;
final double width30 = 30.w;
final double width40 = 40.w;
final double width60 = 60.w;
final double width70 = 70.w;
final double width80 = 80.w;
final double width90 = 90.w;

// ANCHOR Height
final double sizerHeight = 15.h;
final double formPaddingHeight = 5.h;
final double scrollViewHeightXs = 15.h;
final double height20 = 20.h;
final double height30 = 30.h;
final double scrollViewHeightMd = 35.h;
final double scrollViewHeightLg = 60.h;

//ANCHOR Sizer
final double sizerHeightsm = 1.h;
final double sizerWidthsm = 1.w;
final double sizerWidthMd = 2.w;
final double sizerHeightMd = 1.5.h;
final double sizerHeightlg = 2.h;

//ANCHOR Padding
final double buttonPadding = 7.w; // Button padding
final double viewPadding = 4.w;
final double borderPadding = 3.w; // Border padding
final double borderPaddingSm = 2.w;
final double formBottomPadding = 4.h;
final double formTopPadding = 20.h;
final double imageCoverPadding = 2.5.h;
final double popupPadding = 8.h;

//ANCHOR Font Size
final double headerFontSize = 25.sp; // View headers
final double smallHeaderFontSize = 20.sp; // View headers
final double accentFontSize = 18.sp; // F
final double fontSize16 = 16.sp; // orm headers
final double fontSize = 14.sp; // Form fields
final double fontSizesm = 12.sp;
final double fontSizexs = 10.sp;

final double iconSize = 10.w;

TextStyle headerTextStyle({Color? color, double? fontSize, FontWeight? weight, TextDecoration? decoration}) =>
    GoogleFonts.playpenSans(textStyle: TextStyle(
        color: color ?? Colors.black,
        fontSize: headerFontSize,
        fontWeight: weight ?? FontWeight.normal,
        decoration: decoration));

TextStyle appTextStyle({Color? color, double? fontSize, FontWeight? weight, TextDecoration? decoration}) =>
    GoogleFonts.playpenSans(textStyle: TextStyle(
        color: color ?? Colors.black,
        fontSize: fontSize,
        fontWeight: weight ?? FontWeight.normal,
        decoration: decoration));