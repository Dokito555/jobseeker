import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

// Import data sources
import 'package:jobseeker/data/source/local/auth_local_datasource.dart';
import 'package:jobseeker/data/source/local/company_auth_local_datasource.dart';
import 'package:jobseeker/data/source/remote/company_auth_remote_datasource.dart';
import 'package:jobseeker/data/source/remote/job_remote_datasource.dart';
import 'package:jobseeker/data/source/remote/user_auth_remote_datasource.dart';
import 'package:jobseeker/data/source/remote/chat_remote_datasource.dart';

// Import repositories
import 'package:jobseeker/domain/repositories/user_auth_repository.dart';
import 'package:jobseeker/domain/repositories/company_auth_repository.dart';
import 'package:jobseeker/domain/repositories/job_repository.dart';
import 'package:jobseeker/domain/repositories/chat_repository.dart';

// Import BLoCs
import 'package:jobseeker/presentation/auth/auth_bloc.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_bloc.dart';
import 'package:jobseeker/presentation/job/job_bloc.dart';
import 'package:jobseeker/presentation/chat/chat_bloc.dart';

// Import pages
import 'package:jobseeker/presentation/pages/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // User Auth Repository
        RepositoryProvider<UserAuthRepository>(
          create: (_) => UserAuthRepositoryImpl(
            remoteDatasource: UserAuthRemoteDatasourceImpl(),
            localDatasource: AuthLocalDatasourceImpl(),
          ),
        ),
        
        // Company Auth Repository
        RepositoryProvider<CompanyAuthRepository>(
          create: (_) => CompanyAuthRepositoryImpl(
            remoteDatasource: CompanyAuthRemoteDatasourceImpl(),
            localDatasource: CompanyAuthLocalDatasourceImpl(),
          ),
        ),
        
        // Job Repository
        RepositoryProvider<JobRepository>(
          create: (_) => JobRepositoryImpl(
            remoteDatasource: JobRemoteDatasourceImpl(),
            localDatasource: CompanyAuthLocalDatasourceImpl(),
          ),
        ),
        
        // Chat Repository
        RepositoryProvider<ChatRepository>(
          create: (_) => ChatRepositoryImpl(
            remoteDatasource: ChatRemoteDatasourceImpl(),
            userLocalDatasource: AuthLocalDatasourceImpl(),
            companyLocalDatasource: CompanyAuthLocalDatasourceImpl(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              repo: context.read<UserAuthRepository>(),
            ),
          ),
          BlocProvider<CompanyAuthBloc>(
            create: (context) => CompanyAuthBloc(
              repo: context.read<CompanyAuthRepository>(),
            ),
          ),
          BlocProvider<JobBloc>(
            create: (context) => JobBloc(
              repository: context.read<JobRepository>(),
            ),
          ),
          BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(
              repository: context.read<ChatRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'RoeWATI',
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(),
          home: const SplashPage(),
        ),
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      
      // Color Scheme (sesuai design system)
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF540863), // Primary
        primary: const Color(0xFF540863),
        secondary: const Color(0xFF92487A),
        surface: const Color(0xFFFCF5EE),
        background: const Color(0xFFFCF5EE),
      ),
      
      // Scaffold background
      scaffoldBackgroundColor: const Color(0xFFFCF5EE),
      
      // Text Theme (Plus Jakarta Sans & Poppins)
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF43334C),
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF43334C),
        ),
        displaySmall: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF43334C),
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF43334C),
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF43334C),
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF43334C),
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          color: const Color(0xFF43334C),
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          color: const Color(0xFF43334C),
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          color: const Color(0xFF92487A),
        ),
      ),
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF540863),
        foregroundColor: const Color(0xFFFCF5EE),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFFCF5EE),
        ),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF540863),
          foregroundColor: const Color(0xFFFCF5EE),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF540863),
          side: const BorderSide(color: Color(0xFF540863), width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE49BA6), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE49BA6), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF540863), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF92487A),
        ),
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: const Color(0xFF92487A),
        ),
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE49BA6), width: 2),
        ),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFFFD3D5),
        selectedColor: const Color(0xFF540863),
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: const Color(0xFF43334C),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE49BA6), width: 2),
        ),
      ),
    );
  }
}

// Design System Colors (untuk reference di file lain)
class AppColors {
  static const primaryDark = Color(0xFF43334C);
  static const primary = Color(0xFF540863);
  static const secondary = Color(0xFF92487A);
  static const accent = Color(0xFFE49BA6);
  static const lightPink = Color(0xFFFFD3D5);
  static const background = Color(0xFFFCF5EE);
}