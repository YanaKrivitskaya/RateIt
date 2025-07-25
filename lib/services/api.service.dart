import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:rateit/models/api_models/api_attachments.model.dart';
import 'package:rateit/models/custom_exception.dart';
import 'package:rateit/services/secure_storage.service.dart';
import 'package:device_info_plus/device_info_plus.dart';
//import 'package:image_cropper/image_crop_view.dart';

class ApiService {
  static ApiService? _instance;

  // ANCHOR API URLs
  static String _baseUrl = "http://10.0.2.2:8080/"; //emulator
  //static final String _baseUrl = "http://192.168.7.109:8080/"; // local IP
  //static String _baseUrl = "http://192.168.7.200:3002/"; // Local NAS
  //static String _baseUrl = "http://178.124.197.224:8002/"; // External NAS
  static SecureStorage? _storage;
  static String? _accessToken;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  static String? _deviceId;

  ApiService._internal() {
    _storage = SecureStorage();
    _instance = this;
  }

  factory ApiService() => _instance ?? ApiService._internal();

  static Future<dynamic> init() async{
    if(kIsWeb){
      WebBrowserInfo webInfo = await deviceInfoPlugin.webBrowserInfo;
      _deviceId = webInfo.userAgent;
    }else{
      if(Platform.isAndroid){
        await deviceInfoPlugin.androidInfo.then((data) => _deviceId = data.id);
      }else if (Platform.isIOS) {
        await deviceInfoPlugin.iosInfo.then((data) => _deviceId = data.identifierForVendor);
      }else if (Platform.isWindows) {
        await deviceInfoPlugin.windowsInfo.then((data) => _deviceId = data.deviceId);
      }
    }
  }

  Future<dynamic> refreshToken() async{
    print("refreshToken");
    dynamic responseJson;

    var refreshToken = await _storage!.read(key: "refresh_token");
    if (refreshToken == null) throw UnauthorizedException();
    var body = {
      "token": refreshToken,
      "device": _deviceId
    };

    try{
      final response = await http.post(
          Uri.parse('${_baseUrl}auth/refresh-token'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
            "Device-info": _deviceId ?? ''
          },
          body: body
      );
      responseJson = await _response(response);
      _accessToken = responseJson["accessToken"];

    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection (${e.message})');
    }
    return responseJson;
  }

  Future<dynamic> sendOtpToEmail(String url, String body) async{
    dynamic responseJson;
    Uri uri = Uri.parse(_baseUrl + url);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json"
    };

    try{
      responseJson = await sendPost(uri, headers, body);
      var verificationKey = responseJson["verificationKey"];
      await _storage!.write(key: "verificationKey", value: verificationKey);

    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection (${e.message})');
    }

