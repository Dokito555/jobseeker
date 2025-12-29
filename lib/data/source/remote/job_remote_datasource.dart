import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jobseeker/data/model/job_model.dart';

abstract class JobRemoteDatasource {
  Future<JobModel> createJob(String token, CreateJobRequest request);
  Future<JobModel> getJobById(int id);
  Future<List<JobModel>> getAllJobs();
  Future<List<JobModel>> getJobsByCompany(int companyId);
  Future<JobModel> updateJob(String token, int id, UpdateJobRequest request);
  Future<String> closeJob(String token, int id);
  Future<String> deleteJob(String token, int id);
}

class JobRemoteDatasourceImpl extends JobRemoteDatasource {
  final String baseURL = 'http://10.0.2.2:9001/api/v1';

  @override
  Future<JobModel> createJob(String token, CreateJobRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/company/jobs'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return JobModel.fromJson(data['data']);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to create job');
      }
    } catch (e) {
      throw Exception('Create job error: $e');
    }
  }

  @override
  Future<JobModel> getJobById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/jobs/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return JobModel.fromJson(data['data']);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to get job');
      }
    } catch (e) {
      throw Exception('Get job error: $e');
    }
  }

  @override
  Future<List<JobModel>> getAllJobs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/jobs'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final List<dynamic> jobsData = data['data'];
        return jobsData.map((json) => JobModel.fromJson(json)).toList();
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to get jobs');
      }
    } catch (e) {
      throw Exception('Get jobs error: $e');
    }
  }

  @override
  Future<List<JobModel>> getJobsByCompany(int companyId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/jobs/company/$companyId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        final List<dynamic> jobsData = data['data'];
        return jobsData.map((json) => JobModel.fromJson(json)).toList();
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to get company jobs');
      }
    } catch (e) {
      throw Exception('Get company jobs error: $e');
    }
  }

  @override
  Future<JobModel> updateJob(String token, int id, UpdateJobRequest request) async {
    try {
      final response = await http.put(
        Uri.parse('$baseURL/company/jobs/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return JobModel.fromJson(data['data']);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update job');
      }
    } catch (e) {
      throw Exception('Update job error: $e');
    }
  }

  @override
  Future<String> closeJob(String token, int id) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseURL/company/jobs/$id/close'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['data'] ?? 'Job closed successfully';
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to close job');
      }
    } catch (e) {
      throw Exception('Close job error: $e');
    }
  }

  @override
  Future<String> deleteJob(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseURL/company/jobs/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['data'] ?? 'Job deleted successfully';
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to delete job');
      }
    } catch (e) {
      throw Exception('Delete job error: $e');
    }
  }
}