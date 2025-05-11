import 'dart:async';
import 'package:atherio/features/prediction/presentation/blocs/diagnosis_bloc.dart';
import 'package:atherio/features/prediction/presentation/screens/ques_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PatientDetailsPage extends StatefulWidget {
  final String doctorId;

  const PatientDetailsPage({super.key, required this.doctorId});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedPatientId;
  bool _isNewPatient = true;
  Timer? _debounce;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _searchPatients(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<DiagnosisBloc>().add(SearchPatientsEvent(query));
      } else {
        context.read<DiagnosisBloc>().add(const SearchPatientsEvent(''));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Details')),
      body: BlocConsumer<DiagnosisBloc, DiagnosisState>(
        listener: (context, state) {
          if (state is DiagnosisFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is PatientSelectedSuccess) {
            _nameController.text = state.patientName;
            _phoneController.text = state.patientPhoneNumber;
            _ageController.text = state.patientAge.toString();
            _selectedPatientId = state.patientId;
            _isNewPatient = false;
            context.read<DiagnosisBloc>().add(const SearchPatientsEvent(''));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Patient Name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _searchPatients(value);
                      if (_isNewPatient) {
                        _selectedPatientId = null;
                        _phoneController.clear();
                        _ageController.clear();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  if (state is SearchPatientsSuccess &&
                      state.patients.isNotEmpty)
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.patients.length,
                        itemBuilder: (context, index) {
                          final patient = state.patients[index];
                          return ListTile(
                            title: Text(patient['name']),
                            subtitle: Text(
                                'Phone: ${patient['phoneNumber']} | Age: ${patient['age']}'),
                            onTap: () {
                              context
                                  .read<DiagnosisBloc>()
                                  .add(SelectPatientEvent(patient['id']));
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: const OutlineInputBorder(),
                      enabled: _isNewPatient,
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      border: const OutlineInputBorder(),
                      enabled: _isNewPatient,
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      final name = _nameController.text.trim();
                      final phone = _phoneController.text.trim();
                      final age = _ageController.text.trim();
                      if (name.isEmpty || phone.isEmpty || age.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please fill in all fields')),
                        );
                        return;
                      }
                      try {
                        final ageValue = int.parse(age);
                        if (ageValue < 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Age cannot be negative')),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuestionnairePage(
                              doctorId: widget.doctorId,
                              patientName: name,
                              patientPhoneNumber: phone,
                              patientAge: ageValue,
                            ),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter a valid age')),
                        );
                      }
                    },
                    child: const Text('Proceed to Questionnaire'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isNewPatient = true;
                        _selectedPatientId = null;
                        _nameController.clear();
                        _phoneController.clear();
                        _ageController.clear();
                        context
                            .read<DiagnosisBloc>()
                            .add(const SearchPatientsEvent(''));
                      });
                    },
                    child: const Text('Add New Patient'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
