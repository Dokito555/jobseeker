// lib/main.dart - Updated with ChatBloc

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobseeker/data/source/local/auth_local_datasource.dart';
import 'package:jobseeker/data/source/local/company_auth_local_datasource.dart';
import 'package:jobseeker/data/source/remote/company_auth_remote_datasource.dart';
import 'package:jobseeker/data/source/remote/job_remote_datasource.dart';
import 'package:jobseeker/data/source/remote/user_auth_remote_datasource.dart';
import 'package:jobseeker/data/source/remote/chat_remote_datasource.dart';
import 'package:jobseeker/domain/repositories/company_auth_repository.dart';
import 'package:jobseeker/domain/repositories/job_repository.dart';
import 'package:jobseeker/domain/repositories/user_auth_repository.dart';
import 'package:jobseeker/domain/repositories/chat_repository.dart';
import 'package:jobseeker/presentation/auth/auth_bloc.dart';
import 'package:jobseeker/presentation/auth/auth_event.dart';
import 'package:jobseeker/presentation/auth/auth_state.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_bloc.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_event.dart';
import 'package:jobseeker/presentation/company_auth/company_auth_state.dart';
import 'package:jobseeker/presentation/job/job_bloc.dart';
import 'package:jobseeker/presentation/chat/chat_bloc.dart';
import 'package:jobseeker/presentation/pages/company_home_page.dart';
import 'package:jobseeker/presentation/pages/home_page.dart';
import 'package:jobseeker/presentation/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserAuthRepository>(
          create: (_) => UserAuthRepositoryImpl(
            remoteDatasource: UserAuthRemoteDatasourceImpl(),
            localDatasource: AuthLocalDatasourceImpl(),
          ),
        ),
        RepositoryProvider<CompanyAuthRepository>(
          create: (_) => CompanyAuthRepositoryImpl(
            remoteDatasource: CompanyAuthRemoteDatasourceImpl(),
            localDatasource: CompanyAuthLocalDatasourceImpl(),
          ),
        ),
        RepositoryProvider<JobRepository>(
          create: (_) => JobRepositoryImpl(
            remoteDatasource: JobRemoteDatasourceImpl(),
            localDatasource: CompanyAuthLocalDatasourceImpl(),
          ),
        ),
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
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(CheckAuthStatusEvent());
      context.read<CompanyAuthBloc>().add(CheckCompanyAuthStatusEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jobseeker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocBuilder<CompanyAuthBloc, CompanyAuthState>(
        builder: (context, companyAuthState) {
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, userAuthState) {
              if (companyAuthState is CompanyAuthInitial || 
                  userAuthState is AuthInitial) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (companyAuthState is CompanyAuthAuthenticated) {
                return const CompanyHomePage();
              }
              
              if (userAuthState is AuthAuthenticated) {
                return const HomePage();
              }
          
              return const LoginPage();
            },
          );
        },
      ),
    );
  }
}