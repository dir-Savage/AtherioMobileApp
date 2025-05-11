import 'package:atherio/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:atherio/features/auth/presentation/screens/login_page.dart';
import 'package:atherio/features/home/presentation/screens/home_page.dart';
import 'package:atherio/features/prediction/domain/entities/diagnosis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultPage extends StatelessWidget {
  final Diagnosis diagnosis;
  final String patientName;

  const ResultPage({
    super.key,
    required this.diagnosis,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnosis Result')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => HomePage(user: {
                  'id': state.user.id,
                  'firstName': state.user.firstName,
                  'lastName': state.user.lastName,
                  'email': state.user.email,
                }),
              ),
              (route) => false,
            );
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Diagnosis for $patientName',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'Primary Classification: ${diagnosis.primaryClassification}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Specific Diagnosis: ${diagnosis.specificDiagnosis}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            context.read<AuthBloc>().add(GetCurrentUserEvent());
                          },
                    child: state is AuthLoading
                        ? const CircularProgressIndicator()
                        : const Text('Back to Dashboard'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
