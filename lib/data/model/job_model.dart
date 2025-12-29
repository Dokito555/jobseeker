import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'job_model.g.dart';

@JsonSerializable()
class JobModel extends Equatable {
  final int id;
  @JsonKey(name: 'company_id')
  final int companyId;
  @JsonKey(name: 'company_name')
  final String companyName;
  final String position;
  final String description;
  final String location;
  @JsonKey(name: 'work_type')
  final String workType;
  @JsonKey(name: 'min_salary')
  final int minSalary;
  @JsonKey(name: 'max_salary')
  final int maxSalary;
  @JsonKey(name: 'required_skill')
  final List<String> requiredSkill;
  final String status;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  const JobModel({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.position,
    required this.description,
    required this.location,
    required this.workType,
    required this.minSalary,
    required this.maxSalary,
    required this.requiredSkill,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) => _$JobModelFromJson(json);
  Map<String, dynamic> toJson() => _$JobModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        companyId,
        companyName,
        position,
        description,
        location,
        workType,
        minSalary,
        maxSalary,
        requiredSkill,
        status,
        createdAt,
        updatedAt,
      ];
}

@JsonSerializable()
class CreateJobRequest extends Equatable {
  final String position;
  final String description;
  final String location;
  @JsonKey(name: 'work_type')
  final String workType;
  @JsonKey(name: 'min_salary')
  final int minSalary;
  @JsonKey(name: 'max_salary')
  final int maxSalary;
  @JsonKey(name: 'required_skills')
  final List<int> requiredSkills;

  const CreateJobRequest({
    required this.position,
    required this.description,
    required this.location,
    required this.workType,
    required this.minSalary,
    required this.maxSalary,
    required this.requiredSkills,
  });

  factory CreateJobRequest.fromJson(Map<String, dynamic> json) => 
      _$CreateJobRequestFromJson(json);
  Map<String, dynamic> toJson() => _$CreateJobRequestToJson(this);

  @override
  List<Object?> get props => [
        position,
        description,
        location,
        workType,
        minSalary,
        maxSalary,
        requiredSkills,
      ];
}

@JsonSerializable()
class UpdateJobRequest extends Equatable {
  final String position;
  final String description;
  final String location;
  @JsonKey(name: 'work_type')
  final String workType;
  @JsonKey(name: 'min_salary')
  final int minSalary;
  @JsonKey(name: 'max_salary')
  final int maxSalary;
  @JsonKey(name: 'required_skills')
  final List<int> requiredSkills;

  const UpdateJobRequest({
    required this.position,
    required this.description,
    required this.location,
    required this.workType,
    required this.minSalary,
    required this.maxSalary,
    required this.requiredSkills,
  });

  factory UpdateJobRequest.fromJson(Map<String, dynamic> json) => 
      _$UpdateJobRequestFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateJobRequestToJson(this);

  @override
  List<Object?> get props => [
        position,
        description,
        location,
        workType,
        minSalary,
        maxSalary,
        requiredSkills,
      ];
}