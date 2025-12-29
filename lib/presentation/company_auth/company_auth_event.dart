import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jobseeker/data/model/company_model.dart';

abstract class CompanyAuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CompanyRegisterEvent extends CompanyAuthEvent {
  final CompanyRegisterRequest request;
  CompanyRegisterEvent(this.request);
  @override
  List<Object?> get props => [request];
}

class CompanyLoginEvent extends CompanyAuthEvent {
  final CompanyLoginRequest request;
  CompanyLoginEvent(this.request);
  @override
  List<Object?> get props => [request];
}

class CompanyLogoutEvent extends CompanyAuthEvent {}

class CheckCompanyAuthStatusEvent extends CompanyAuthEvent {}