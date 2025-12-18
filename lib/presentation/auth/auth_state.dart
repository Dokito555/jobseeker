import 'package:equatable/equatable.dart';
import 'package:jobseeker/data/model/user_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState{}

class AuthLoading extends AuthState{}

class AuthAuthenticated extends AuthState{
  final UserModel user;
  AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState{}

class AuthRegisterSuccess extends AuthState{
  final String message;
  AuthRegisterSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthError extends AuthState{
  final String message;
  AuthError(this.message);
  @override 
  List<Object?> get props => [message];
}