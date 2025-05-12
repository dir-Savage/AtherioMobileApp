import 'package:atherio/core/di/service_locator.dart';
import 'package:atherio/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:atherio/features/auth/presentation/screens/login_page.dart';
import 'package:atherio/features/chatbot/presentation/blocs/chat_bloc.dart';
import 'package:atherio/features/prediction/presentation/blocs/diagnosis_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'core/di/injection.dart';

final getIt = GetIt.instance;

Future<void> migrateFirestore() async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();

  // Migrate patients
  final patients = await firestore.collection('patients').get();
  for (var doc in patients.docs) {
    if (!doc.data().containsKey('age')) {
      batch.update(doc.reference, {'age': 0});
    }
    if (!doc.data().containsKey('cases')) {
      batch.update(doc.reference, {'cases': []});
    }
  }

  // Migrate cases
  final cases = await firestore.collection('cases').get();
  for (var doc in cases.docs) {
    if (!doc.data().containsKey('patientAge')) {
      batch.update(doc.reference, {
        'patientAge': doc.data()['answers']?.length > 6
            ? doc.data()['answers'][6].toInt()
            : 0
      });
    }
  }

  await batch.commit();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init(); // Initialize dependencies (from injection.dart)
  //await dotenv.load(fileName: ".env");
  runApp(const MyApp());
  await migrateFirestore(); // Run migration
  setupServiceLocator();
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
