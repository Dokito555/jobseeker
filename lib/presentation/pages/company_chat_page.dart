// Note: Company chat functionality already exists in chat_page.dart
// This is a themed wrapper/alternative if you want a separate company chat page
// The backend logic is the same, just styled for company context

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobseeker/data/model/chat_model.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_bloc.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_state.dart';
import 'package:jobseeker/presentation/chat/chat_bloc.dart';
import 'package:jobseeker/presentation/chat/chat_event.dart';
import 'package:jobseeker/presentation/chat/chat_state.dart';

class CompanyChatPage extends StatefulWidget {
  final int jobVacancyId;
  final String jobTitle;

  const CompanyChatPage({
    super.key,
    required this.jobVacancyId,
    required this.jobTitle,
  });

  @override
  State<CompanyChatPage> createState() => _CompanyChatPageState();
}

class _CompanyChatPageState extends State<CompanyChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessagesEvent(widget.jobVacancyId));
    context.read<ChatBloc>().add(MarkAsReadEvent(widget.jobVacancyId));
    
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      context.read<ChatBloc>().add(PollNewMessagesEvent(widget.jobVacancyId));
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _pollTimer?.cancel();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<ChatBloc>().add(
            SendMessageEvent(
              widget.jobVacancyId,
              SendMessageRequest(message: message),
            ),
          );
      _messageController.clear();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _getCurrentUserId() {
    final companyState = context.read<CompanyAuthBloc>().state;
    if (companyState is CompanyAuthAuthenticated) {
      return 'COMPANY_${companyState.company.id}';
    }
    return '';
  }

  bool _isCurrentUser(ChatMessage message) {
    final currentUserId = _getCurrentUserId();
    final messageSenderId = '${message.senderType}_${message.senderId}';
    return currentUserId == messageSenderId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF540863),
        foregroundColor: const Color(0xFFFCF5EE),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.jobTitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Chat dengan Pelamar',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xFFFFD3D5),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                } else if (state is ChatError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ChatLoaded) {
                  if (state.messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: const Color(0xFF92487A),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada pesan',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF92487A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Mulai percakapan dengan pelamar',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF92487A),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isMe = _isCurrentUser(message);

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? const Color(0xFF540863)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: isMe
                                ? null
                                : Border.all(
                                    color: const Color(0xFFE49BA6),
                                    width: 2,
                                  ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMe)
                                Text(
                                  message.senderName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: const Color(0xFF540863),
                                  ),
                                ),
                              if (!isMe) const SizedBox(height: 4),
                              Text(
                                message.message,
                                style: GoogleFonts.poppins(
                                  color: isMe
                                      ? const Color(0xFFFCF5EE)
                                      : const Color(0xFF43334C),
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatTime(message.createdAt),
                                style: GoogleFonts.poppins(
                                  color: isMe
                                      ? const Color(0xFFFFD3D5)
                                      : const Color(0xFF92487A),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ChatError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(state.message),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ChatBloc>().add(
                                  LoadMessagesEvent(widget.jobVacancyId),
                                );
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: const Color(0xFFE49BA6),
                  width: 2,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      hintStyle: GoogleFonts.poppins(
                        color: const Color(0xFF92487A),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: Color(0xFFE49BA6),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: Color(0xFFE49BA6),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: Color(0xFF540863),
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF540863),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Color(0xFFFCF5EE),
                    ),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}