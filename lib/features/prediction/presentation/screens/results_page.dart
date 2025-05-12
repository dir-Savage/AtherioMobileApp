import 'package:atherio/features/prediction/domain/entities/diagnosis.dart';
import 'package:atherio/features/prediction/presentation/screens/doctor_list_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DiagnosisResultsPage extends StatefulWidget {
  final Diagnosis diagnosis;
  final Map<String, dynamic> caseData;

  const DiagnosisResultsPage({
    super.key,
    required this.diagnosis,
    required this.caseData,
  });

  @override
  State<DiagnosisResultsPage> createState() => _DiagnosisResultsPageState();
}

class _DiagnosisResultsPageState extends State<DiagnosisResultsPage> {
  bool _isSending = false;
  String? _apiError;

  @override
  void initState() {
    super.initState();
    _sendToGeminiAI();
  }

  Future<void> _sendToGeminiAI() async {
    setState(() {
      _isSending = true;
      _apiError = null;
    });

    try {
      // Aggregate data
      final dataToSend = {
        'diagnosis': {
          'primaryClassification': widget.diagnosis.primaryClassification,
          'specificDiagnosis': widget.diagnosis.specificDiagnosis,
        },
        'caseData': widget.caseData,
      };

      // Replace with your Gemini AI API endpoint and key
      const apiUrl = 'https://api.gemini.ai/v1/process'; // Placeholder
      const apiKey =
          'AIzaSyDZShKX1PqWe5Zf3hp8hqHa56gvo4eRfto'; // Store securely

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(dataToSend),
      );

      if (response.statusCode == 200) {
        debugPrint('Successfully sent to Gemini AI: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data sent to Gemini AI successfully')),
        );
      } else {
        debugPrint(
            'Gemini AI API error: ${response.statusCode} ${response.body}');
        setState(() {
          _apiError =
              'Failed to send data to Gemini AI: ${response.statusCode}';
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Error sending to Gemini AI: $e\n$stackTrace');
      setState(() {
        _apiError = 'Error sending data to Gemini AI: $e';
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnosis Results')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diagnosis Results',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              'Primary Classification:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              widget.diagnosis.primaryClassification,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Specific Diagnosis:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              widget.diagnosis.specificDiagnosis,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            if (_isSending)
              const Center(child: CircularProgressIndicator())
            else if (_apiError != null)
              Text(
                _apiError!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.red),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isSending
                  ? null
                  : () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DoctorsListPage()),
                        (route) => false,
                      );
                    },
              child: const Text('Done'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
