import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api'; // Change to your XAMPP URL
  static const Duration timeout = Duration(seconds: 30);

  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<http.Response> _handleResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else {
      final error = json.decode(response.body);
      throw Exception(error['message'] ?? 'API Error: ${response.statusCode}');
    }
  }

  // Schools endpoints
  Future<http.Response> getSchools({Map<String, dynamic>? filters}) async {
    final uri = Uri.parse('$baseUrl/schools');
    if (filters != null && filters.isNotEmpty) {
      uri.replace(queryParameters: filters.map((key, value) =>
          MapEntry(key, value.toString())));
    }

    return await http.get(uri, headers: headers).timeout(timeout);
  }

  Future<http.Response> getSchool(int id) async {
    final uri = Uri.parse('$baseUrl/schools/$id');
    return await http.get(uri, headers: headers).timeout(timeout);
  }

  Future<http.Response> createSchool(Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/schools');
    return await http.post(
      uri,
      headers: headers,
      body: json.encode(data),
    ).timeout(timeout);
  }

  Future<http.Response> updateSchool(int id, Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/schools/$id');
    return await http.put(
      uri,
      headers: headers,
      body: json.encode(data),
    ).timeout(timeout);
  }

  Future<http.Response> deleteSchool(int id) async {
    final uri = Uri.parse('$baseUrl/schools/$id');
    return await http.delete(uri, headers: headers).timeout(timeout);
  }

  // Subscriptions endpoints
  Future<http.Response> getSubscriptions({Map<String, dynamic>? filters}) async {
    final uri = Uri.parse('$baseUrl/subscriptions');
    if (filters != null && filters.isNotEmpty) {
      uri.replace(queryParameters: filters.map((key, value) =>
          MapEntry(key, value.toString())));
    }
    return await http.get(uri, headers: headers).timeout(timeout);
  }

  Future<http.Response> getPlans() async {
    final uri = Uri.parse('$baseUrl/plans');
    return await http.get(uri, headers: headers).timeout(timeout);
  }

  Future<http.Response> createSubscription(Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/subscriptions');
    return await http.post(
      uri,
      headers: headers,
      body: json.encode(data),
    ).timeout(timeout);
  }

  // Invoices endpoints
  Future<http.Response> getInvoices({Map<String, dynamic>? filters}) async {
    final uri = Uri.parse('$baseUrl/invoices');
    if (filters != null && filters.isNotEmpty) {
      uri.replace(queryParameters: filters.map((key, value) =>
          MapEntry(key, value.toString())));
    }
    return await http.get(uri, headers: headers).timeout(timeout);
  }

  Future<http.Response> createInvoice(Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/invoices');
    return await http.post(
      uri,
      headers: headers,
      body: json.encode(data),
    ).timeout(timeout);
  }
}