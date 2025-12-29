import 'package:equatable/equatable.dart';
import 'package:jobseeker/data/model/job_model.dart';

abstract class JobState extends Equatable {
  @override
  List<Object?> get props => [];
}

class JobInitial extends JobState {}

class JobLoading extends JobState {}

class JobCreated extends JobState {
  final JobModel job;
  JobCreated(this.job);
  @override
  List<Object?> get props => [job];
}

class JobLoaded extends JobState {
  final JobModel job;
  JobLoaded(this.job);
  @override
  List<Object?> get props => [job];
}

class JobsLoaded extends JobState {
  final List<JobModel> jobs;
  JobsLoaded(this.jobs);
  @override
  List<Object?> get props => [jobs];
}

class JobUpdated extends JobState {
  final JobModel job;
  JobUpdated(this.job);
  @override
  List<Object?> get props => [job];
}

class JobClosed extends JobState {
  final String message;
  JobClosed(this.message);
  @override
  List<Object?> get props => [message];
}

class JobDeleted extends JobState {
  final String message;
  JobDeleted(this.message);
  @override
  List<Object?> get props => [message];
}

class JobError extends JobState {
  final String message;
  JobError(this.message);
  @override
  List<Object?> get props => [message];
}