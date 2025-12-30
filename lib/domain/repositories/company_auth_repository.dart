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
    try {
      print('companyRepository: Login called');
      final company = await remoteDatasource.login(request);
      print('companyRepository: Got company data - ${company.name}');
      
      await localDatasource.saveToken(company.token);
      print('companyRepository: Token saved');
      
      await localDatasource.saveCompany(company);
      print('companyRepository: Company data saved');
      
      return company;
    } catch (e) {
      print('companyRepository: Login failed - $e');
      rethrow;
    }
  }

  @override
  Future<String> logout() async {
    try {
      final token = await localDatasource.getToken();
      String message = 'Logged out successfully';
      if (token != null && token.isNotEmpty) {
        try {
          message = await remoteDatasource.logout(token);
        } catch (e) {
          print('server logout failed: $e');
        }
      }
      await localDatasource.clearAuth();
      print('local company auth cleared');
      return message;
    } catch (e) {
      try {
        await localDatasource.clearAuth();
      } catch (clearError) {
        print('failed to clear local company auth: $clearError');
      }
      rethrow;
    }
  }

  @override
  Future<String> register(CompanyRegisterRequest request) async {
    return await remoteDatasource.register(request);
  }
}