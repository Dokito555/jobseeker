import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import existing pages
import 'package:jobseeker/presentation/pages/login_page.dart';
import 'package:jobseeker/presentation/pages/login_company.dart';
import 'package:jobseeker/presentation/pages/register_page.dart';
import 'package:jobseeker/presentation/pages/register_company.dart';

class AuthSelectionPage extends StatelessWidget {
  const AuthSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF5EE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              
              // Header dengan Logo
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    child: Image.asset(
                      'assets/images/Logo.png', // Ganti dengan path gambar Anda
                      fit: BoxFit.contain, // Pastikan gambar sesuai dengan ukuran container
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'RoeWATI',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF43334C),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Text(
                'Pilih peran Anda untuk melanjutkan',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: const Color(0xFF92487A),
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Card Pekerja
              _buildRoleCard(
                context: context,
                title: 'Saya Pekerja',
                description: 'Cari lowongan kerja dan berkomunikasi dengan perusahaan',
                icon: Icons.person_outline_rounded,
                backgroundColor: const Color(0xFF540863),
                foregroundColor: const Color(0xFFFCF5EE),
                accentColor: const Color(0xFF92487A),
                onLoginPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                },
                onRegisterPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // Card UMKM
              _buildRoleCard(
                context: context,
                title: 'Saya Perusahaan',
                description: 'Post lowongan dan temukan talenta terbaik',
                icon: Icons.business_center_outlined,
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF43334C),
                accentColor: const Color(0xFFE49BA6),
                onLoginPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginCompany()),
                  );
                },
                onRegisterPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterCompany()),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              
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
                        'Pilih peran sesuai kebutuhan Anda. Pekerja untuk mencari kerja, perusahaan untuk merekrut.',
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color backgroundColor,
    required Color foregroundColor,
    required Color accentColor,
    required VoidCallback onLoginPressed,
    required VoidCallback onRegisterPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: backgroundColor == Colors.white 
              ? const Color(0xFF540863) 
              : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 28,
                    color: backgroundColor == Colors.white
                        ? const Color(0xFF540863)
                        : const Color(0xFFFCF5EE),
                  ),
                ),
                const SizedBox(width: 16),
                // Title
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: foregroundColor,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Description
            Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: backgroundColor == Colors.white
                    ? const Color(0xFF92487A)
                    : const Color(0xFFFFD3D5),
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Buttons
            Row(
              children: [
                // Login Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor == Colors.white
                          ? const Color(0xFF540863)
                          : const Color(0xFFFCF5EE),
                      foregroundColor: backgroundColor == Colors.white
                          ? const Color(0xFFFCF5EE)
                          : const Color(0xFF540863),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Masuk',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Register Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRegisterPressed,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: backgroundColor == Colors.white
                          ? const Color(0xFF540863)
                          : const Color(0xFFFCF5EE),
                      side: BorderSide(
                        color: backgroundColor == Colors.white
                            ? const Color(0xFF540863)
                            : const Color(0xFFFCF5EE),
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Daftar',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}