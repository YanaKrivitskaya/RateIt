
import 'package:flutter/material.dart';
import 'package:rateit/helpers/styles.dart';

import 'colors.dart';

Widget loadingWidget(Color color) => Center(
  child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(color)
  ),
);

enum SnackBarState {info, loading, error, success}

SnackBar customSnackBar(SnackBarState state, String? text, Duration? duration) => SnackBar(
  duration: duration ?? Duration(seconds: 2),
  content: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: state == SnackBarState.loading ? [
      CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(ColorsPalette.lynxWhite),
      ),
    ] : [
      SizedBox(
        width: width80,
        child: Text(
          text ?? '',
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
        ),
      ),
    ],
  ),
  backgroundColor:
    (state == SnackBarState.info || state == SnackBarState.loading)
        ? ColorsPalette.boyzone :
    state == SnackBarState.error ? ColorsPalette.desire : ColorsPalette.algalFuel,
);