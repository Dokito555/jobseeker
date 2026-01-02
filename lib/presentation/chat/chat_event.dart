import 'package:equatable/equatable.dart';
import 'package:jobseeker/data/model/chat_model.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMessagesEvent extends ChatEvent {
  final int jobVacancyId;

  LoadMessagesEvent(this.jobVacancyId);

  @override
  List<Object?> get props => [jobVacancyId];
}

class SendMessageEvent extends ChatEvent {
  final int jobVacancyId;
  final SendMessageRequest request;

  SendMessageEvent(this.jobVacancyId, this.request);

  @override
  List<Object?> get props => [jobVacancyId, request];
}

class MarkAsReadEvent extends ChatEvent {
  final int jobVacancyId;

  MarkAsReadEvent(this.jobVacancyId);

  @override
  List<Object?> get props => [jobVacancyId];
}

class PollNewMessagesEvent extends ChatEvent {
  final int jobVacancyId;

  PollNewMessagesEvent(this.jobVacancyId);

  @override
  List<Object?> get props => [jobVacancyId];
}