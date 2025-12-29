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
    } catch (e) {
      emit(CompanyAuthError(e.toString()));
    }
  }

  Future<void> _onLogin(CompanyLoginEvent event, Emitter<CompanyAuthState> emit) async {
    emit(CompanyAuthLoading());
    try {
      final company = await repo.login(event.request);
      emit(CompanyAuthAuthenticated(company));
    } catch (e) {
      emit(CompanyAuthError(e.toString()));
    }
  }

  Future<void> _onLogout(CompanyLogoutEvent event, Emitter<CompanyAuthState> emit) async {
    emit(CompanyAuthLoading());
    try {
      await repo.logout();
      emit(CompanyAuthUnauthenticated());
    } catch (e) {
      emit(CompanyAuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(CheckCompanyAuthStatusEvent event, Emitter<CompanyAuthState> emit) async {
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
  }
}