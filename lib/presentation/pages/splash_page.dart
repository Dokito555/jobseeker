import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// Import BLoCs
import 'package:jobseeker/presentation/auth/auth_bloc.dart';
import 'package:jobseeker/presentation/auth/auth_event.dart';
import 'package:jobseeker/presentation/auth/auth_state.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_bloc.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_event.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_state.dart';

// Import pages
import 'package:jobseeker/presentation/pages/auth_selection_page.dart';
import 'package:jobseeker/presentation/pages/home_page.dart';
import 'package:jobseeker/presentation/pages/company_home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    
    _animationController.forward();
    
    // Check auth status after animation
    Future.delayed(const Duration(milliseconds: 5000), () {
      _checkAuthStatus();
    });
  }

  void _checkAuthStatus() {
    // Check both User and Company auth
    if (!mounted) return;
    context.read<AuthBloc>().add(CheckAuthStatusEvent());
    context.read<CompanyAuthBloc>().add(CheckCompanyAuthStatusEvent());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          // Listen to User Auth
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                // User is logged in, go to HomePage
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const HomePage()),
                );
              } else if (state is AuthUnauthenticated) {
                // Check company auth before going to selection
                final companyState = context.read<CompanyAuthBloc>().state;
                if (companyState is! CompanyAuthAuthenticated) {
                  _navigateToAuthSelection();
                }
              }
            },
          ),
          
          // Listen to Company Auth
          BlocListener<CompanyAuthBloc, CompanyAuthState>(
            listener: (context, state) {
              if (state is CompanyAuthAuthenticated) {
                // Company is logged in, go to CompanyHomePage
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const CompanyHomePage()),
                );
              } else if (state is CompanyAuthUnauthenticated) {
                // Check user auth before going to selection
                final userState = context.read<AuthBloc>().state;
                if (userState is! AuthAuthenticated) {
                  _navigateToAuthSelection();
                }
              }
            },
          ),
        ],
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF540863), // Primary
                Color(0xFF92487A), // Secondary
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                // Logo & App Name
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      children: [
                        // Logo Icon
                        Container(
                          width: 120,
                          height: 120,
                          child: Image.asset(
                            'assets/images/Logo.png', // Ganti dengan path gambar Anda
                            fit: BoxFit.contain, // Pastikan gambar sesuai dengan ukuran container
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // App Name
                        Text(
                          'RoeWATI',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFCF5EE),
                            letterSpacing: -1,
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Tagline
                        Text(
                          'Cari Pekerjaan yang Kamu Impikan di Sini!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: const Color(0xFFFFD3D5),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Loading Indicator
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // Animated dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: Duration(milliseconds: 600 + (index * 150)),
                            builder: (context, value, child) {
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Color.lerp(
                                    const Color(0xFF92487A),
                                    const Color(0xFFE49BA6),
                                    value,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              );
                            },
                            onEnd: () {
                              setState(() {});
                            },
                          );
                        }),
                      ),
                      
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToAuthSelection() {
    // Only navigate if not already navigating
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const AuthSelectionPage(),
        ),
      );
    }
  }
}