import 'package:atherio/features/prediction/presentation/screens/patient_details.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Map<String, dynamic> user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final doctorId = user['id'] as String;
    final firstName = user['firstName'] as String;
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, Dr. $firstName'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PatientDetailsPage(doctorId: doctorId),
                  ),
                );
              },
              child: const Text('Add New Patient'),
            ),
          ],
        ),
      ),
    );
  }
}
