// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jobseeker/data/model/job_model.dart';
// import 'package:jobseeker/presentation/job/job_bloc.dart';
// import 'package:jobseeker/presentation/job/job_event.dart';
// import 'package:jobseeker/presentation/job/job_state.dart';

// class UpdateJobPage extends StatefulWidget {
//   final JobModel job;

//   const UpdateJobPage({super.key, required this.job});

//   @override
//   State<UpdateJobPage> createState() => _UpdateJobPageState();
// }

// class _UpdateJobPageState extends State<UpdateJobPage> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _positionController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _locationController;
//   late TextEditingController _minSalaryController;
//   late TextEditingController _maxSalaryController;

//   late String _selectedWorkType;
//   final List<int> _selectedSkills = [];

//   final Map<int, String> _availableSkills = {
//     1: 'Go',
//     2: 'Java',
//     3: 'Python',
//     4: 'JavaScript',
//     5: 'Flutter',
//   };

//   @override
//   void initState() {
//     super.initState();
//     _positionController = TextEditingController(text: widget.job.position);
//     _descriptionController = TextEditingController(text: widget.job.description);
//     _locationController = TextEditingController(text: widget.job.location);
//     _minSalaryController = TextEditingController(text: widget.job.minSalary.toString());
//     _maxSalaryController = TextEditingController(text: widget.job.maxSalary.toString());
//     _selectedWorkType = widget.job.workType;
//     for (var entry in _availableSkills.entries) {
//       if (widget.job.requiredSkill.contains(entry.value)) {
//         _selectedSkills.add(entry.key);
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _positionController.dispose();
//     _descriptionController.dispose();
//     _locationController.dispose();
//     _minSalaryController.dispose();
//     _maxSalaryController.dispose();
//     super.dispose();
//   }

//   void _updateJob() {
//     if (_formKey.currentState!.validate()) {
//       if (_selectedSkills.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Please select at least one skill'),
//             backgroundColor: Colors.orange,
//           ),
//         );
//         return;
//       }

//       final request = UpdateJobRequest(
//         position: _positionController.text.trim(),
//         description: _descriptionController.text.trim(),
//         location: _locationController.text.trim(),
//         workType: _selectedWorkType,
//         minSalary: int.parse(_minSalaryController.text),
//         maxSalary: int.parse(_maxSalaryController.text),
//         requiredSkills: _selectedSkills,
//       );

//       context.read<JobBloc>().add(UpdateJobEvent(widget.job.id, request));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Update Job Vacancy'),
//         centerTitle: true,
//       ),
//       body: BlocConsumer<JobBloc, JobState>(
//         listener: (context, state) {
//           if (state is JobUpdated) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Job updated successfully!'),
//                 backgroundColor: Colors.green,
//               ),
//             );
//             Navigator.pop(context, true);
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
//           final isLoading = state is JobLoading;

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   TextFormField(
//                     controller: _positionController,
//                     decoration: const InputDecoration(
//                       labelText: 'Position',
//                       hintText: 'e.g. Senior Flutter Developer',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.work_outline),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter position';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _descriptionController,
//                     maxLines: 5,
//                     decoration: const InputDecoration(
//                       labelText: 'Description',
//                       hintText: 'Job description and requirements',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.description_outlined),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter description';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _locationController,
//                     decoration: const InputDecoration(
//                       labelText: 'Location',
//                       hintText: 'e.g. Jakarta (Remote)',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.location_on_outlined),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter location';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   DropdownButtonFormField<String>(
//                     value: _selectedWorkType,
//                     decoration: const InputDecoration(
//                       labelText: 'Work Type',
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.business_center_outlined),
//                     ),
//                     items: const [
//                       DropdownMenuItem(value: 'REMOTE', child: Text('Remote')),
//                       DropdownMenuItem(value: 'ONSITE', child: Text('Onsite')),
//                       DropdownMenuItem(value: 'HYBRID', child: Text('Hybrid')),
//                     ],
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedWorkType = value!;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextFormField(
//                           controller: _minSalaryController,
//                           keyboardType: TextInputType.number,
//                           inputFormatters: [
//                             FilteringTextInputFormatter.digitsOnly,
//                           ],
//                           decoration: const InputDecoration(
//                             labelText: 'Min Salary',
//                             hintText: '4000000',
//                             border: OutlineInputBorder(),
//                             prefixIcon: Icon(Icons.attach_money),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Required';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: TextFormField(
//                           controller: _maxSalaryController,
//                           keyboardType: TextInputType.number,
//                           inputFormatters: [
//                             FilteringTextInputFormatter.digitsOnly,
//                           ],
//                           decoration: const InputDecoration(
//                             labelText: 'Max Salary',
//                             hintText: '6000000',
//                             border: OutlineInputBorder(),
//                             prefixIcon: Icon(Icons.attach_money),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Required';
//                             }
//                             final maxSalary = int.tryParse(value);
//                             final minSalary =
//                                 int.tryParse(_minSalaryController.text);
//                             if (maxSalary != null &&
//                                 minSalary != null &&
//                                 maxSalary < minSalary) {
//                               return 'Must be > min';
//                             }
//                             return null;
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Required Skills',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 8,
//                     children: _availableSkills.entries.map((entry) {
//                       final isSelected = _selectedSkills.contains(entry.key);
//                       return FilterChip(
//                         label: Text(entry.value),
//                         selected: isSelected,
//                         onSelected: (selected) {
//                           setState(() {
//                             if (selected) {
//                               _selectedSkills.add(entry.key);
//                             } else {
//                               _selectedSkills.remove(entry.key);
//                             }
//                           });
//                         },
//                         selectedColor: Colors.deepPurple.shade200,
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: isLoading ? null : _updateJob,
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.all(16),
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                     ),
//                     child: isLoading
//                         ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                         : const Text(
//                             'Update Job',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobseeker/data/model/job_model.dart';
import 'package:jobseeker/presentation/job/job_bloc.dart';
import 'package:jobseeker/presentation/job/job_event.dart';
import 'package:jobseeker/presentation/job/job_state.dart';

