import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobseeker/data/model/user_model.dart';
import 'package:jobseeker/presentation/auth/auth_bloc.dart';
import 'package:jobseeker/presentation/auth/auth_event.dart';
import 'package:jobseeker/presentation/auth/auth_state.dart';
import 'package:jobseeker/presentation/pages/auth_selection_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      setState(() {
        user = authState.user;
      });
    }
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
        child: SafeArea(
          child: user == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Header with gradient
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF540863),
                              Color(0xFF92487A),
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                        child: Column(
                          children: [
                            // Avatar
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE49BA6),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFFCF5EE),
                                  width: 4,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  user!.name[0].toUpperCase(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF540863),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Name
                            Text(
                              user!.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFCF5EE),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Email
                            Text(
                              user!.email,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFFFFD3D5),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Contact Info Section
                            Text(
                              'Informasi Kontak',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF43334C),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Phone Number
                            _buildInfoCard(
                              icon: Icons.phone_outlined,
                              label: 'Nomor HP',
                              value: user!.phoneNumber,
                            ),
                            const SizedBox(height: 12),

                            // Skills Section
                            if (user!.skills.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              Text(
                                'Keahlian',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF43334C),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: user!.skills.map((skill) {
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
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFFFCF5EE),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],

                            const SizedBox(height: 32),

                            // Logout Button
                            ElevatedButton(
                              onPressed: _showLogoutDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF540863),
                                foregroundColor: const Color(0xFFFCF5EE),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.logout, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Keluar',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE49BA6),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD3D5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF540863),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF92487A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xFF43334C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}