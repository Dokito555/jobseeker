import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'company_model.g.dart';

@JsonSerializable()
class CompanyModel extends Equatable {
  final int id;
  final String email;
  final String name;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String address;
  final String description;
  final String token;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  CompanyModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.description,
    required this.token,
    required this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) => _$CompanyModelFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);
  
  @override
  List<Object?> get props => [
    id,
    email,
    name,
    phoneNumber,
    address,
    description,
    token,
    refreshToken,
    createdAt,
    updatedAt
  ];
}

@JsonSerializable()
class CompanyRegisterRequest {
  final String email;
  final String password;
  final String name;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String address;
  final String description;

  CompanyRegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.description,
  });

  Map<String, dynamic> toJson() => _$CompanyRegisterRequestToJson(this);
}

@JsonSerializable()
class CompanyLoginRequest {
  final String email;
  final String password;

  CompanyLoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$CompanyLoginRequestToJson(this);
}