import 'package:jobseeker/data/model/job_model.dart';
import 'package:jobseeker/data/source/local/company_auth_local_datasource.dart';
import 'package:jobseeker/data/source/remote/job_remote_datasource.dart';

abstract class JobRepository {
  Future<JobModel> createJob(CreateJobRequest request);
  Future<JobModel> getJobById(int id);
  Future<List<JobModel>> getAllJobs();
  Future<List<JobModel>> getJobsByCompany(int companyId);
  Future<JobModel> updateJob(int id, UpdateJobRequest request);
  Future<String> closeJob(int id);
  Future<String> deleteJob(int id);
}

class JobRepositoryImpl extends JobRepository {
  final JobRemoteDatasource remoteDatasource;
  final CompanyAuthLocalDatasource localDatasource;

  JobRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  Future<String> _getToken() async {
    final token = await localDatasource.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }
    return token;
  }

  @override
  Future<JobModel> createJob(CreateJobRequest request) async {
    try {
      final token = await _getToken();
      return await remoteDatasource.createJob(token, request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<JobModel> getJobById(int id) async {
    try {
      return await remoteDatasource.getJobById(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<JobModel>> getAllJobs() async {
    try {
      return await remoteDatasource.getAllJobs();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<JobModel>> getJobsByCompany(int companyId) async {
    try {
      return await remoteDatasource.getJobsByCompany(companyId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<JobModel> updateJob(int id, UpdateJobRequest request) async {
    try {
      final token = await _getToken();
      return await remoteDatasource.updateJob(token, id, request);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> closeJob(int id) async {
    try {
      final token = await _getToken();
      return await remoteDatasource.closeJob(token, id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> deleteJob(int id) async {
    try {
      final token = await _getToken();
      return await remoteDatasource.deleteJob(token, id);
    } catch (e) {
      rethrow;
    }
  }
}