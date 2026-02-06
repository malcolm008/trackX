import 'dart:convert';
import 'package:bustracker_007/data/models/web/school.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:bustracker_007/data/models/web/subscription_plan.dart';
import 'package:bustracker_007/data/models/web/school_subscription.dart';

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

// In your ApiService class
  Future<List<SchoolSubscription>> getSubscriptions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/subscriptions'), // Replace with your actual endpoint
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('DEBUG: API Response Status: ${response.statusCode}');
      print('DEBUG: API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('DEBUG: Parsed ${data.length} subscription items');

        return data.map((json) => SchoolSubscription.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load subscriptions: ${response.statusCode}');
      }
    } catch (e) {
      print('ERROR in getSubscriptions: $e');
      rethrow;
    }
  }

  Future<SchoolSubscription> createSubscription(Map<String, dynamic> data) async {
    try {
      print('DEBUG: Creating subscription with data: $data');

      final response = await http.post(
        Uri.parse('$baseUrl/subscriptions'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      print('DEBUG: Create response status: ${response.statusCode}');
      print('DEBUG: Create response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('DEBUG: Subscription created successfully: $responseData');

        // Build a complete JSON object with all required fields
        final subscriptionJson = {
          'id': responseData['id'],
          'subscription_code': responseData['subscription_code'],
          'school_code': data['school_code'],
          'school_name': data['school_name'],
          'school_email': data['school_email'],
          'school_phone': data['school_phone'],
          'school_address': data['school_address'],
          'total_students': data['total_students'],
          'total_buses': data['total_buses'],
          'plan_id': data['plan_id'],
          'amount': data['amount'],
          'status': data['status'],
          'start_date': data['start_date'],
          'end_date': responseData['end_date'],
          'auto_renew': data['auto_renew'],
          'payment_method': data['payment_method'],
          'transaction_id': data['transaction_id'],
          'created_at': DateTime.now().toIso8601String(),
          'billing_cycle': responseData['billing_cycle'],
          // Add plan fields if needed
          'plan_name': '', // You might need to fetch this separately
        };

        print('DEBUG: Built subscriptionJson: $subscriptionJson');

        return SchoolSubscription.fromJson(subscriptionJson);
      } else {
        throw Exception('Failed to create subscription. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('ERROR in createSubscription: $e');
      throw Exception('Failed to create subscription: $e');
    }
  }

  Future<void> updateSubscription(int id, Map<String, dynamic> data) async {
    try {
      print('DEBUG: Updating subscription ID: $id');
      print('DEBUG: Update data: $data');

      final uri = Uri.parse('$baseUrl/subscriptions/$id');

      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );

      print('DEBUG: Update response status: ${response.statusCode}');
      print('DEBUG: Update response body: ${response.body}');

      // Check if response is JSON
      final contentType = response.headers['content-type']?.toLowerCase() ?? '';
      if (!contentType.contains('application/json')) {
        print('DEBUG: Non-JSON response detected');
        print('DEBUG: Full response: ${response.body}');
        throw Exception('Server returned non-JSON response: ${response.body.substring(0, 100)}');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body);
        print('DEBUG: Update successful: $responseData');
      } else {
        throw Exception('Failed to update subscription. Status: ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('ERROR in updateSubscription: $e');
      throw Exception('Failed to update subscription: $e');
    }
  }

  Future<void> deleteSubscription(int id) async {
    try {
      final uri = Uri.parse('$baseUrl/subscriptions/$id');

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      final response = await http.delete(uri, headers: headers).timeout(timeout);

      if (response.statusCode == 200) {
        print('DEBUG: Successfully deleted subscription $id');
      } else {
        throw Exception('Failed to delete subscription. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting subscription: $e');
      throw Exception('Failed to delete subscription: $e');
    }
  }

  Future<List<School>> getSchoolList() async {
    try {
      final uri = Uri.parse('$baseUrl/schools');
      final response = await http.get(uri, headers: headers).timeout(timeout);
      await _handleResponse(response);

      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => School.fromJson(item)).toList();
    } catch (e) {
      print('Error fetching schools: $e');
      throw Exception('Failed to load schools: $e');
    }
  }
}