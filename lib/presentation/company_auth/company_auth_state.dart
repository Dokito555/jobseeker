import 'package:equatable/equatable.dart';
import 'package:jobseeker/data/model/company_model.dart';

abstract class CompanyAuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CompanyAuthInitial extends CompanyAuthState {}

class CompanyAuthLoading extends CompanyAuthState {}

class CompanyAuthAuthenticated extends CompanyAuthState {
  final CompanyModel company;
  CompanyAuthAuthenticated(this.company);
  @override
  List<Object?> get props => [company];
}

class CompanyAuthUnauthenticated extends CompanyAuthState {}

class CompanyAuthRegisterSuccess extends CompanyAuthState {
  final String message;
  CompanyAuthRegisterSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class CompanyAuthError extends CompanyAuthState {
  final String message;
  CompanyAuthError(this.message);
  @override
  List<Object?> get props => [message];
}