import 'package:atherio/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:atherio/features/auth/presentation/screens/login_page.dart';
import 'package:atherio/features/chatbot/presentation/blocs/chat_bloc.dart';
import 'package:atherio/features/prediction/presentation/blocs/diagnosis_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await configureDependencies();
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>()..add(GetCurrentUserEvent()),
        ),
        BlocProvider(
          create: (context) => getIt<DiagnosisBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<ChatBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Medical Diagnosis App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
