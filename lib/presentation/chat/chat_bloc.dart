import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobseeker/domain/repositories/chat_repository.dart';
import 'package:jobseeker/presentation/chat/chat_event.dart';
import 'package:jobseeker/presentation/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  ChatBloc({required this.repository}) : super(ChatInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<PollNewMessagesEvent>(_onPollNewMessages);
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());
    try {
      final messages = await repository.getMessageHistory(event.jobVacancyId);
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final message = await repository.sendMessage(
        event.jobVacancyId,
        event.request,
      );
      
      // Reload messages after sending
      final messages = await repository.getMessageHistory(event.jobVacancyId);
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsReadEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      await repository.markAsRead(event.jobVacancyId);
      // Reload messages after marking as read
      final messages = await repository.getMessageHistory(event.jobVacancyId);
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> _onPollNewMessages(
    PollNewMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final messages = await repository.pollNewMessages(event.jobVacancyId);
      emit(ChatLoaded(messages));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}