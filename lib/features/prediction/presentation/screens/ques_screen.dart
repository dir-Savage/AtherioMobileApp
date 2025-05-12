import 'package:atherio/features/prediction/presentation/blocs/diagnosis_bloc.dart';
import 'package:atherio/features/prediction/presentation/screens/results_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionnairePage extends StatefulWidget {
  final String doctorId;
  final String patientName;
  final String patientPhoneNumber;
  final int patientAge;

  const QuestionnairePage({
    super.key,
    required this.doctorId,
    required this.patientName,
    required this.patientPhoneNumber,
    required this.patientAge,
  });

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final _formKey = GlobalKey<FormState>();
  final _questions = [
    'Fold change of RAMP (logarithmic scale)',
    'Fold change of FENDRlogarithmic scale)',
    'triglycerides',
    'CKMB',
    'Troponin',
    'BMI',
    'age',
  ];
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(7, (index) {
      if (index == 6) {
        return TextEditingController(text: widget.patientAge.toString());
      }
      return TextEditingController();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnosis Questionnaire')),
      body: BlocConsumer<DiagnosisBloc, DiagnosisState>(
        listener: (context, state) {
          if (state is DiagnosisSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DiagnosisResultsPage(
                  diagnosis: state.diagnosis,
                  caseData: state.caseData,
                ),
              ),
            );
          } else if (state is DiagnosisFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  for (int i = 0; i < _questions.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: _controllers[i],
                        decoration: InputDecoration(
                          labelText: _questions[i],
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '${_questions[i]} is required';
                          }
                          try {
                            final number = double.parse(value);
                            if (i == 6 && number < 0) {
                              return 'Age cannot be negative';
                            }
                            return null;
                          } catch (e) {
                            return 'Please enter a valid number';
                          }
                        },
                      ),
                    ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state is DiagnosisLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              final inputData = <String, double>{};
                              for (int i = 0; i < _questions.length; i++) {
                                final value = _controllers[i].text.trim();
                                inputData[_questions[i]] = double.parse(value);
                              }
                              context.read<DiagnosisBloc>().add(
                                    SubmitDiagnosisEvent(
                                      doctorId: widget.doctorId,
                                      patientName: widget.patientName,
                                      patientPhoneNumber:
                                          widget.patientPhoneNumber,
                                      inputData: inputData,
                                      questions: _questions,
                                    ),
                                  );
                            }
                          },
                    child: state is DiagnosisLoading
                        ? const CircularProgressIndicator()
                        : const Text('Submit Diagnosis'),
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
