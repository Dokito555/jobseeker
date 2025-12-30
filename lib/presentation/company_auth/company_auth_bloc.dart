import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobseeker/domain/repositories/company_auth_repository.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_event.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_state.dart';

class CompanyAuthBloc extends Bloc<CompanyAuthEvent, CompanyAuthState> {
  final CompanyAuthRepository repo;

  CompanyAuthBloc({required this.repo}) : super(CompanyAuthInitial()) {
    on<CompanyRegisterEvent>(_onRegister);
    on<CompanyLoginEvent>(_onLogin);
    on<CompanyLogoutEvent>(_onLogout);
    on<CheckCompanyAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onRegister(CompanyRegisterEvent event, Emitter<CompanyAuthState> emit) async {
    emit(CompanyAuthLoading());
    try {
      final message = await repo.register(event.request);
      emit(CompanyAuthRegisterSuccess(message));
    } catch (e, stackTrace) {
      print('company register error: $e');
      print('Stack trace: $stackTrace');
      emit(CompanyAuthError(_getErrorMessage(e)));
    }
  }

  Future<void> _onLogin(CompanyLoginEvent event, Emitter<CompanyAuthState> emit) async {
    emit(CompanyAuthLoading());
    try {
      final company = await repo.login(event.request);
      emit(CompanyAuthAuthenticated(company));
    } catch (e, stackTrace) {
      emit(CompanyAuthError(_getErrorMessage(e)));
    }
  }

  Future<void> _onLogout(CompanyLogoutEvent event, Emitter<CompanyAuthState> emit) async {
    emit(CompanyAuthLoading());
    try {
      await repo.logout();
      emit(CompanyAuthUnauthenticated());
    } catch (e, stackTrace) {
      emit(CompanyAuthUnauthenticated());
    }
  }

  Future<void> _onCheckAuthStatus(CheckCompanyAuthStatusEvent event, Emitter<CompanyAuthState> emit) async {
    try {
      final isLoggedIn = await repo.isLoggedIn();
      if (isLoggedIn) {
        final company = await repo.getCurrentCompany();
        if (company != null) {
          emit(CompanyAuthAuthenticated(company));
        } else {
          emit(CompanyAuthUnauthenticated());
        }
      } else {
        emit(CompanyAuthUnauthenticated());
      }
    } catch (e, stackTrace) {
      emit(CompanyAuthUnauthenticated());
    }
  }

  String _getErrorMessage(dynamic error) {
    final errorString = error.toString();
    
    if (errorString.contains('SocketException') || errorString.contains('Failed host lookup')) {
      return 'No internet connection. Please check your network.';
    }
    
    if (errorString.contains('TimeoutException')) {
      return 'Connection timeout. Please try again.';
    }
    
    if (errorString.contains('FormatException') || errorString.contains('not a subtype')) {
      return 'Invalid data format received from server. Please contact support.';
    }
    
    if (errorString.contains('401')) {
      return 'Invalid email or password.';
    }
    
    if (errorString.contains('404')) {
      return 'Service not found. Please try again later.';
    }
    
    if (errorString.contains('500')) {
      return 'Server error. Please try again later.';
    }
    
    if (errorString.startsWith('Exception: ')) {
      return errorString.substring(11);
    }
    
    return errorString.length > 100 
        ? 'An error occurred. Please try again.' 
        : errorString;
  }
}