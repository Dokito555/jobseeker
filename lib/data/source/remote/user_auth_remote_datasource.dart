import 'dart:convert';

import 'package:jobseeker/data/model/user_model.dart';
import 'package:http/http.dart' as http;

abstract class UserAuthRemoteDatasource {
  Future<UserModel> login(UserLoginRequest request);
  Future<String> register(UserRegisterRequest request);
  Future<String> logout(String token);
}

class UserAuthRemoteDatasourceImpl extends UserAuthRemoteDatasource {
  final baseURL = 'http://10.0.2.2:9001/api/v1/user';

  @override
  Future<UserModel> login(UserLoginRequest request) async {
    try {

      final body = request.toJson();
      final jsonBody = json.encode(body);

      final response = await http.post(
        Uri.parse('$baseURL/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
         try {
          final user = UserModel.fromJson(data['data']);
          return user;
        } catch (e) {
          rethrow;
        }
        
      } else {
        final errorData  = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Login Failed');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  @override
  Future<String> register(UserRegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson())
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? 'Registration Successfull';
      } else {
        final errorData  = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Registration Failed');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }
  
  @override
  Future<String> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['message'] ?? 'Logout successfull';
      } else {
        final errorData  = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Logout Failed');
      }
    } catch (e) {
      throw Exception('Logout error: $e');
    }
  }
  
}