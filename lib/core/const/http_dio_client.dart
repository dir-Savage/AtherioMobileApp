import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class ApiClient {
  static const String baseUrl = "http://127.0.0.1:5000";

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      // First try using http
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        // Try Dio if non-200 status code
        throw Exception("HTTP failed with ${response.statusCode}");
      }
    } catch (e) {
      // Fall back to Dio if http fails
      try {
        final dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {'Content-Type': 'application/json'},
        ));

        final dioResponse = await dio.post(endpoint, data: body);
        return dioResponse.data;
      } catch (dioError) {
        // If Dio also fails, throw final error
        throw Exception("Both http and Dio failed: $dioError");
      }
    }
  }
}
