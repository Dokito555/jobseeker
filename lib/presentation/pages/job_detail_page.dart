// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jobseeker/data/model/job_model.dart';
// import 'package:jobseeker/presentation/job/job_bloc.dart';
// import 'package:jobseeker/presentation/job/job_event.dart';
// import 'package:jobseeker/presentation/job/job_state.dart';
// import 'package:jobseeker/presentation/pages/update_job_page.dart';
// import 'package:jobseeker/presentation/pages/chat_page.dart';
// import 'package:intl/intl.dart';

// class JobDetailPage extends StatefulWidget {
//   final int jobId;
//   final bool isCompany;

//   const JobDetailPage({
//     super.key,
//     required this.jobId,
//     this.isCompany = false,
//   });

//   @override
//   State<JobDetailPage> createState() => _JobDetailPageState();
// }

// class _JobDetailPageState extends State<JobDetailPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<JobBloc>().add(GetJobByIdEvent(widget.jobId));
//   }

//   String _formatCurrency(int amount) {
//     final formatter = NumberFormat.currency(
//       locale: 'id_ID',
//       symbol: 'Rp ',
//       decimalDigits: 0,
//     );
//     return formatter.format(amount);
//   }

//   String _formatDate(String dateStr) {
//     try {
//       final date = DateTime.parse(dateStr);
//       return DateFormat('dd MMM yyyy, HH:mm').format(date);
//     } catch (e) {
//       return dateStr;
//     }
//   }

