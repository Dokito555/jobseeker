import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_bloc.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_state.dart';
import 'package:jobseeker/presentation/job/job_bloc.dart';
import 'package:jobseeker/presentation/job/job_event.dart';
import 'package:jobseeker/presentation/job/job_state.dart';
import 'package:jobseeker/presentation/pages/company_chat_page.dart';

class CompanyChatListPage extends StatefulWidget {
  const CompanyChatListPage({super.key});

  @override
  State<CompanyChatListPage> createState() => _CompanyChatListPageState();
}

class _CompanyChatListPageState extends State<CompanyChatListPage> {
  @override
  void initState() {
    super.initState();
    // Load company jobs
    final authState = context.read<CompanyAuthBloc>().state;
    if (authState is CompanyAuthAuthenticated) {
      context.read<JobBloc>().add(GetJobsByCompanyEvent(authState.company.id));
    }
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
          'Percakapan Pelamar',
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
                      final authState = context.read<CompanyAuthBloc>().state;
                      if (authState is CompanyAuthAuthenticated) {
                        context.read<JobBloc>().add(
                          GetJobsByCompanyEvent(authState.company.id),
                        );
                      }
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
                      'Buat lowongan pekerjaan\nuntuk mulai menerima pelamar',
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
                final authState = context.read<CompanyAuthBloc>().state;
                if (authState is CompanyAuthAuthenticated) {
                  context.read<JobBloc>().add(
                    GetJobsByCompanyEvent(authState.company.id),
                  );
                }
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
              builder: (_) => CompanyChatPage(
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
              // Job Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD3D5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF540863),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.work_outline,
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
                    // Job Position
                    Text(
                      job.position,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF43334C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Status
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: job.status == 'ACTIVE'
                                ? Colors.green
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            job.status,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
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
                    
                    const SizedBox(height: 4),
                    
                    // Description hint
                    Text(
                      'Lihat pesan dari pelamar',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFF92487A),
                        fontStyle: FontStyle.italic,
                      ),
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