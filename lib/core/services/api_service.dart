import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bustracker_007/data/models/web/subscription_plan.dart';

class ApiService {
  static const String baseUrl = 'http://localhost/track_x';
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


  Future<SubscriptionPlan> getPlanById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/plans/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return SubscriptionPlan.fromJson(data);
    } else {
      throw Exception('Failed to load plan: ${response.statusCode}');
    }
  }

  Future<List<SubscriptionPlan>> getAllPlans() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/plans'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((plan) => SubscriptionPlan.fromJson(plan)).toList();
      } else {
        throw Exception('Failed to load plans: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading plans: $e');
      rethrow;
    }
  }

  // CREATE new plan
  Future<SubscriptionPlan> createPlan(SubscriptionPlan plan) async {
    try {
      print('Creating plan: ${plan.toJson()}');

      final response = await http.post(
        Uri.parse('$baseUrl/plans'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(plan.toJson()),
      );

      print('Create plan response: ${response.statusCode}');
      print('Response body: ${response.body}');

      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('application/json')) {
        final data = json.decode(response.body);

        if (response.statusCode == 201) {
          return SubscriptionPlan.fromJson(data);
        } else {
          throw Exception('Failed to create plan: ${data['message'] ?? response.body}');
        }
      } else {
        throw Exception('Server returned non-JSON response: ${response.body.substring(0, 100)}...');
      }
    } catch (e) {
      print('Error creating plan: $e');
      rethrow;
    }
  }

  // UPDATE plan
  Future<SubscriptionPlan> updatePlan(int id, SubscriptionPlan plan) async {
    try {
      print('Updating plan $id: ${plan.toJson()}');

      final response = await http.put(
        Uri.parse('$baseUrl/plans/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(plan.toJson()),
      );

      print('Update plan response: ${response.statusCode}');
      print('Response body: ${response.body}');

      final contentType = response.headers['content-type'];
      if (contentType != null && contentType.contains('application/json')) {
        final data = json.decode(response.body);

        if (response.statusCode == 200) {
          return SubscriptionPlan.fromJson(data);
        } else {
          throw Exception('Failed to update plan: ${data['message'] ?? response.body}');
        }
      } else {
        throw Exception('Server returned non-JSON response: ${response.body.substring(0, 100)}...');
      }
    } catch (e) {
      print('Error updating plan: $e');
      rethrow;
    }
  }

  Future<void> deletePlan(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/plans/$id'));

    if(response.statusCode != 200) {
      throw Exception('Failed to delete plan: ${response.statusCode}');
    }
  }
}