import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobseeker/domain/repositories/job_repository.dart';
import 'package:jobseeker/presentation/job/job_event.dart';
import 'package:jobseeker/presentation/job/job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final JobRepository repository;

  JobBloc({required this.repository}) : super(JobInitial()) {
    on<CreateJobEvent>(_onCreateJob);
    on<GetJobByIdEvent>(_onGetJobById);
    on<GetAllJobsEvent>(_onGetAllJobs);
    on<GetJobsByCompanyEvent>(_onGetJobsByCompany);
    on<UpdateJobEvent>(_onUpdateJob);
    on<CloseJobEvent>(_onCloseJob);
    on<DeleteJobEvent>(_onDeleteJob);
  }

  Future<void> _onCreateJob(CreateJobEvent event, Emitter<JobState> emit) async {
    emit(JobLoading());
    try {
      final job = await repository.createJob(event.request);
      emit(JobCreated(job));
    } catch (e, stackTrace) {
      print('Create job error: $e');
      print('Stack trace: $stackTrace');
      emit(JobError(_getErrorMessage(e)));
    }
  }

  Future<void> _onGetJobById(GetJobByIdEvent event, Emitter<JobState> emit) async {
    emit(JobLoading());
    try {
      final job = await repository.getJobById(event.id);
      emit(JobLoaded(job));
    } catch (e, stackTrace) {
      print('Get job error: $e');
      print('Stack trace: $stackTrace');
      emit(JobError(_getErrorMessage(e)));
    }
  }

  Future<void> _onGetAllJobs(GetAllJobsEvent event, Emitter<JobState> emit) async {
    emit(JobLoading());
    try {
      final jobs = await repository.getAllJobs();
      emit(JobsLoaded(jobs));
    } catch (e, stackTrace) {
      print('Get all jobs error: $e');
      print('Stack trace: $stackTrace');
      emit(JobError(_getErrorMessage(e)));
    }
  }

  Future<void> _onGetJobsByCompany(GetJobsByCompanyEvent event, Emitter<JobState> emit) async {
    emit(JobLoading());
    try {
      final jobs = await repository.getJobsByCompany(event.companyId);
      emit(JobsLoaded(jobs));
    } catch (e, stackTrace) {
      print('Get company jobs error: $e');
      print('Stack trace: $stackTrace');
      emit(JobError(_getErrorMessage(e)));
    }
  }

  Future<void> _onUpdateJob(UpdateJobEvent event, Emitter<JobState> emit) async {
    emit(JobLoading());
    try {
      final job = await repository.updateJob(event.id, event.request);
      emit(JobUpdated(job));
    } catch (e, stackTrace) {
      print('Update job error: $e');
      print('Stack trace: $stackTrace');
      emit(JobError(_getErrorMessage(e)));
    }
  }

  Future<void> _onCloseJob(CloseJobEvent event, Emitter<JobState> emit) async {
    emit(JobLoading());
    try {
      final message = await repository.closeJob(event.id);
      emit(JobClosed(message));
    } catch (e, stackTrace) {
      print('Close job error: $e');
      print('Stack trace: $stackTrace');
      emit(JobError(_getErrorMessage(e)));
    }
  }

  Future<void> _onDeleteJob(DeleteJobEvent event, Emitter<JobState> emit) async {
    emit(JobLoading());
    try {
      final message = await repository.deleteJob(event.id);
      emit(JobDeleted(message));
    } catch (e, stackTrace) {
      print('Delete job error: $e');
      print('Stack trace: $stackTrace');
      emit(JobError(_getErrorMessage(e)));
    }
  }

  String _getErrorMessage(dynamic error) {
    final errorString = error.toString();
    
    if (errorString.contains('SocketException') || errorString.contains('Failed host lookup')) {
      return 'No internet connection. Please check your network.';
    }
    
    if (errorString.contains('TimeoutException')) {
      return 'Connection timeout. Please try again.';
    }
    
    if (errorString.contains('Not authenticated')) {
      return 'Please login to continue.';
    }
    
    if (errorString.contains('401')) {
      return 'Unauthorized. Please login again.';
    }
    
    if (errorString.contains('404')) {
      return 'Job not found.';
    }
    
    if (errorString.contains('500')) {
      return 'Server error. Please try again later.';
    }
    
    if (errorString.startsWith('Exception: ')) {
      return errorString.substring(11);
    }
    
    return errorString.length > 100 
        ? 'An error occurred. Please try again.' 
        : errorString;
  }
}