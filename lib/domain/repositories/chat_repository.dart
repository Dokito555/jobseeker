import 'package:jobseeker/data/model/chat_model.dart';
import 'package:jobseeker/data/source/local/auth_local_datasource.dart';
import 'package:jobseeker/data/source/local/company_auth_local_datasource.dart';
import 'package:jobseeker/data/source/remote/chat_remote_datasource.dart';

abstract class ChatRepository {
  Future<ChatMessage> sendMessage(int jobVacancyId, SendMessageRequest request);
  Future<List<ChatMessage>> getMessageHistory(int jobVacancyId);
  Future<String> markAsRead(int jobVacancyId);
  Future<List<ChatMessage>> pollNewMessages(int jobVacancyId);
}

class ChatRepositoryImpl extends ChatRepository {
  final ChatRemoteDatasource remoteDatasource;
  final AuthLocalDatasource? userLocalDatasource;
  final CompanyAuthLocalDatasource? companyLocalDatasource;

  ChatRepositoryImpl({
    required this.remoteDatasource,
    this.userLocalDatasource,
    this.companyLocalDatasource,
  });

  Future<String?> _getToken() async {
    String? token = await userLocalDatasource?.getToken();
    token ??= await companyLocalDatasource?.getToken();
    return token;
  }

  @override
  Future<ChatMessage> sendMessage(
    int jobVacancyId,
    SendMessageRequest request,
  ) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      return await remoteDatasource.sendMessage(jobVacancyId, request, token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatMessage>> getMessageHistory(int jobVacancyId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      return await remoteDatasource.getMessageHistory(jobVacancyId, token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> markAsRead(int jobVacancyId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      return await remoteDatasource.markAsRead(jobVacancyId, token);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatMessage>> pollNewMessages(int jobVacancyId) async {
    try {
      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }
      return await remoteDatasource.pollNewMessages(jobVacancyId, token);
    } catch (e) {
      rethrow;
    }
  }
}