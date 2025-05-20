
import 'dart:convert';

import 'package:rateit/models/custom_exception.dart';
import 'package:rateit/models/user.model.dart';
import 'package:rateit/services/api.service.dart';

class ApiUserRepository{
  ApiService apiService = ApiService();
  String authUrl = 'auth/';

  Future<void> sendOtp(String email) async{
    var body = {
      "email": email
    };

    try{
      await apiService.sendOtpToEmail('${authUrl}verify-email', jsonEncode(body));
    } on Exception {
      rethrow;
    }
  }
  
  Future<User> verifyOtp(String otp, String email) async{
    var body = {
      "email": email,
      "otp": otp
    };

    var response = await apiService.verifyOtp('${authUrl}login', jsonEncode(body));
    try{
      var user = User.fromMap(response["account"]);
      return user;
    }catch(e) {
      throw BadRequestException(e.toString());
    }
  }

  Future<User> getAccessToken() async{
    final response = await apiService.refreshToken();
    try{
      return User.fromMap(response["account"]);
    }
    catch(e) {
      throw BadRequestException(e.toString());
    }
  }

  Future<User> getUser(int userId) async{
    final response = await apiService.getSecure('${authUrl}/users/${userId.toString()}');
    try{
      return User.fromMap(response);
    }
    catch(e) {
      throw BadRequestException(e.toString());
    }
  }

  Future<User> updateEmail(String email) async{
    var body = {
      "email": email
    };
    final response = await apiService.putSecure('${authUrl}email', json.encode(body));
    try{
      return User.fromMap(response["account"]);
    }
    catch(e) {
      throw BadRequestException(e.toString());
    }
  }

  Future<void> signOut() async {
    await apiService.signOut();
  }

}