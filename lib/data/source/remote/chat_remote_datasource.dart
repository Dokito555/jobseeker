// lib/data/source/remote/chat_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobseeker/data/model/chat_model.dart';

abstract class ChatRemoteDatasource {
  Future<ChatMessage> sendMessage(int jobVacancyId, SendMessageRequest request, String token);
  Future<List<ChatMessage>> getMessageHistory(int jobVacancyId, String token);
  Future<String> markAsRead(int jobVacancyId, String token);
  Future<List<ChatMessage>> pollNewMessages(int jobVacancyId, String token);
}

class ChatRemoteDatasourceImpl extends ChatRemoteDatasource {
  final baseURL = 'http://10.0.2.2:9001/api/v1/chat';

  @override
  Future<ChatMessage> sendMessage(
    int jobVacancyId,
    SendMessageRequest request,
    String token,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/$jobVacancyId/send'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        return ChatMessage.fromJson(data['data']);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to send message');
      }
    } catch (e) {
      throw Exception('Send message error: $e');
    }
  }

  @override
  Future<List<ChatMessage>> getMessageHistory(
    int jobVacancyId,
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/$jobVacancyId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final List<dynamic> messagesJson = data['data'];
        return messagesJson.map((json) => ChatMessage.fromJson(json)).toList();
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to get messages');
      }
    } catch (e) {
      throw Exception('Get messages error: $e');
    }
  }

  @override
  Future<String> markAsRead(int jobVacancyId, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/$jobVacancyId/read'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] ?? 'Marked as read';
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to mark as read');
      }
    } catch (e) {
      throw Exception('Mark as read error: $e');
    }
  }

  @override
  Future<List<ChatMessage>> pollNewMessages(
    int jobVacancyId,
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/$jobVacancyId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final List<dynamic> messagesJson = data['data'];
        return messagesJson.map((json) => ChatMessage.fromJson(json)).toList();
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to poll messages');
      }
    } catch (e) {
      throw Exception('Poll messages error: $e');
    }
  }
}