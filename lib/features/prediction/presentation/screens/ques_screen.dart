import 'package:atherio/features/prediction/presentation/screens/results_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/diagnosis_bloc.dart';

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
  final _controllers = {
    'Fold change of RAMP (logarithmic scale)': TextEditingController(),
    'Fold change of FENDRlogarithmic scale)': TextEditingController(),
    'triglycerides': TextEditingController(),
    'CKMB': TextEditingController(),
    'Troponin': TextEditingController(),
    'BMI': TextEditingController(),
    'age': TextEditingController(),
  };
  int _currentQuestionIndex = 0;
  final _pageController = PageController();

  final List<String> _questions = [
    'Fold change of RAMP (logarithmic scale)',
    'Fold change of FENDRlogarithmic scale)',
    'triglycerides',
    'CKMB',
    'Troponin',
    'BMI',
    'age',
  ];

  void _nextQuestion() {
    if (_formKey.currentState!.validate()) {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _submitForm();
      }
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final inputData = _controllers.map((key, controller) {
        return MapEntry(key, double.parse(controller.text));
      });
      context.read<DiagnosisBloc>().add(SubmitDiagnosisEvent(
        doctorId: widget.doctorId,
        patientName: widget.patientName,
        patientPhoneNumber: widget.patientPhoneNumber,
        inputData: inputData,
        questions: _questions,
      ));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Questionnaire'),
      ),
      body: BlocListener<DiagnosisBloc, DiagnosisState>(
        listener: (context, state) {
          if (state is DiagnosisSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ResultPage(
                  diagnosis: state.diagnosis,
                  patientName: widget.patientName,
                ),
              ),
            );
          }
          if (state is DiagnosisFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      return AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Question ${index + 1} of ${_questions.length}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _questions[index],
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _controllers[_questions[index]],
                              decoration: InputDecoration(
                                labelText: _questions[index],
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                try {
                                  double.parse(value);
                                  return null;
                                } catch (e) {
                                  return 'Please enter a valid number';
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentQuestionIndex > 0)
                      ElevatedButton(
                        onPressed: _previousQuestion,
                        child: const Text('Previous'),
                      )
                    else
                      const SizedBox(),
                    ElevatedButton(
                      onPressed: _nextQuestion,
                      child: Text(
                        _currentQuestionIndex == _questions.length - 1
                            ? 'Submit'
                            : 'Next',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}