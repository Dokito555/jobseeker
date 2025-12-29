// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) => CompanyModel(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  name: json['name'] as String,
  phoneNumber: json['phone_number'] as String,
  address: json['address'] as String,
  description: json['description'] as String,
  token: json['token'] as String,
  refreshToken: json['refresh_token'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$CompanyModelToJson(CompanyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phone_number': instance.phoneNumber,
      'address': instance.address,
      'description': instance.description,
      'token': instance.token,
      'refresh_token': instance.refreshToken,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

CompanyRegisterRequest _$CompanyRegisterRequestFromJson(
  Map<String, dynamic> json,
) => CompanyRegisterRequest(
  email: json['email'] as String,
  password: json['password'] as String,
  name: json['name'] as String,
  phoneNumber: json['phone_number'] as String,
  address: json['address'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$CompanyRegisterRequestToJson(
  CompanyRegisterRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'name': instance.name,
  'phone_number': instance.phoneNumber,
  'address': instance.address,
  'description': instance.description,
};

CompanyLoginRequest _$CompanyLoginRequestFromJson(Map<String, dynamic> json) =>
    CompanyLoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$CompanyLoginRequestToJson(
  CompanyLoginRequest instance,
) => <String, dynamic>{'email': instance.email, 'password': instance.password};
