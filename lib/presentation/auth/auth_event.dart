import 'package:equatable/equatable.dart';
import 'package:jobseeker/data/model/user_model.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterEvent extends AuthEvent{
  final UserRegisterRequest request;
  RegisterEvent(this.request);
  @override
  List<Object?> get props => [request];
}

class LoginEvent extends AuthEvent{
  final UserLoginRequest request;
  LoginEvent(this.request);
  @override
  List<Object?> get props => [request];
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}