import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:jobseeker/data/model/company_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CompanyAuthLocalDatasource {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> saveCompany(CompanyModel company);
  Future<CompanyModel?> getCompany();
  Future<void> clearAuth();
  Future<bool> isLoggedIn();
}

class CompanyAuthLocalDatasourceImpl extends CompanyAuthLocalDatasource {
  static const String _tokenKey = 'company_auth_token';
  static const String _companyKey = 'company_data';

  @override
  Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_companyKey);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<CompanyModel?> getCompany() async {
    final prefs = await SharedPreferences.getInstance();
    final companyData = prefs.getString(_companyKey);
    debugPrint("company from prefs: $companyData");
    if (companyData != null) {
      return CompanyModel.fromJson(json.decode(companyData));
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
  Future<void> saveCompany(CompanyModel company) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_companyKey, json.encode(company.toJson()));
  }
}