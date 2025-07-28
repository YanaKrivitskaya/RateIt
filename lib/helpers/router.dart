import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rateit/helpers/route_constants.dart';
import 'package:rateit/models/args_models/item_args.model.dart';
import 'package:rateit/models/args_models/property_edit_args.model.dart';
import 'package:rateit/models/collection.model.dart';
import 'package:rateit/views/auth/otp/cubit/otp_cubit.dart';
import 'package:rateit/views/auth/otp/otp_verification.view.dart';
import 'package:rateit/views/collection/collection_edit/cubit/collection_edit_cubit.dart';
import 'package:rateit/views/collection/collection_edit/collection_edit.view.dart';
import 'package:rateit/views/collection/collection_filters/collection_filters.view.dart';
import 'package:rateit/views/collection/collection_filters/cubit/collection_filters_cubit.dart';
import 'package:rateit/views/collection/collection_settings/collection_settings.view.dart';
import 'package:rateit/views/collection/collection_settings/cubit/collection_settings_cubit.dart';
import 'package:rateit/views/collection/collection_view/collection.view.dart';
import 'package:rateit/views/collection/collection_view/cubit/collection_view_cubit.dart';
import 'package:rateit/views/home/home.page.dart';
import 'package:rateit/views/items/item_edit/cubit/item_edit_cubit.dart';
import 'package:rateit/views/items/item_edit/image_crop.view.dart';
import 'package:rateit/views/items/item_edit/item_edit.view.dart';
import 'package:rateit/views/items/item_view/cubit/item_view_cubit.dart';
import 'package:rateit/views/items/item_view/item_view.dart';
import 'package:rateit/views/properties/properties_edit/property_edit.view.dart';
import 'package:rateit/views/properties/properties_edit/cubit/property_edit_cubit.dart';
import 'package:rateit/views/properties/properties_view/cubit/properties_view_cubit.dart';
import 'package:rateit/views/properties/properties_view/properties.view.dart';


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
      case editCollectionRoute:
        if (args is Collection) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider<CollectionEditCubit>(
              create: (context) => CollectionEditCubit()..loadCollection(args),
              child: CollectionEditView(),
            ),
          );}
        return MaterialPageRoute(
          builder: (_) => BlocProvider<CollectionEditCubit>(
            create: (context) => CollectionEditCubit()..initCollection(),
            child: CollectionEditView(),
          ),
        );
      case viewCollectionRoute:
        if (args is int) {
        return MaterialPageRoute(
          builder: (_) => BlocProvider<CollectionViewCubit>(
            create: (context) => CollectionViewCubit()..getCollection(args),
            child: CollectionView(),
          ),
        );}
        return _errorRoute();
      case viewPropertiesRoute:
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider<PropertiesViewCubit>(
              create: (context) => PropertiesViewCubit()..getProperties(args),
              child: PropertiesView(collectionId: args),
            ),
          );}
        return _errorRoute();
      case editPropertiesRoute:
        if (args is PropertyEditArgs) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider<PropertyEditCubit>(
              create: (context) => PropertyEditCubit()..loadProperty(args.property),
              child: PropertyEditView(collectionId: args.collectionId),
            ),
          );}
        return _errorRoute();
      case editItemRoute:
        if (args is ItemEditArgs) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider<ItemEditCubit>(
              create: (context) => ItemEditCubit()..loadItem(args.collectionId, args.item),
              child: ItemEditView(collectionId: args.collectionId),
            ),
          );}
        return _errorRoute();
      case viewItemRoute:
        if (args is ItemViewArgs) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider<ItemViewCubit>(
              create: (context) => ItemViewCubit()..getItem(args.collectionId, args.itemId),
              child: ItemView(collectionId: args.collectionId, itemId: args.itemId),
            ),
          );}
        return _errorRoute();
      case imageCropRoute:
        {
          if (args is ImageCropArguments) {
            return MaterialPageRoute(
                builder: (_) {
                  return ImageCropView(args.file, args.compress);
                }
            );
          }
          return _errorRoute();
        }
      case collectionSettingsRoute:
        if (args is Collection) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider<CollectionSettingsCubit>(
              create: (context) => CollectionSettingsCubit(args),
              child: CollectionSettingsView(),
            ),
          );}
        return _errorRoute();
      case collectionFiltersRoute:
        {
          if (args is Collection) {
            return MaterialPageRoute(
              builder: (_) => BlocProvider<CollectionFiltersCubit>(
                create: (context) => CollectionFiltersCubit(args)..getProperties(),
                child: CollectionFiltersView(),
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
