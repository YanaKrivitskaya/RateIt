
import 'dart:convert';

import 'package:rateit/models/account.model.dart';
import 'package:rateit/services/api.service.dart';

class ApiUserRepository{
  ApiService apiService = ApiService();
  String authUrl = 'auth/';

  Future<void> signInWithEmail(String email) async{
    var body = {
      "email": email
    };

    try{
      await apiService.sendOtpToEmail('${authUrl}verify-email', jsonEncode(body));
    } on Exception {
      rethrow;
    }
  }
  
  Future<Account> verifyOtp(String otp, String email) async{
    var body = {
      "email": email,
      "otp": otp
    };
    try{
      var response = await apiService.verifyOtp('${authUrl}login', jsonEncode(body));
      var user = Account.fromMap(response["account"]);
      return user;
    }on Exception {
      rethrow;
    }
  }

  Future<Account> getAccessToken() async{
    final response = await apiService.refreshToken();
    return Account.fromMap(response["account"]);
  }

  Future<Account> getUser(int userId) async{
    final response = await apiService.getSecure('${authUrl}/users/${userId.toString()}');
    return Account.fromMap(response);
  }

  Future<Account> updateEmail(String email) async{
    var body = {
      "email": email
    };
    final response = await apiService.putSecure('${authUrl}email', json.encode(body));

    return Account.fromMap(response["account"]);
  }

  Future<void> signOut() async {
    await apiService.signOut();
  }

}