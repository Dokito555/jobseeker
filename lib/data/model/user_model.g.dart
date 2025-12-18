// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  name: json['name'] as String,
  phoneNumber: json['phoneNumber'] as String,
  skills: (json['skills'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  token: json['token'] as String,
  refreshToken: json['refreshToken'] as String,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'name': instance.name,
  'phoneNumber': instance.phoneNumber,
  'skills': instance.skills,
  'token': instance.token,
  'refreshToken': instance.refreshToken,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

UserRegisterRequest _$UserRegisterRequestFromJson(Map<String, dynamic> json) =>
    UserRegisterRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      skillIds: (json['skillIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$UserRegisterRequestToJson(
  UserRegisterRequest instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'name': instance.name,
  'phoneNumber': instance.phoneNumber,
  'address': instance.address,
  'skillIds': instance.skillIds,
};

UserLoginRequest _$UserLoginRequestFromJson(Map<String, dynamic> json) =>
    UserLoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$UserLoginRequestToJson(UserLoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};
