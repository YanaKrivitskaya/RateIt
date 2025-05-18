
import 'package:flutter/material.dart';

Widget loadingWidget(Color color) => Center(
  child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(color)
  ),
);