class UpdateJobPage extends StatefulWidget {
  final JobModel job;

  const UpdateJobPage({super.key, required this.job});

  @override
  State<UpdateJobPage> createState() => _UpdateJobPageState();
}

class _UpdateJobPageState extends State<UpdateJobPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _positionController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _minSalaryController;
  late TextEditingController _maxSalaryController;

  late String _selectedWorkType;
  late List<int> _selectedSkills;

  final Map<int, String> _availableSkills = {
    1: 'Memasak',
    2: 'Housekeeping',
    3: 'Menjual Produk',
    4: 'Menjahit',
    5: 'Menjaga Toko'
  };

  @override
  void initState() {
    super.initState();
    _positionController = TextEditingController(text: widget.job.position);
    _descriptionController = TextEditingController(text: widget.job.description);
    _locationController = TextEditingController(text: widget.job.location);
    _minSalaryController = TextEditingController(text: widget.job.minSalary.toString());
    _maxSalaryController = TextEditingController(text: widget.job.maxSalary.toString());
    _selectedWorkType = widget.job.workType;
    
    // Convert requiredSkill (List<String>) to skill IDs
    _selectedSkills = [];
    for (var skillName in widget.job.requiredSkill) {
      // Find the ID for this skill name
      _availableSkills.forEach((id, name) {
        if (name == skillName) {
          _selectedSkills.add(id);
        }
      });
    }
  }

  @override
  void dispose() {
    _positionController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _minSalaryController.dispose();
    _maxSalaryController.dispose();
    super.dispose();
  }

  void _updateJob() {
    if (_formKey.currentState!.validate()) {
      if (_selectedSkills.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pilih minimal satu keahlian',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final request = UpdateJobRequest(
        position: _positionController.text.trim(),
        description: _descriptionController.text.trim(),
        location: _locationController.text.trim(),
        workType: _selectedWorkType,
        minSalary: int.parse(_minSalaryController.text),
        maxSalary: int.parse(_maxSalaryController.text),
        requiredSkills: _selectedSkills,
      );

      context.read<JobBloc>().add(UpdateJobEvent(widget.job.id, request));
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
          'Update Lowongan',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<JobBloc, JobState>(
        listener: (context, state) {
          if (state is JobUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Lowongan berhasil diupdate',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is JobError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Position Field
                  Text(
                    'Posisi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF43334C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _positionController,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Flutter Developer',
                      hintStyle: GoogleFonts.poppins(
                        color: const Color(0xFF92487A),
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE49BA6),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE49BA6),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF540863),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF43334C),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Posisi harus diisi';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Description Field
                  Text(
                    'Deskripsi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF43334C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Jelaskan detail pekerjaan...',
                      hintStyle: GoogleFonts.poppins(
                        color: const Color(0xFF92487A),
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE49BA6),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE49BA6),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF540863),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF43334C),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Deskripsi harus diisi';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Location Field
                  Text(
                    'Lokasi',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF43334C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Jakarta Selatan',
                      hintStyle: GoogleFonts.poppins(
                        color: const Color(0xFF92487A),
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE49BA6),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFE49BA6),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF540863),
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF43334C),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Lokasi harus diisi';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Work Type Field
                  Text(
                    'Tipe Pekerjaan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF43334C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE49BA6),
                        width: 2,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedWorkType,
                        isExpanded: true,
                        items: ['REMOTE', 'ONSITE', 'HYBRID'].map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(
                              type,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF43334C),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedWorkType = value!;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Salary Range
                  Text(
                    'Gaji',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF43334C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _minSalaryController,
                          decoration: InputDecoration(
                            hintText: 'Min',
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF92487A),
                              fontSize: 14,
                            ),
                            prefixText: 'Rp ',
                            prefixStyle: GoogleFonts.poppins(
                              color: const Color(0xFF540863),
                              fontWeight: FontWeight.w600,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE49BA6),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE49BA6),
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF540863),
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF43334C),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Wajib';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '-',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF540863),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _maxSalaryController,
                          decoration: InputDecoration(
                            hintText: 'Max',
                            hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF92487A),
                              fontSize: 14,
                            ),
                            prefixText: 'Rp ',
                            prefixStyle: GoogleFonts.poppins(
                              color: const Color(0xFF540863),
                              fontWeight: FontWeight.w600,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE49BA6),
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFFE49BA6),
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF540863),
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF43334C),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Wajib';
                            }
                            final min = int.tryParse(_minSalaryController.text);
                            final max = int.tryParse(value);
                            if (min != null && max != null && max < min) {
                              return 'Harus > min';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Skills Section
                  Text(
                    'Keahlian yang Dibutuhkan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF43334C),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableSkills.entries.map((entry) {
                      final isSelected = _selectedSkills.contains(entry.key);
                      return FilterChip(
                        label: Text(
                          entry.value,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFFFCF5EE)
                                : const Color(0xFF540863),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFF540863),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: const Color(0xFFE49BA6),
                          width: 2,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedSkills.add(entry.key);
                            } else {
                              _selectedSkills.remove(entry.key);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Submit Button
                  ElevatedButton(
                    onPressed: state is JobLoading ? null : _updateJob,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF540863),
                      foregroundColor: const Color(0xFFFCF5EE),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: state is JobLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFFCF5EE),
                            ),
                          )
                        : Text(
                            'Simpan Perubahan',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}