    return responseJson;
  }

  Future<dynamic> verifyOtp(String url, String body) async{
    dynamic responseJson;
    Uri uri = Uri.parse(_baseUrl + url);

    var verificationKey = await _storage!.read(key: "verificationKey");
    if(verificationKey == null) throw "Verification key not found";
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      "verification-key": verificationKey,
      "device-info": _deviceId ?? ''
    };

    try{
      responseJson = await sendPost(uri, headers, body);
    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection (${e.message})');
    } catch(e){
      rethrow;
    }

    return responseJson;
  }

  Future<dynamic> signOut() async{
    print("signOut");
    dynamic responseJson;

    Uri uri = Uri.parse('${_baseUrl}auth/revoke-token');

    var token = await _storage!.read(key: "refresh_token");
    if (token == null) throw UnauthorizedException();
    var body = {
      "token": token,
      "device": _deviceId
    };

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_accessToken",
      "device-info": _deviceId ?? ''
    };

    try{
      responseJson = await sendPost(uri, headers, json.encode(body));
      await _storage!.delete(key: "refresh_token");
      _accessToken = null;
    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection (${e.message})');
    }on UnauthorizedException {
      await refreshToken();

      headers["authorization"] = "Bearer $_accessToken";

      token = await _storage!.read(key: "refresh_token");
      if (token == null) throw UnauthorizedException();
      body = {
        "token": token
      };

      responseJson = await sendPost(uri, headers, json.encode(body));
      await _storage!.delete(key: "refresh_token");
      _accessToken = null;
    }
    return responseJson;
  }

  Future<dynamic> get(String url) async{
    print("get $url");
    dynamic responseJson;
    Uri uri = Uri.parse(_baseUrl + url);

    try{
      responseJson = await sendGet(uri, null);
    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection (${e.message})');
    }
    return responseJson;
  }

  Future<dynamic> getSecure(String url, {Map<String, dynamic>? queryParams, bool isRaw = false}) async{
    print("getSecure $url");
    dynamic responseJson;

    String queryString = Uri(queryParameters: queryParams).query;

    Uri uri = Uri.parse('$_baseUrl$url?$queryString');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $_accessToken",
      "device-info": _deviceId ?? '',
      "Connection": "Keep-Alive",
      "Keep-Alive": "timeout=20, max=1"
    };

    try{
      responseJson = await sendGet(uri, headers, isRaw: isRaw);
    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection (${e.message})');
    }on UnauthorizedException {
      await refreshToken();

      headers["authorization"] = "Bearer $_accessToken";

      responseJson = await sendGet(uri, headers);
    }

    return responseJson;
  }

  Future<dynamic> post(String url, String body) async{
    print("post $url");
    dynamic responseJson;
    Uri uri = Uri.parse(_baseUrl + url);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      "device-info": _deviceId ?? ''
    };

    try{
      responseJson = await sendPost(uri, headers, body);
      _accessToken = responseJson["accessToken"] ?? _accessToken;
    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection (${e.message})');
    }

    return responseJson;
  }

  Future<dynamic> postSecure(String url, String? body) async{
    print("postSecure $url");
    dynamic responseJson;

    Uri uri = Uri.parse(_baseUrl + url);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_accessToken",
      "device-info": _deviceId ?? ''
    };

    try{
      responseJson = await sendPost(uri, headers, body);
    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection (${e.message})');
    }on UnauthorizedException {
      await refreshToken();

      headers["authorization"] = "Bearer $_accessToken";

      responseJson = await sendPost(uri, headers, body);
    }
    return responseJson;
  }

  Future<dynamic> postSecureMultipart(String url, List<ApiAttachmentModel>? files) async{
    print("postSecureMultipart $url");
    dynamic responseJson;

    var request = http.MultipartRequest("POST", Uri.parse(_baseUrl + url));

    request.headers["Content-Type"] = "multipart/form-data";
    request.headers["Authorization"] = "Bearer $_accessToken";
    request.headers["device-info"] = _deviceId ?? '';

    if(files != null){
      for(var file in files){
        request.files.add(http.MultipartFile.fromBytes("files", file.source, filename: file.filename));
      }
    }

    try{
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson = await  _response(response);
    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection (${e.message})');
    }on UnauthorizedException {
      await refreshToken();

      request.headers["Authorization"] = "Bearer $_accessToken";

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      responseJson = await  _response(response);
    }
    return responseJson;
  }

  Future<dynamic> putSecure(String url, String body) async{
    print("putSecure $url");
    dynamic responseJson;

    Uri uri = Uri.parse(_baseUrl + url);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $_accessToken",
      "device-info": _deviceId ?? ''
    };

    try{
      responseJson = await sendPut(uri, headers, body);
    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection (${e.message})');
    }on UnauthorizedException {
      await refreshToken();

      headers["authorization"] = "Bearer $_accessToken";

      responseJson = await sendPut(uri, headers, body);
    }
    return responseJson;
  }

  Future<dynamic> deleteSecure(String url) async{
    print("deleteSecure $url");
    dynamic responseJson;

    Uri uri = Uri.parse(_baseUrl + url);
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $_accessToken",
      "device-info": _deviceId ?? ''
    };

    try{
      responseJson = await sendDelete(uri, headers);
    }on SocketException catch(e) {
      throw ConnectionException('No Internet connection (${e.message})');
    }on UnauthorizedException {
      await refreshToken();

      headers["authorization"] = "Bearer $_accessToken";

      responseJson = await sendDelete(uri, headers);
    }
    return responseJson;
  }

  Future<dynamic> sendGet(Uri uri, Map<String, String>? headers, {bool isRaw = false}) async{
    var response = await http.get(uri, headers: headers).timeout(
      const Duration(seconds: 15),
    );
    return await _response(response, isRaw: isRaw);
  }

  Future<dynamic> sendPost(Uri uri, Map<String, String> headers, String? body) async{
    var response = await http.post(uri, headers: headers, body: body);
    return await _response(response);
  }

  Future<dynamic> sendPut(Uri uri, Map<String, String> headers, String body) async{
    var response = await http.put(uri, headers: headers, body: body);
    return await _response(response);
  }

  Future<dynamic> sendDelete(Uri uri, Map<String, String> headers) async{
    var response = await http.delete(uri, headers: headers);
    return await _response(response);
  }

  dynamic _response(http.Response response, {bool isRaw = false}) async{
    if(response.headers["set-cookie"] != null){
      var refreshToken = response.headers["set-cookie"].toString().split(';')[0].substring(13);
      await _storage!.write(key: "refresh_token", value: refreshToken);
    }
    dynamic errorMessage;

    if(response.statusCode != 200){
      errorMessage = jsonDecode(response.body.toString())["message"];
    }

    switch(response.statusCode){
      case 200: {
        if(isRaw) {
          return response;
        } else{
          Map<String, dynamic>? data = json.decode(response.body.toString());
          return data;
        }
      }
      case 400:
        throw BadRequestException(errorMessage);
      case 401:
        throw UnauthorizedException(errorMessage);
      case 403:
        throw ForbiddenException(errorMessage);
      default:
        throw CustomException(Error.Default,
            'Server Error. StatusCode: ${response.statusCode}. Error: $errorMessage');
    }
  }

}