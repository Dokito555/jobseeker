import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobseeker/presentation/job/job_bloc.dart';
import 'package:jobseeker/presentation/job/job_event.dart';
import 'package:jobseeker/presentation/job/job_state.dart';
import 'package:jobseeker/presentation/pages/chat_page.dart';

class UserChatListPage extends StatefulWidget {
  const UserChatListPage({super.key});

  @override
  State<UserChatListPage> createState() => _UserChatListPageState();
}

class _UserChatListPageState extends State<UserChatListPage> {
  @override
  void initState() {
    super.initState();
    // Load all active jobs - nanti filter yang user pernah chat
    context.read<JobBloc>().add(GetAllJobsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF540863),
        foregroundColor: const Color(0xFFFCF5EE),
        elevation: 0,
        title: Text(
          'Percakapan Saya',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<JobBloc, JobState>(
        builder: (context, state) {
          if (state is JobLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF540863),
              ),
            );
          }

          if (state is JobError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<JobBloc>().add(GetAllJobsEvent());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF540863),
                      foregroundColor: const Color(0xFFFCF5EE),
                    ),
                    child: Text(
                      'Coba Lagi',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is JobsLoaded) {
            if (state.jobs.isEmpty) {
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
                      'Belum ada percakapan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF92487A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mulai chat dengan perusahaan\nmelalui lowongan pekerjaan',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF92487A),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: const Color(0xFF540863),
              onRefresh: () async {
                context.read<JobBloc>().add(GetAllJobsEvent());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.jobs.length,
                itemBuilder: (context, index) {
                  final job = state.jobs[index];
                  return _buildChatItem(job);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildChatItem(job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE49BA6),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatPage(
                jobVacancyId: job.id,
                jobTitle: job.position,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Company Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFE49BA6),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF540863),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.business_center,
                  color: Color(0xFF540863),
                  size: 28,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Company Name
                    Text(
                      job.companyName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF540863),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Job Position
                    Text(
                      job.position,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF43334C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: const Color(0xFF92487A),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            job.location,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0xFF92487A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Arrow
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: const Color(0xFF92487A),
              ),
            ],
          ),
        ),
      ),
    );
  }
}