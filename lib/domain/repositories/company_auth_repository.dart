import 'package:jobseeker/data/model/company_model.dart';
import 'package:jobseeker/data/source/local/company_auth_local_datasource.dart';
import 'package:jobseeker/data/source/remote/company_auth_remote_datasource.dart';

abstract class CompanyAuthRepository {
  Future<String> register(CompanyRegisterRequest request);
  Future<CompanyModel> login(CompanyLoginRequest request);
  Future<String> logout();
  Future<bool> isLoggedIn();
  Future<CompanyModel?> getCurrentCompany();
}

class CompanyAuthRepositoryImpl extends CompanyAuthRepository {
  final CompanyAuthRemoteDatasource remoteDatasource;
  final CompanyAuthLocalDatasource localDatasource;

  CompanyAuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<CompanyModel?> getCurrentCompany() async {
    return await localDatasource.getCompany();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDatasource.isLoggedIn();
  }

  @override
  Future<CompanyModel> login(CompanyLoginRequest request) async {
    final company = await remoteDatasource.login(request);
    await localDatasource.saveToken(company.token);
    await localDatasource.saveCompany(company);
    return company;
  }

  @override
  Future<String> logout() async {
    final token = await localDatasource.getToken();
    final String rsp = token != null ? await remoteDatasource.logout(token) : '';
    await localDatasource.clearAuth();
    return rsp;
  }

  @override
  Future<String> register(CompanyRegisterRequest request) async {
    return await remoteDatasource.register(request);
  }
}