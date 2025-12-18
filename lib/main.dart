import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobseeker/data/source/local/auth_local_datasource.dart';
import 'package:jobseeker/data/source/remote/user_auth_remote_datasource.dart';
import 'package:jobseeker/domain/repositories/user_auth_repository.dart';
import 'package:jobseeker/presentation/auth/auth_bloc.dart';
import 'package:jobseeker/presentation/auth/auth_event.dart';
import 'package:jobseeker/presentation/auth/auth_state.dart';
import 'package:jobseeker/presentation/pages/home_page.dart';
import 'package:jobseeker/presentation/pages/login_page.dart';
import 'package:jobseeker/presentation/pages/register_page.dart';

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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              repo: context.read<UserAuthRepository>(),
            ),
          ),
        ],
        child: const AppView(),
      )
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
    context.read<AuthBloc>().add(CheckAuthStatusEvent());
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
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return const HomePage();
          }
          if (state is AuthUnauthenticated) {
            return const LoginPage();
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}