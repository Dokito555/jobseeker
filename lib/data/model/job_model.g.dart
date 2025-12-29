// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobModel _$JobModelFromJson(Map<String, dynamic> json) => JobModel(
  id: (json['id'] as num).toInt(),
  companyId: (json['company_id'] as num).toInt(),
  companyName: json['company_name'] as String,
  position: json['position'] as String,
  description: json['description'] as String,
  location: json['location'] as String,
  workType: json['work_type'] as String,
  minSalary: (json['min_salary'] as num).toInt(),
  maxSalary: (json['max_salary'] as num).toInt(),
  requiredSkill: (json['required_skill'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  status: json['status'] as String,
  createdAt: json['created_at'] as String,
  updatedAt: json['updated_at'] as String,
);

Map<String, dynamic> _$JobModelToJson(JobModel instance) => <String, dynamic>{
  'id': instance.id,
  'company_id': instance.companyId,
  'company_name': instance.companyName,
  'position': instance.position,
  'description': instance.description,
  'location': instance.location,
  'work_type': instance.workType,
  'min_salary': instance.minSalary,
  'max_salary': instance.maxSalary,
  'required_skill': instance.requiredSkill,
  'status': instance.status,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

CreateJobRequest _$CreateJobRequestFromJson(Map<String, dynamic> json) =>
    CreateJobRequest(
      position: json['position'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      workType: json['work_type'] as String,
      minSalary: (json['min_salary'] as num).toInt(),
      maxSalary: (json['max_salary'] as num).toInt(),
      requiredSkills: (json['required_skills'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$CreateJobRequestToJson(CreateJobRequest instance) =>
    <String, dynamic>{
      'position': instance.position,
      'description': instance.description,
      'location': instance.location,
      'work_type': instance.workType,
      'min_salary': instance.minSalary,
      'max_salary': instance.maxSalary,
      'required_skills': instance.requiredSkills,
    };

UpdateJobRequest _$UpdateJobRequestFromJson(Map<String, dynamic> json) =>
    UpdateJobRequest(
      position: json['position'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      workType: json['work_type'] as String,
      minSalary: (json['min_salary'] as num).toInt(),
      maxSalary: (json['max_salary'] as num).toInt(),
      requiredSkills: (json['required_skills'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$UpdateJobRequestToJson(UpdateJobRequest instance) =>
    <String, dynamic>{
      'position': instance.position,
      'description': instance.description,
      'location': instance.location,
      'work_type': instance.workType,
      'min_salary': instance.minSalary,
      'max_salary': instance.maxSalary,
      'required_skills': instance.requiredSkills,
    };
