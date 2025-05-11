import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/diagnosis_bloc.dart';
import 'results_page.dart';

class QuestionnairePage extends StatefulWidget {
  final String doctorId;
  final String patientName;
  final String patientPhoneNumber;

  const QuestionnairePage({
    super.key,
    required this.doctorId,
    required this.patientName,
    required this.patientPhoneNumber,
  });

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final List<String> _questions = [
    'Fold change of RAMP (logarithmic scale)',
    'Fold change of FENDRlogarithmic scale)',
    'triglycerides',
    'CKMB',
    'Troponin',
    'BMI',
    'age',
  ];

  @override
  void initState() {
    super.initState();
    for (var question in _questions) {
      _controllers[question] = TextEditingController();
    }
    debugPrint('Initialized controllers: ${_controllers.keys.toList()}');
  }

  void _submitForm() {
    try {
      final inputData = <String, double>{};
      for (var key in _questions) {
        final controller = _controllers[key];
        if (controller == null) {
          debugPrint('Error: No controller for $key');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: Missing controller for $key')),
          );
          return;
        }
        final text = controller.text.trim().replaceAll(',', '.');
        debugPrint('Parsing $key: text="$text"');
        inputData[key] = double.tryParse(text) ?? 0.0;
      }
      debugPrint('Submitting inputData: $inputData');
      context.read<DiagnosisBloc>().add(SubmitDiagnosisEvent(
            doctorId: widget.doctorId,
            patientName: widget.patientName,
            patientPhoneNumber: widget.patientPhoneNumber,
            inputData: inputData,
            questions: _questions,
          ));
    } catch (e, stackTrace) {
      debugPrint('Error in _submitForm: $e\n$stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission error: $e')),
      );
    }
  }

  @override
  void dispose() {
    debugPrint(
        'Disposing QuestionnairePage: ${_controllers.map((k, v) => MapEntry(k, v.text))}');
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      debugPrint(
          'Building QuestionnairePage: ${_controllers.map((k, v) => MapEntry(k, v.text))}');
      return Scaffold(
        appBar: AppBar(title: const Text('Medical Questionnaire')),
        body: BlocListener<DiagnosisBloc, DiagnosisState>(
          listener: (context, state) {
            try {
              if (state is DiagnosisSuccess && mounted) {
                debugPrint('DiagnosisSuccess: ${state.diagnosis}');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultPage(
                      diagnosis: state.diagnosis,
                      patientName: widget.patientName,
                    ),
                  ),
                );
              } else if (state is DiagnosisFailure) {
                debugPrint('DiagnosisFailure: ${state.message}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              }
            } catch (e, stackTrace) {
              debugPrint('Error in BlocListener: $e\n$stackTrace');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Navigation error: $e')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  ..._questions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final question = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Question ${index + 1}: $question',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _controllers[question] ??
                                TextEditingController(),
                            decoration: InputDecoration(
                              labelText: question,
                              border: const OutlineInputBorder(),
                              hintText: 'Enter value (e.g., 2.5)',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            onChanged: (value) {
                              debugPrint('Input $question: $value');
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('Error in build: $e\n$stackTrace');
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Text('Build error: $e\nPlease try again.'),
        ),
      );
    }
  }
}
