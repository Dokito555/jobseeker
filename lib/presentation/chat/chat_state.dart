// lib/presentation/chat/chat_state.dart

import 'package:equatable/equatable.dart';
import 'package:jobseeker/data/model/chat_model.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<ChatMessage> messages;

  ChatLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class ChatMessageSent extends ChatState {
  final ChatMessage message;

  ChatMessageSent(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatMarkedAsRead extends ChatState {
  final String message;

  ChatMarkedAsRead(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);

  @override
  List<Object?> get props => [message];
}