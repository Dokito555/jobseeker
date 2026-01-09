// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jobseeker/data/model/user_model.dart';
// import 'package:jobseeker/presentation/auth/auth_bloc.dart';
// import 'package:jobseeker/presentation/auth/auth_event.dart';
// import 'package:jobseeker/presentation/auth/auth_state.dart';
// import 'package:jobseeker/presentation/pages/register_company.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _addressController = TextEditingController();
//   bool _obscurePassword = true;

//   final Map<int, String> _skills = {
//     1: 'Software Enginerring',
//     2: 'Web Development',
//     3: 'Mobile Development',
//   };

//   final Set<int> _selectedSkills = {};

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     super.dispose();
//   }

//   void _register() {
//     if (_formKey.currentState!.validate()) {
//       if (_selectedSkills.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("please select at least one skill"),
//             backgroundColor: Colors.orange,
//           )
//         );
//         return;
//       }

//       final phoneNumber = _phoneController.text.trim();
//       final skillsList = _selectedSkills.toList();

//       final request = UserRegisterRequest(
//         email: _emailController.text.trim(), 
//         password: _passwordController.text, 
//         name: _nameController.text.trim(), 
//         phoneNumber: phoneNumber, 
//         address: _addressController.text.trim(), 
//         skillIds: skillsList
//       );
//       context.read<AuthBloc>().add(RegisterEvent(request));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Register'),
//         centerTitle: true,
//       ),
//       body: BlocConsumer<AuthBloc, AuthState>( 
//         listener: (context, state) {
//           if (state is AuthRegisterSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.green,
//               )
//             );
//             Navigator.of(context).pop();
//           } else if (state is AuthError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//               )
//             );
//           }
//         },
//         builder: (context, state) {
//           final isLoading = state is AuthLoading;

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // const SizedBox(height: 20,),
//                   // Icon(
//                   //   Icons.person_add_outlined,
//                   //   size: 80,
//                   //   color: Theme.of(context).primaryColor,
//                   // ),
//                   const SizedBox(height: 30),
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: const InputDecoration(
//                       labelText: 'Name',
//                       prefixIcon: Icon(Icons.person_outline),
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter your name";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16,),
//                   TextFormField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: const InputDecoration(
//                       labelText: 'Email',
//                       prefixIcon: Icon(Icons.email_outlined),
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter your email";
//                       }
//                       if (!value.contains('@')) {
//                         return "Please enter a valid email";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16,),
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: _obscurePassword,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       prefixIcon: Icon(Icons.lock_outline),
//                       suffixIcon: IconButton(
//                         icon: Icon(_obscurePassword 
//                           ? Icons.visibility_outlined
//                           : Icons.visibility_off_outlined
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscurePassword = !_obscurePassword;
//                           });
//                         },
//                       ),
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter your password";
//                       }
//                       if (value.length < 6) {
//                         return "Password must be at least 6 characters";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16,),
//                   TextFormField(
//                     controller: _phoneController,
//                     keyboardType: TextInputType.phone,
//                     decoration: const InputDecoration(
//                       labelText: 'Phone Number',
//                       prefixIcon: Icon(Icons.phone_outlined),
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter your phone number";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16,),
//                   TextFormField(
//                     controller: _addressController,
//                     maxLines: 2,
//                     decoration: const InputDecoration(
//                       labelText: 'Address',
//                       prefixIcon: Icon(Icons.home_outlined),
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return "Please enter your address";
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16,),
//                   const Text(
//                     'Select Skills:',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   ..._skills.entries.map((entry) {
//                     return CheckboxListTile(
//                       title: Text(entry.value),
//                       value: _selectedSkills.contains(entry.key), 
//                       onChanged: (bool? value) {
//                         setState(() {
//                           if (value == true) {
//                             _selectedSkills.add(entry.key);
//                           } else {
//                             _selectedSkills.remove(entry.key);
//                           }
//                         });
//                       },
//                       contentPadding: EdgeInsets.zero,
//                     );
//                   }).toList(),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: isLoading ? null : _register, 
//                     child: isLoading
//                     ? const SizedBox(
//                       height: 20,
//                       width: 20,
//                       child: CircularProgressIndicator(strokeWidth: 2,),
//                     )
//                     : const Text("Register", style: TextStyle(fontSize: 16),)
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: isLoading ? null : () => Navigator.of(context).push(
//                       MaterialPageRoute(builder: (_) => const RegisterCompany())
//                     ),
//                     child: isLoading
//                     ? const SizedBox(
//                       height: 20,
//                       width: 20,
//                       child: CircularProgressIndicator(strokeWidth: 2,),
//                     )
//                     : const Text("Register as Company", style: TextStyle(fontSize: 16),)
//                   ),
//                   const SizedBox(height: 16),
//                   TextButton(
//                     onPressed: isLoading ? null : () => Navigator.of(context).pop(), 
//                     child: const Text("Already have an account? Login")
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       )
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// Import models & BLoC
import 'package:jobseeker/data/model/user_model.dart';
import 'package:jobseeker/presentation/auth/auth_bloc.dart';
import 'package:jobseeker/presentation/auth/auth_event.dart';
import 'package:jobseeker/presentation/auth/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Available skills (sesuai backend)
  final Map<int, String> _skills = {
    1: 'Memasak',
    2: 'Housekeeping',
    3: 'Menjual Produk',
    4: 'Menjahit',
    5: 'Menjaga Toko'
  };

  final Set<int> _selectedSkills = {};

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      if (_selectedSkills.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pilih minimal 1 keahlian',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }

      final request = UserRegisterRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        skillIds: _selectedSkills.toList(),
      );

      context.read<AuthBloc>().add(RegisterEvent(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            Navigator.of(context).pop();
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Back Button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF540863),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Header
                    Text(
                      'Daftar sebagai Pekerja',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF43334C),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Lengkapi data diri Anda untuk mulai mencari pekerjaan',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: const Color(0xFF92487A),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Name Field
                    _buildLabel('Nama Lengkap'),
                    TextFormField(
                      controller: _nameController,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan nama lengkap',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Email Field
                    _buildLabel('Email'),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        hintText: 'nama@email.com',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!value.contains('@')) {
                          return 'Masukkan email yang valid';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Phone Field
                    _buildLabel('Nomor HP'),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        hintText: '08xxxxxxxxxx',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor HP tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Address Field (IMPORTANT: ini yang hilang di versi lama!)
                    _buildLabel('Alamat'),
                    TextFormField(
                      controller: _addressController,
                      maxLines: 2,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        hintText: 'Alamat lengkap Anda',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Alamat tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Password Field
                    _buildLabel('Password'),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintText: 'Min. 8 karakter',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF92487A),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Confirm Password Field
                    _buildLabel('Konfirmasi Password'),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintText: 'Masukkan ulang password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: const Color(0xFF92487A),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi password tidak boleh kosong';
                        }
                        if (value != _passwordController.text) {
                          return 'Password tidak sama';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Skills Section
                    Text(
                      'Keahlian (Pilih minimal 1)',
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
                      children: _skills.entries.map((entry) {
                        final isSelected = _selectedSkills.contains(entry.key);
                        return FilterChip(
                          label: Text(entry.value),
                          selected: isSelected,
                          onSelected: isLoading
                              ? null
                              : (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedSkills.add(entry.key);
                                    } else {
                                      _selectedSkills.remove(entry.key);
                                    }
                                  });
                                },
                          backgroundColor: Colors.white,
                          selectedColor: const Color(0xFF540863),
                          checkmarkColor: const Color(0xFFFCF5EE),
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFFFCF5EE)
                                : const Color(0xFF92487A),
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF540863)
                                : const Color(0xFFE49BA6),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Register Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF540863),
                          foregroundColor: const Color(0xFFFCF5EE),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 2,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Color(0xFFFCF5EE),
                                ),
                              )
                            : Text(
                                'Daftar',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah punya akun? ',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF92487A),
                          ),
                        ),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Masuk',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF540863),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF43334C),
        ),
      ),
    );
  }
}