import 'package:equatable/equatable.dart';
import 'package:jobseeker/data/model/job_model.dart';

abstract class JobEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateJobEvent extends JobEvent {
  final CreateJobRequest request;
  CreateJobEvent(this.request);
  @override
  List<Object?> get props => [request];
}

class GetJobByIdEvent extends JobEvent {
  final int id;
  GetJobByIdEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class GetAllJobsEvent extends JobEvent {}

class GetJobsByCompanyEvent extends JobEvent {
  final int companyId;
  GetJobsByCompanyEvent(this.companyId);
  @override
  List<Object?> get props => [companyId];
}

class UpdateJobEvent extends JobEvent {
  final int id;
  final UpdateJobRequest request;
  UpdateJobEvent(this.id, this.request);
  @override
  List<Object?> get props => [id, request];
}

class CloseJobEvent extends JobEvent {
  final int id;
  CloseJobEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class DeleteJobEvent extends JobEvent {
  final int id;
  DeleteJobEvent(this.id);
  @override
  List<Object?> get props => [id];
}