import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final int id;
  final String email;
  final String name;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final List<String> skills;
  final String token;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.skills,
    required this.token,
    required this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  @override
  List<Object?> get props => [
    id,
    email,
    name,
    phoneNumber,
    skills,
    token,
    refreshToken,
    createdAt,
    updatedAt
  ];
}

@JsonSerializable()
class UserRegisterRequest {
  final String email;
  final String password;
  final String name;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String address;
  @JsonKey(name: 'skill_ids')
  final List<int> skillIds;

  UserRegisterRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
    required this.address,
    required this.skillIds,
  });

  Map<String, dynamic> toJson() => _$UserRegisterRequestToJson(this);
}

@JsonSerializable()
class UserLoginRequest {
  final String email;
  final String password;

  UserLoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$UserLoginRequestToJson(this);
}