//   void _showDeleteConfirmation(JobModel job) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Job'),
//         content: Text('Are you sure you want to delete "${job.position}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               context.read<JobBloc>().add(DeleteJobEvent(job.id));
//             },
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showCloseConfirmation(JobModel job) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Close Job'),
//         content: Text('Are you sure you want to close "${job.position}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               context.read<JobBloc>().add(CloseJobEvent(job.id));
//             },
//             style: TextButton.styleFrom(foregroundColor: Colors.orange),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _openChat(JobModel job) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ChatPage(
//           jobVacancyId: job.id,
//           jobTitle: job.position,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Job Details'),
//         centerTitle: true,
//       ),
//       body: BlocConsumer<JobBloc, JobState>(
//         listener: (context, state) {
//           if (state is JobDeleted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.green,
//               ),
//             );
//             Navigator.pop(context, true);
//           } else if (state is JobClosed) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.orange,
//               ),
//             );
//             context.read<JobBloc>().add(GetJobByIdEvent(widget.jobId));
//           } else if (state is JobError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           if (state is JobLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (state is JobError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     state.message,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       context.read<JobBloc>().add(GetJobByIdEvent(widget.jobId));
//                     },
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (state is JobLoaded) {
//             return _buildJobDetail(state.job);
//           }

//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }

//   Widget _buildJobDetail(JobModel job) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           job.position,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: job.status == 'ACTIVE'
//                               ? Colors.green.shade100
//                               : Colors.grey.shade300,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Text(
//                           job.status,
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: job.status == 'ACTIVE'
//                                 ? Colors.green.shade800
//                                 : Colors.grey.shade800,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   if (job.companyName.isNotEmpty) ...[
//                     Row(
//                       children: [
//                         Icon(Icons.business, size: 20, color: Colors.grey.shade600),
//                         const SizedBox(width: 8),
//                         Text(
//                           job.companyName,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                   ],
//                   Row(
//                     children: [
//                       Icon(Icons.location_on_outlined,
//                           size: 20, color: Colors.grey.shade600),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           job.location,
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey.shade800,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Icon(Icons.work_outline,
//                           size: 20, color: Colors.grey.shade600),
//                       const SizedBox(width: 8),
//                       Text(
//                         job.workType.toUpperCase(),
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey.shade800,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   const Divider(),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Salary Range',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     '${_formatCurrency(job.minSalary)} - ${_formatCurrency(job.maxSalary)}',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Description',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   Text(
//                     job.description,
//                     style: const TextStyle(fontSize: 16, height: 1.5),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (job.requiredSkill.isNotEmpty) ...[
//             const SizedBox(height: 16),
//             Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Required Skills',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: job.requiredSkill.map((skill) {
//                         return Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 8,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.blue.shade100,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             skill,
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.blue.shade800,
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//           const SizedBox(height: 16),
//           Card(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'Job Information',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   _buildInfoRow('Posted', _formatDate(job.createdAt)),
//                   const SizedBox(height: 8),
//                   _buildInfoRow('Last Updated', _formatDate(job.updatedAt)),
//                 ],
//               ),
//             ),
//           ),
          
//           // TOMBOL CHAT - Untuk User (bukan company)
//           if (!widget.isCompany) ...[
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: () => _openChat(job),
//               icon: const Icon(Icons.chat_bubble_outline),
//               label: const Text('Chat with Company'),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.all(16),
//                 backgroundColor: Colors.deepPurple,
//                 foregroundColor: Colors.white,
//               ),
//             ),
//           ],
          
//           // TOMBOL-TOMBOL UNTUK COMPANY
//           if (widget.isCompany) ...[
//             const SizedBox(height: 24),
//             // Tombol Chat untuk Company
//             ElevatedButton.icon(
//               onPressed: () => _openChat(job),
//               icon: const Icon(Icons.chat_bubble_outline),
//               label: const Text('View Messages'),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.all(16),
//                 backgroundColor: Colors.deepPurple,
//                 foregroundColor: Colors.white,
//               ),
//             ),
            
//             // Tombol Update, Close, Delete hanya untuk job ACTIVE
//             if (job.status == 'ACTIVE') ...[
//               const SizedBox(height: 12),
//               OutlinedButton.icon(
//                 onPressed: () async {
//                   final result = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => UpdateJobPage(job: job),
//                     ),
//                   );
//                   if (result == true) {
//                     context.read<JobBloc>().add(GetJobByIdEvent(widget.jobId));
//                   }
//                 },
//                 icon: const Icon(Icons.edit),
//                 label: const Text('Update Job'),
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.all(16),
//                   foregroundColor: Colors.blue,
//                   side: const BorderSide(color: Colors.blue),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               OutlinedButton.icon(
//                 onPressed: () => _showCloseConfirmation(job),
//                 icon: const Icon(Icons.close),
//                 label: const Text('Close Job'),
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.all(16),
//                   foregroundColor: Colors.orange,
//                   side: const BorderSide(color: Colors.orange),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               OutlinedButton.icon(
//                 onPressed: () => _showDeleteConfirmation(job),
//                 icon: const Icon(Icons.delete),
//                 label: const Text('Delete Job'),
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.all(16),
//                   foregroundColor: Colors.red,
//                   side: const BorderSide(color: Colors.red),
//                 ),
//               ),
//             ],
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 120,
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobseeker/data/model/job_model.dart';
import 'package:jobseeker/presentation/job/job_bloc.dart';
import 'package:jobseeker/presentation/job/job_event.dart';
import 'package:jobseeker/presentation/job/job_state.dart';
import 'package:jobseeker/presentation/pages/update_job_page.dart';
import 'package:jobseeker/presentation/pages/chat_page.dart';
import 'package:intl/intl.dart';

class JobDetailPage extends StatefulWidget {
  final int jobId;
  final bool isCompany;

  const JobDetailPage({
    super.key,
    required this.jobId,
    this.isCompany = false,
  });

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<JobBloc>().add(GetJobByIdEvent(widget.jobId));
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  void _showDeleteConfirmation(JobModel job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Hapus Lowongan',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF43334C),
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus "${job.position}"?',
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
              context.read<JobBloc>().add(DeleteJobEvent(job.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Hapus',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCloseConfirmation(JobModel job) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Tutup Lowongan',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF43334C),
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menutup "${job.position}"?',
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
              context.read<JobBloc>().add(CloseJobEvent(job.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Tutup',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openChat(JobModel job) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatPage(
          jobVacancyId: job.id,
          jobTitle: job.position,
        ),
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
          'Detail Lowongan',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<JobBloc, JobState>(
        listener: (context, state) {
          if (state is JobDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is JobClosed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.orange,
              ),
            );
            context.read<JobBloc>().add(GetJobByIdEvent(widget.jobId));
          } else if (state is JobError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
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
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<JobBloc>().add(GetJobByIdEvent(widget.jobId));
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

          if (state is JobLoaded) {
            return _buildJobDetail(state.job);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildJobDetail(JobModel job) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with gradient
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF540863),
                  Color(0xFF92487A),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
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
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFCF5EE),
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
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (job.companyName.isNotEmpty) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.business,
                        size: 18,
                        color: Color(0xFFFFD3D5),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        job.companyName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color(0xFFFFD3D5),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: Color(0xFFFFD3D5),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      job.location,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFFFCF5EE),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.work_outline,
                      size: 18,
                      color: Color(0xFFFFD3D5),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      job.workType.toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFFFCF5EE),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Salary Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE49BA6),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gaji',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF92487A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_formatCurrency(job.minSalary)} - ${_formatCurrency(job.maxSalary)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF540863),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Description Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE49BA6),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deskripsi Pekerjaan',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF43334C),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  job.description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    height: 1.6,
                    color: const Color(0xFF43334C),
                  ),
                ),
              ],
            ),
          ),
          
          if (job.requiredSkill.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE49BA6),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keahlian yang Dibutuhkan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF43334C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: job.requiredSkill.map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF540863),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          skill,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFFCF5EE),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 16),
          
          // Info Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFE49BA6),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Lowongan',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF43334C),
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Diposting', _formatDate(job.createdAt)),
                const SizedBox(height: 8),
                _buildInfoRow('Terakhir Diupdate', _formatDate(job.updatedAt)),
              ],
            ),
          ),
          
          // TOMBOL CHAT - Untuk User (bukan company)
          if (!widget.isCompany) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _openChat(job),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF540863),
                foregroundColor: const Color(0xFFFCF5EE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Chat dengan UMKM',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // TOMBOL-TOMBOL UNTUK COMPANY
          if (widget.isCompany) ...[
            const SizedBox(height: 24),
            // Tombol Chat untuk Company
            ElevatedButton(
              onPressed: () => _openChat(job),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: const Color(0xFF540863),
                foregroundColor: const Color(0xFFFCF5EE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Lihat Pesan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Tombol Update, Close, Delete hanya untuk job ACTIVE
            if (job.status == 'ACTIVE') ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateJobPage(job: job),
                    ),
                  );
                  if (result == true) {
                    context.read<JobBloc>().add(GetJobByIdEvent(widget.jobId));
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: const Color(0xFF540863),
                  side: const BorderSide(
                    color: Color(0xFF540863),
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.edit, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Update Lowongan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => _showCloseConfirmation(job),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Colors.orange,
                  side: const BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.close, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Tutup Lowongan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => _showDeleteConfirmation(job),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Colors.red,
                  side: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.delete, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Hapus Lowongan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF92487A),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF43334C),
            ),
          ),
        ),
      ],
    );
  }
}