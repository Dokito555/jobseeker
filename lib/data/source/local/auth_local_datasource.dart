import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:jobseeker/data/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDatasource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearAuth();
  Future<bool> isLoggedIn();
}

class AuthLocalDatasourceImpl extends AuthLocalDatasource {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  @override
  Future<void> clearAuth() async {
   final prefs = await SharedPreferences.getInstance();
   await prefs.remove(_tokenKey);
   await prefs.remove(_userKey); 
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    debugPrint("user from prefs: $userData");
    if (userData  != null) {
      return UserModel.fromJson(json.decode(userData));
    }
    return null;
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }
  
}