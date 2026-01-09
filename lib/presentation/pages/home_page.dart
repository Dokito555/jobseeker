// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jobseeker/data/model/user_model.dart';
// import 'package:jobseeker/presentation/auth/auth_bloc.dart';
// import 'package:jobseeker/presentation/auth/auth_event.dart';
// import 'package:jobseeker/presentation/auth/auth_state.dart';
// import 'package:jobseeker/presentation/job/job_bloc.dart';
// import 'package:jobseeker/presentation/job/job_event.dart';
// import 'package:jobseeker/presentation/job/job_state.dart';
// import 'package:jobseeker/presentation/pages/job_detail_page.dart';
// import 'package:jobseeker/presentation/pages/login_page.dart';
// import 'package:intl/intl.dart';
// import 'package:jobseeker/presentation/pages/auth_selection_page.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   UserModel? user;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     _loadJobs();
//   }

//   void _loadUserData() {
//     final authState = context.read<AuthBloc>().state;
//     if (authState is AuthAuthenticated) {
//       user = authState.user;
//     }
//   }

//   void _loadJobs() {
//     context.read<JobBloc>().add(GetAllJobsEvent());
//   }

//   void _refreshJobs() {
//     context.read<JobBloc>().add(GetAllJobsEvent());
//   }

//   void _showLogoutDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               context.read<AuthBloc>().add(LogoutEvent());
//             },
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Logout'),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatCurrency(int amount) {
//     final formatter = NumberFormat.currency(
//       locale: 'id_ID',
//       symbol: 'Rp ',
//       decimalDigits: 0,
//     );
//     return formatter.format(amount);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Job Seeker'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: _showLogoutDialog,
//             tooltip: 'Logout',
//           ),
//         ],
//       ),
//       body: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthUnauthenticated) {
//             // Clear navigation stack and go to login
//             Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(builder: (_) => const AuthSelectionPage()),
//               (route) => false,
//             );
//           } else if (state is AuthError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         child: RefreshIndicator(
//           onRefresh: () async {
//             _refreshJobs();
//           },
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 _buildUserInfo(),
//                 const SizedBox(height: 24),
//                 _buildJobsList(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildUserInfo() {
//     if (user == null) return const SizedBox.shrink();

