// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jobseeker/data/model/company_model.dart';
// import 'package:jobseeker/presentation/company_auth/company_auth_bloc.dart';
// import 'package:jobseeker/presentation/company_auth/company_auth_event.dart';
// import 'package:jobseeker/presentation/company_auth/company_auth_state.dart';
// import 'package:jobseeker/presentation/job/job_bloc.dart';
// import 'package:jobseeker/presentation/job/job_event.dart';
// import 'package:jobseeker/presentation/job/job_state.dart';
// import 'package:jobseeker/presentation/pages/auth_selection_page.dart';
// import 'package:jobseeker/presentation/pages/create_job_page.dart';
// import 'package:jobseeker/presentation/pages/job_detail_page.dart';
// import 'package:intl/intl.dart';
// import 'package:jobseeker/presentation/pages/login_page.dart';

// class CompanyHomePage extends StatefulWidget {
//   const CompanyHomePage({super.key});

//   @override
//   State<CompanyHomePage> createState() => _CompanyHomePageState();
// }

// class _CompanyHomePageState extends State<CompanyHomePage> {
//   CompanyModel? company;

//   @override
//   void initState() {
//     super.initState();
//     _loadCompanyData();
//   }

//   void _loadCompanyData() {
//     final authState = context.read<CompanyAuthBloc>().state;
//     if (authState is CompanyAuthAuthenticated) {
//       company = authState.company;
//       context.read<JobBloc>().add(GetJobsByCompanyEvent(company!.id));
//     }
//   }

//   void _refreshJobs() {
//     if (company != null) {
//       context.read<JobBloc>().add(GetJobsByCompanyEvent(company!.id));
//     }
//   }

//   String _formatCurrency(int amount) {
//     final formatter = NumberFormat.currency(
//       locale: 'id_ID',
//       symbol: 'Rp ',
//       decimalDigits: 0,
//     );
//     return formatter.format(amount);
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
//               context.read<CompanyAuthBloc>().add(CompanyLogoutEvent());
//             },
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Logout'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Company Dashboard'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: _showLogoutDialog,
//             tooltip: 'Logout',
//           ),
//         ],
//       ),
//       body: BlocListener<CompanyAuthBloc, CompanyAuthState>(
//         listener: (context, state) {
//           if (state is CompanyAuthUnauthenticated) {
//             Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(builder: (_) => const AuthSelectionPage()),
//               (route) => false,
//             );
//           } else if (state is CompanyAuthError) {
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
//                 _buildCompanyInfo(),
//                 const SizedBox(height: 24),
//                 _buildCreateJobButton(),
//                 const SizedBox(height: 24),
//                 _buildJobsList(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCompanyInfo() {
//     if (company == null) return const SizedBox.shrink();

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
//                   backgroundColor: Colors.deepPurple.shade100,
//                   child: Text(
//                     company!.name[0].toUpperCase(),
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         company!.name,
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         company!.email,
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
//             const SizedBox(height: 16),
//             const Divider(),
//             const SizedBox(height: 8),
//             _buildInfoRow(Icons.location_on_outlined, company!.address),
//             const SizedBox(height: 8),
//             _buildInfoRow(Icons.phone_outlined, company!.phoneNumber),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, size: 20, color: Colors.grey.shade600),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             text,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade800,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCreateJobButton() {
//     return ElevatedButton.icon(
//       onPressed: () async {
//         final result = await Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const CreateJobPage()),
//         );
//         if (result == true) {
//           _refreshJobs();
//         }
//       },
//       icon: const Icon(Icons.add),
//       label: const Text('Create Job Vacancy'),
//       style: ElevatedButton.styleFrom(
//         padding: const EdgeInsets.all(16),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//       ),
//     );
//   }

