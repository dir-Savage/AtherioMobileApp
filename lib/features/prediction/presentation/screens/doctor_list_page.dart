import 'package:atherio/features/prediction/presentation/blocs/diagnosis_bloc.dart';
import 'package:atherio/features/prediction/presentation/screens/doctors_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorsListPage extends StatelessWidget {
  const DoctorsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger fetching all doctors when the page is built
    context.read<DiagnosisBloc>().add(GetAllDoctorsEvent());

    return Scaffold(
      appBar: AppBar(title: const Text('All Doctors')),
      body: BlocConsumer<DiagnosisBloc, DiagnosisState>(
        listener: (context, state) {
          if (state is DiagnosisFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is DiagnosisLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetAllDoctorsSuccess) {
            if (state.doctors.isEmpty) {
              return const Center(child: Text('No doctors found'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.doctors.length,
              itemBuilder: (context, index) {
                final doctor = state.doctors[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      'Dr. ${doctor['firstName']} ${doctor['lastName']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Email: ${doctor['email']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DoctorDetailsPage(doctor: doctor),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No data available'));
        },
      ),
    );
  }
}
