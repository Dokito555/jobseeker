import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jobseeker/data/model/company_model.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_bloc.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_event.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_state.dart';
import 'package:jobseeker/presentation/pages/auth_selection_page.dart';

class CompanyProfilePage extends StatefulWidget {
  const CompanyProfilePage({super.key});

  @override
  State<CompanyProfilePage> createState() => _CompanyProfilePageState();
}

class _CompanyProfilePageState extends State<CompanyProfilePage> {
  CompanyModel? company;

  @override
  void initState() {
    super.initState();
    _loadCompanyData();
  }

  void _loadCompanyData() {
    final authState = context.read<CompanyAuthBloc>().state;
    if (authState is CompanyAuthAuthenticated) {
      setState(() {
        company = authState.company;
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
        child: SafeArea(
          child: company == null
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
                            // Company Avatar
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
                              child: const Icon(
                                Icons.business_center,
                                size: 48,
                                color: Color(0xFF540863),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Company Name
                            Text(
                              company!.name,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFCF5EE),
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Email
                            Text(
                              company!.email,
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
                              label: 'Nomor Telepon',
                              value: company!.phoneNumber,
                            ),
                            const SizedBox(height: 12),

                            // Address
                            _buildInfoCard(
                              icon: Icons.location_on_outlined,
                              label: 'Alamat',
                              value: company!.address,
                            ),
                            
                            const SizedBox(height: 24),

                            // About Company Section
                            Text(
                              'Tentang Usaha',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF43334C),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFE49BA6),
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                company!.description,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: const Color(0xFF43334C),
                                  height: 1.5,
                                ),
                              ),
                            ),

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