//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Colors.blue.shade100,
//                   child: Text(
//                     user!.name[0].toUpperCase(),
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         user!.name,
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         user!.email,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             if (user!.skills.isNotEmpty) ...[
//               const SizedBox(height: 16),
//               const Divider(),
//               const SizedBox(height: 8),
//               const Text(
//                 'Skills',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: user!.skills.map((skill) {
//                   return Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade100,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       skill,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.blue.shade800,
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildJobsList() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Available Jobs',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 16),
//         BlocBuilder<JobBloc, JobState>(
//           builder: (context, state) {
//             if (state is JobLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (state is JobError) {
//               return Center(
//                 child: Column(
//                   children: [
//                     Text(
//                       state.message,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(color: Colors.red),
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: _refreshJobs,
//                       child: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               );
//             }

//             if (state is JobsLoaded) {
//               if (state.jobs.isEmpty) {
//                 return const Center(
//                   child: Padding(
//                     padding: EdgeInsets.all(32),
//                     child: Text(
//                       'No jobs available at the moment.',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey,
//                       ),
//                     ),
//                   ),
//                 );
//               }

//               return ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: state.jobs.length,
//                 itemBuilder: (context, index) {
//                   final job = state.jobs[index];
//                   return _buildJobCard(job);
//                 },
//               );
//             }

//             return const SizedBox.shrink();
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildJobCard(job) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => JobDetailPage(jobId: job.id, isCompany: false),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 job.position,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               if (job.companyName.isNotEmpty) ...[
//                 Text(
//                   job.companyName,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey.shade700,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//               ],
//               Row(
//                 children: [
//                   Icon(Icons.location_on_outlined,
//                       size: 16, color: Colors.grey.shade600),
//                   const SizedBox(width: 4),
//                   Text(
//                     job.location,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Icon(Icons.work_outline,
//                       size: 16, color: Colors.grey.shade600),
//                   const SizedBox(width: 4),
//                   Text(
//                     job.workType.toUpperCase(),
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 '${_formatCurrency(job.minSalary)} - ${_formatCurrency(job.maxSalary)}',
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.deepPurple,
//                 ),
//               ),
//               if (job.requiredSkill.isNotEmpty) ...[
//                 const SizedBox(height: 12),
//                 Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: job.requiredSkill.map<Widget>((skill) {
//                     return Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 6,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.green.shade100,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         skill,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.green.shade800,
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobseeker/data/model/user_model.dart';
import 'package:jobseeker/presentation/auth/auth_bloc.dart';
import 'package:jobseeker/presentation/auth/auth_event.dart';
import 'package:jobseeker/presentation/auth/auth_state.dart';
import 'package:jobseeker/presentation/job/job_bloc.dart';
import 'package:jobseeker/presentation/job/job_event.dart';
import 'package:jobseeker/presentation/job/job_state.dart';
import 'package:jobseeker/presentation/pages/job_detail_page.dart';
import 'package:intl/intl.dart';
import 'package:jobseeker/presentation/pages/auth_selection_page.dart';
import 'package:jobseeker/presentation/pages/user_chat_list_page.dart';
import 'package:jobseeker/presentation/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const AuthSelectionPage()),
              (route) => false,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _HomeContent(),
            UserChatListPage(), // TODO: Ganti dengan UserChatListPage()
            ProfilePage(), // TODO: Ganti dengan ProfilePage()
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE49BA6), width: 2),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Beranda'),
              _buildNavItem(1, Icons.chat_bubble_outline_rounded, 'Chat'),
              _buildNavItem(2, Icons.person_outline_rounded, 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? const Color(0xFF540863) : const Color(0xFF92487A),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? const Color(0xFF540863) : const Color(0xFF92487A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Extract existing home content ke widget terpisah
class _HomeContent extends StatefulWidget {
  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadJobs();
  }

  void _loadUserData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      user = authState.user;
    }
  }

  void _loadJobs() {
    context.read<JobBloc>().add(GetAllJobsEvent());
  }

  void _refreshJobs() {
    context.read<JobBloc>().add(GetAllJobsEvent());
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Keluar',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF43334C),
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar?',
          style: GoogleFonts.poppins(
            color: const Color(0xFF43334C),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF92487A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF540863),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Keluar',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFFCF5EE),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
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
          'Cari Pekerjaan',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _showLogoutDialog,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xFF540863),
        onRefresh: () async {
          _refreshJobs();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildUserInfo(),
              const SizedBox(height: 24),
              _buildJobsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    if (user == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE49BA6),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFE49BA6),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF540863),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    user!.name[0].toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF540863),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user!.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF43334C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user!.email,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF92487A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (user!.skills.isNotEmpty) ...[
            const SizedBox(height: 16),
            Divider(color: const Color(0xFFE49BA6)),
            const SizedBox(height: 12),
            Text(
              'Keahlian',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF92487A),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: user!.skills.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF540863),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    skill,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFFCF5EE),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildJobsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lowongan Tersedia',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF43334C),
          ),
        ),
        const SizedBox(height: 16),
        BlocBuilder<JobBloc, JobState>(
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
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshJobs,
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
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      'Belum ada lowongan tersedia.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF92487A),
                      ),
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.jobs.length,
                itemBuilder: (context, index) {
                  final job = state.jobs[index];
                  return _buildJobCard(job);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildJobCard(job) {
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
              builder: (_) => JobDetailPage(jobId: job.id, isCompany: false),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                job.position,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF43334C),
                ),
              ),
              const SizedBox(height: 4),
              if (job.companyName.isNotEmpty) ...[
                Text(
                  job.companyName,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF540863),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: const Color(0xFF92487A),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    job.location,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF92487A),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.work_outline,
                    size: 16,
                    color: const Color(0xFF92487A),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    job.workType.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: const Color(0xFF92487A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${_formatCurrency(job.minSalary)} - ${_formatCurrency(job.maxSalary)}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF540863),
                ),
              ),
              if (job.requiredSkill.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: job.requiredSkill.map<Widget>((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD3D5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        skill,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF540863),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder untuk Chat Page
class _ChatPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF540863),
        foregroundColor: const Color(0xFFFCF5EE),
        elevation: 0,
        title: Text(
          'Chat',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Halaman Chat\n(Coming Soon)',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color(0xFF92487A),
          ),
        ),
      ),
    );
  }
}

// Placeholder untuk Profile Page
class _ProfilePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF540863),
        foregroundColor: const Color(0xFFFCF5EE),
        elevation: 0,
        title: Text(
          'Profil',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Halaman Profil\n(Coming Soon)',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: const Color(0xFF92487A),
          ),
        ),
      ),
    );
  }
}