import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rateit/helpers/route_constants.dart';
import 'package:rateit/views/auth/otp/cubit/otp_cubit.dart';

import '../views/auth/otp/otp_verification_view.dart';
import '../views/temp.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => Temp());
      case otpVerificationRoute:
        {
          if (args is String) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<OtpCubit>(
                create: (context) => OtpCubit()
                /*..add(OtpSent(args))*/,
                child: OtpVerificationView(args),
              ),
            );
          }
          return _errorRoute();
        }
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Oops'),
        ),
        body: Center(
          child: Text('Something went wrong'),
        ),
      );
    });
  }
}
