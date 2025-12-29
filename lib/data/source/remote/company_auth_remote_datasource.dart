import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobseeker/data/model/company_model.dart';

abstract class CompanyAuthRemoteDatasource {
  Future<CompanyModel> login(CompanyLoginRequest request);
  Future<String> register(CompanyRegisterRequest request);
  Future<String> logout(String token);
}

class CompanyAuthRemoteDatasourceImpl extends CompanyAuthRemoteDatasource {
  final baseURL = 'http://10.0.2.2:9001/api/v1/company';

  @override
  Future<CompanyModel> login(CompanyLoginRequest request) async {
    try {
      final body = request.toJson();
      final jsonBody = json.encode(body);

      final response = await http.post(
        Uri.parse('$baseURL/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CompanyModel.fromJson(data['data']);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Login Failed');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  @override
  Future<String> register(CompanyRegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['message']?.toString() ?? 'Registration Successful';
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Registration Failed');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  @override
  Future<String> logout(String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseURL/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['message'] ?? 'Logout successful';
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Logout Failed');
      }
    } catch (e) {
      throw Exception('Logout error: $e');
    }
  }
}
