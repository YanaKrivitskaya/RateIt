
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:rateit/models/custom_exception.dart';
import 'package:rateit/models/user.model.dart';
import 'package:rateit/services/api.service.dart';

class ApiUserRepository{
  ApiService apiService = ApiService();
  String authUrl = 'auth/';
  final log = Logger('ApiUserRepository');

  Future<void> sendOtp(String email) async{
    log.info('sendOtp');
    var body = {
      "email": email
    };

    try{
      await apiService.sendOtpToEmail('${authUrl}verify-email', jsonEncode(body));
    } on Exception {
      log.shout('Something is wrong');
      rethrow;
    }
  }
  
  Future<User> verifyOtp(String otp, String email) async{
    log.info('verifyOtp');

    var body = {
      "email": email,
      "otp": otp
    };

    var response = await apiService.verifyOtp('${authUrl}login', jsonEncode(body));
    try{
      var user = User.fromMap(response["account"]);
      return user;
    }catch(e) {
      log.shout(e.toString());
      throw BadRequestException(e.toString());
    }
  }

  Future<User> getAccessToken() async{
    log.info('getAccessToken');

    final response = await apiService.refreshToken();
    try{
      return User.fromMap(response["account"]);
    }
    catch(e) {
      log.shout(e.toString());
      throw BadRequestException(e.toString());
    }
  }

  Future<User> getUser() async{
    log.info('getUser');

    final response = await apiService.getSecure('${authUrl}profile');

    try{
      return User.fromMap(response["user"]);
    }
    catch(e) {
      log.shout(e.toString());
      throw BadRequestException(e.toString());
    }
  }

  Future<User> updateEmail(String email) async{
    log.info('updateEmail');

    var body = {
      "email": email
    };
    final response = await apiService.putSecure('${authUrl}email', json.encode(body));
    try{
      return User.fromMap(response["account"]);
    }
    catch(e) {
      log.shout(e.toString());
      throw BadRequestException(e.toString());
    }
  }

  Future<void> signOut() async {
    log.info('signOut');
    await apiService.signOut();
  }

}