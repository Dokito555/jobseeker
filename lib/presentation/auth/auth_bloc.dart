import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobseeker/domain/repositories/user_auth_repository.dart';
import 'package:jobseeker/presentation/auth/auth_event.dart';
import 'package:jobseeker/presentation/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserAuthRepository repo;

  AuthBloc({required this.repo}) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final message = await repo.register(event.request);
      emit(AuthRegisterSuccess(message));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await repo.login(event.request);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final message = await repo.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    final isLoggedIn = await repo.isLoggedIn();
    if (isLoggedIn) {
      final user = await repo.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }
}