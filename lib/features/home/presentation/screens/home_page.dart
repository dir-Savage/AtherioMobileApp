import 'package:atherio/features/auth/domain/entities/user_entity.dart';
import 'package:atherio/features/prediction/presentation/blocs/diagnosis_bloc.dart';
import 'package:atherio/features/prediction/presentation/screens/doctor_list_page.dart';
import 'package:atherio/features/prediction/presentation/screens/patient_details.dart';
import 'package:atherio/features/prediction/presentation/screens/case_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Dashboard')),
      body: BlocListener<DiagnosisBloc, DiagnosisState>(
        listener: (context, state) {
          if (state is DiagnosisFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, Dr. ${widget.user.firstName} ${widget.user.lastName}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text('ID: ${widget.user.id}',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Email: ${widget.user.email}',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  'Created At: ${widget.user.createdAt.toIso8601String()}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'List 1 (Cases):',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                widget.user.list1.isEmpty
                    ? const Text('No cases in List 1')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.user.list1
                            .map((caseId) => InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            CaseDetailsPage(caseId: caseId),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(
                                      '- $caseId',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                const SizedBox(height: 16),
                const Text(
                  'List 2:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                widget.user.list2.isEmpty
                    ? const Text('No items in List 2')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.user.list2
                            .map((item) => Text('- $item'))
                            .toList(),
                      ),
                const SizedBox(height: 24),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Patients by Name or Phone',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        if (_searchController.text.trim().isNotEmpty) {
                          context.read<DiagnosisBloc>().add(
                                SearchPatientsEvent(
                                    _searchController.text.trim()),
                              );
                        }
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      context.read<DiagnosisBloc>().add(
                            SearchPatientsEvent(value.trim()),
                          );
                    }
                  },
                ),
                const SizedBox(height: 16),
                BlocBuilder<DiagnosisBloc, DiagnosisState>(
                  builder: (context, state) {
                    if (state is DiagnosisLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SearchPatientsSuccess) {
                      if (state.patients.isEmpty) {
                        return const Text('No patients found.');
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.patients.length,
                        itemBuilder: (context, index) {
                          final patient = state.patients[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name: ${patient['name']}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Phone: ${patient['phoneNumber']}'),
                                  const SizedBox(height: 8),
                                  Text('Patient ID: ${patient['id']}'),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Cases:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  patient['cases'].isEmpty
                                      ? const Text('No cases')
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: (patient['cases'] as List)
                                              .map((caseId) => InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              CaseDetailsPage(
                                                                  caseId:
                                                                      caseId),
                                                        ),
                                                      );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 4.0),
                                                      child: Text(
                                                        '- $caseId',
                                                        style: const TextStyle(
                                                          color: Colors.blue,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        ),
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PatientDetailsPage(doctorId: widget.user.id),
                      ),
                    );
                  },
                  child: const Text('Add New Patient'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DoctorsListPage(),
                      ),
                    );
                  },
                  child: const Text('View All Doctors'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