//   Widget _buildJobsList() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Your Job Vacancies',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 16),
//         BlocConsumer<JobBloc, JobState>(
//           listener: (context, state) {
//             if (state is JobDeleted) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//               _refreshJobs();
//             } else if (state is JobClosed) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text(state.message),
//                   backgroundColor: Colors.orange,
//                 ),
//               );
//               _refreshJobs();
//             }
//           },
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
//                       'No job vacancies yet.\nCreate your first job!',
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
//         onTap: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => JobDetailPage(jobId: job.id, isCompany: true),
//             ),
//           );
//           if (result == true) {
//             _refreshJobs();
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       job.position,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: job.status == 'ACTIVE'
//                           ? Colors.green.shade100
//                           : Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       job.status,
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         color: job.status == 'ACTIVE'
//                             ? Colors.green.shade800
//                             : Colors.grey.shade800,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
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
//                         color: Colors.blue.shade100,
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Text(
//                         skill,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.blue.shade800,
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
import 'package:jobseeker/data/model/company_model.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_bloc.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_event.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_state.dart';
import 'package:jobseeker/presentation/job/job_bloc.dart';
import 'package:jobseeker/presentation/job/job_event.dart';
import 'package:jobseeker/presentation/job/job_state.dart';
import 'package:jobseeker/presentation/pages/auth_selection_page.dart';
import 'package:jobseeker/presentation/pages/create_job_page.dart';
import 'package:jobseeker/presentation/pages/job_detail_page.dart';
import 'package:intl/intl.dart';
import 'package:jobseeker/presentation/pages/company_chat_list_page.dart';
import 'package:jobseeker/presentation/pages/company_profile_page.dart';

class CompanyHomePage extends StatefulWidget {
  const CompanyHomePage({super.key});

  @override
  State<CompanyHomePage> createState() => _CompanyHomePageState();
}

class _CompanyHomePageState extends State<CompanyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),
      body: BlocListener<CompanyAuthBloc, CompanyAuthState>(
        listener: (context, state) {
          if (state is CompanyAuthUnauthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const AuthSelectionPage()),
              (route) => false,
            );
          } else if (state is CompanyAuthError) {
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
            _CompanyHomeContent(),
            CompanyChatListPage(), // TODO: Ganti dengan CompanyChatListPage()
            CompanyProfilePage(), // TODO: Ganti dengan CompanyProfilePage()
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

// Extract existing company home content ke widget terpisah
class _CompanyHomeContent extends StatefulWidget {
  @override
  State<_CompanyHomeContent> createState() => _CompanyHomeContentState();
}

class _CompanyHomeContentState extends State<_CompanyHomeContent> {
  CompanyModel? company;

  @override
  void initState() {
    super.initState();
    _loadCompanyData();
  }

  void _loadCompanyData() {
    final authState = context.read<CompanyAuthBloc>().state;
    if (authState is CompanyAuthAuthenticated) {
      company = authState.company;
      context.read<JobBloc>().add(GetJobsByCompanyEvent(company!.id));
    }
  }

  void _refreshJobs() {
    if (company != null) {
      context.read<JobBloc>().add(GetJobsByCompanyEvent(company!.id));
    }
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
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
              context.read<CompanyAuthBloc>().add(CompanyLogoutEvent());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF540863),
        foregroundColor: const Color(0xFFFCF5EE),
        elevation: 0,
        title: Text(
          'Dashboard UMKM',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateJobPage()),
          );
          if (result == true) {
            _refreshJobs();
          }
        },
        backgroundColor: const Color(0xFF540863),
        foregroundColor: const Color(0xFFFCF5EE),
        icon: const Icon(Icons.add),
        label: Text(
          'Buat Lowongan',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
          ),
        ),
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
              _buildCompanyInfo(),
              const SizedBox(height: 24),
              _buildJobsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyInfo() {
    if (company == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF540863),
            Color(0xFF92487A),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE49BA6),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFFCF5EE),
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.business_center,
              color: Color(0xFF540863),
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company!.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFCF5EE),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  company!.email,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: const Color(0xFFFFD3D5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lowongan Saya',
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
                      style: GoogleFonts.poppins(color: Colors.red),
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
                    child: Column(
                      children: [
                        Icon(
                          Icons.work_off_outlined,
                          size: 64,
                          color: const Color(0xFF92487A),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada lowongan',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF92487A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Buat lowongan pertama Anda!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF92487A),
                          ),
                        ),
                      ],
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
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => JobDetailPage(jobId: job.id, isCompany: true),
            ),
          );
          if (result == true) {
            _refreshJobs();
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      job.position,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF43334C),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: job.status == 'ACTIVE'
                          ? Colors.green
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      job.status,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
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
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder untuk Company Chat Page
class _CompanyChatPlaceholder extends StatelessWidget {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 80,
              color: const Color(0xFF92487A),
            ),
            const SizedBox(height: 16),
            Text(
              'Halaman Chat UMKM',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF43334C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF92487A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder untuk Company Profile Page
class _CompanyProfilePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF540863),
        foregroundColor: const Color(0xFFFCF5EE),
        elevation: 0,
        title: Text(
          'Profil UMKM',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_center,
              size: 80,
              color: const Color(0xFF92487A),
            ),
            const SizedBox(height: 16),
            Text(
              'Halaman Profil UMKM',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF43334C),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming Soon',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF92487A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}