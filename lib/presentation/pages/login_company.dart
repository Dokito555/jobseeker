// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:jobseeker/data/model/company_model.dart';
// import 'package:jobseeker/presentation/company_auth/company_auth_bloc.dart';
// import 'package:jobseeker/presentation/company_auth/company_auth_event.dart';
// import 'package:jobseeker/presentation/company_auth/company_auth_state.dart';
// import 'package:jobseeker/presentation/pages/company_home_page.dart';
// import 'package:jobseeker/presentation/pages/register_company.dart';

// class LoginCompany extends StatefulWidget {
//   const LoginCompany({super.key});

//   @override
//   State<LoginCompany> createState() => _LoginCompanyState();
// }

// class _LoginCompanyState extends State<LoginCompany> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _login() {
//     if (_formKey.currentState!.validate()) {
//       final request = CompanyLoginRequest(
//         email: _emailController.text.trim(),
//         password: _passwordController.text,
//       );
      
//       context.read<CompanyAuthBloc>().add(CompanyLoginEvent(request));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Company Login'),
//         centerTitle: true,
//       ),
//       body: BlocConsumer<CompanyAuthBloc, CompanyAuthState>(
//         listener: (context, state) {
//           print('company Login State Changed: ${state.runtimeType}');
          
//           if (state is CompanyAuthAuthenticated) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Login successful!'),
//                 backgroundColor: Colors.green,
//                 duration: Duration(seconds: 1),
//               ),
//             );
            
//             Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(builder: (_) => const CompanyHomePage()),
//               (route) => false,
//             );
//           } else if (state is CompanyAuthError) {
//             print('showing error snackbar: ${state.message}');
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Colors.red,
//                 duration: const Duration(seconds: 4),
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           final isLoading = state is CompanyAuthLoading;

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(24),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const SizedBox(height: 40),
//                   const Icon(
//                     Icons.business,
//                     size: 80,
//                     color: Colors.deepPurple,
//                   ),
//                   const SizedBox(height: 24),
//                   const Text(
//                     'Welcome Back!',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Login to manage your job postings',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey,
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   TextFormField(
//                     controller: _emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: const InputDecoration(
//                       labelText: 'Company Email',
//                       prefixIcon: Icon(Icons.email_outlined),
//                       border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!value.contains('@')) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: _obscurePassword,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       prefixIcon: const Icon(Icons.lock_outlined),
//                       suffixIcon: IconButton(
//                         icon: Icon(_obscurePassword
//                             ? Icons.visibility_outlined
//                             : Icons.visibility_off_outlined),
//                         onPressed: () {
//                           setState(() {
//                             _obscurePassword = !_obscurePassword;
//                           });
//                         },
//                       ),
//                       border: const OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton(
//                     onPressed: isLoading ? null : _login,
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.all(16),
//                       backgroundColor: Colors.deepPurple,
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
//                             'Login as Company',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextButton(
//                     onPressed: isLoading ? null : () => Navigator.pop(context),
//                     child: const Text('Back to User Login'),
//                   ),
//                   const SizedBox(height: 8),
//                   TextButton(
//                     onPressed: isLoading
//                         ? null
//                         : () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                   builder: (_) => const RegisterCompany()),
//                             );
//                           },
//                     child: const Text("Don't have an account? Register"),
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// Import models & BLoC
import 'package:jobseeker/data/model/company_model.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_bloc.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_event.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_state.dart';

// Import pages
import 'package:jobseeker/presentation/pages/company_home_page.dart';
import 'package:jobseeker/presentation/pages/register_company.dart';

class LoginCompany extends StatefulWidget {
  const LoginCompany({super.key});

  @override
  State<LoginCompany> createState() => _LoginCompanyState();
}

class _LoginCompanyState extends State<LoginCompany> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final request = CompanyLoginRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      context.read<CompanyAuthBloc>().add(CompanyLoginEvent(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),
      body: BlocConsumer<CompanyAuthBloc, CompanyAuthState>(
        listener: (context, state) {
          if (state is CompanyAuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Selamat datang, ${state.company.name}!',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            
            // Navigate and remove all previous routes
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const CompanyHomePage()),
              (route) => false,
            );
          } else if (state is CompanyAuthError) {
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
          final isLoading = state is CompanyAuthLoading;

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
                    
                    // Perusahaan Badge Icon
                    Text(
                      'Masuk Sebagai Perusahaan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF43334C),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    Text(
                      'Kelola lowongan dan temukan talenta terbaik',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF92487A),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Email Field
                    Text(
                      'Email Perusahaan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF43334C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintText: 'perusahaan@email.com',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF92487A),
                        ),
                        filled: true,
                        fillColor: Colors.white,
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
                    
                    const SizedBox(height: 20),
                    
                    // Password Field
                    Text(
                      'Password',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF43334C),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintText: 'Masukkan password',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF92487A),
                        ),
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
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: 12),
                    
                    const SizedBox(height: 24),
                    
                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD3D5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Color(0xFF540863),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Akun Perusahaan digunakan untuk mengelola lowongan kerja dan berkomunikasi dengan pelamar',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: const Color(0xFF43334C),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Login Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _login,
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
                                'Masuk sebagai Perusahaan',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum terdaftar? ',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFF92487A),
                          ),
                        ),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterCompany(),
                                    ),
                                  );
                                },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Daftar Perusahaan',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF540863),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}