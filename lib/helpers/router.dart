import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rateit/helpers/route_constants.dart';
import 'package:rateit/views/auth/otp/cubit/otp_cubit.dart';
import 'package:rateit/views/collection/collection_edit/collection_edit_cubit.dart';
import 'package:rateit/views/collection/collection_edit/collection_edit_view.dart';
import 'package:rateit/views/home/home.page.dart';

import '../views/auth/otp/otp_verification_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage());
      case otpVerificationRoute:
        {
          if (args is String) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<OtpCubit>(
                create: (context) => OtpCubit(),
                child: OtpVerificationView(args),
              ),
            );
          }
          return _errorRoute();
        }
      case createCollectionRoute:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<CollectionEditCubit>(
            create: (context) => CollectionEditCubit()..initCollection(),
            child: CollectionEditView(),
          ),
        );
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
