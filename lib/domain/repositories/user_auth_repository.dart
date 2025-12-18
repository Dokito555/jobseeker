import 'package:jobseeker/data/model/user_model.dart';
import 'package:jobseeker/data/source/local/auth_local_datasource.dart';
import 'package:jobseeker/data/source/remote/user_auth_remote_datasource.dart';

abstract class UserAuthRepository {
  Future<String> register(UserRegisterRequest request);
  Future<UserModel> login(UserLoginRequest request);
  Future<String> logout();
  Future<bool> isLoggedIn();
  Future<UserModel?> getCurrentUser();
}

class UserAuthRepositoryImpl extends UserAuthRepository {
  final UserAuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  UserAuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource
  });

  @override
  Future<UserModel?> getCurrentUser() async {
    return await localDatasource.getUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDatasource.isLoggedIn();
  }

  @override
  Future<UserModel> login(UserLoginRequest request) async {
    final user = await remoteDatasource.login(request);
    await localDatasource.saveToken(user.token);
    await localDatasource.saveUser(user);
    return user;
  }

  @override
  Future<String> logout() async {
    final token = await localDatasource.getToken();
    final String rsp = token != null 
      ? await remoteDatasource.logout(token)
      : '';
    await localDatasource.clearAuth();
    return rsp;
  }

  @override
  Future<String> register(UserRegisterRequest request) async {
    return await remoteDatasource.register(request);
  }
  
}