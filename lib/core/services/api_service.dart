import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../data/models/web/school/school_model.dart';
import '../../data/models/web/subscription/subscription_model.dart';
import '../../data/models/web/subscription/billing_plan_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost/track_x/api';
  static const Duration timeout = Duration(seconds: 10);

  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<School>> getSchools({
    String? search,
    String? status,
    String? subscription,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/schools.php');
      final response = await client.post(uri, body: {
        'action': 'get_schools',
        'search': search ?? '',
        'status': status ?? 'all',
        'subscription': subscription ?? 'all',
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final List<dynamic> schoolsData = data['schools'];
          return schoolsData.map((json) => School.fromJson(json)).toList();
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load schools: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<SchoolStats> getSchoolStats() async {
    try {
      final uri = Uri.parse('$baseUrl/schools.php');
      final response = await client.post(uri, body: {
        'action': 'get_stats',
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return SchoolStats.fromJson(data['stats']);
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<School> addSchool(School school) async {
    try {
      final uri = Uri.parse('$baseUrl/schools.php');
      final response = await client.post(uri, body: {
        'action': 'add_school',
        'school': jsonEncode(school.toJson()),
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return School.fromJson(data['school']);
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to add school: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> updateSchool(School school) async {
    try {
      final uri = Uri.parse('$baseUrl/schools.php');
      final response = await client.post(uri, body: {
        'action': 'update_school',
        'school': jsonEncode(school.toJson()),
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        throw Exception('Failed to update school: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> deleteSchool(String schoolId) async {
    try {
      final uri = Uri.parse('$baseUrl/schools.php');
      final response = await client.post(uri, body: {
        'action': 'delete_school',
        'school_id': schoolId,
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        throw Exception('Failed to delete school: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<BillingPlan>> getBillingPlans() async {
    try {
      final uri = Uri.parse('$baseUrl/billing_plans.php');
      final response = await client.post(uri, body: {
        'actions': 'get_plans',
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final List<dynamic> plansData = data['plans'];
          return plansData.map((json) => BillingPlan.fromJson(json)).toList();
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load billing plans: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<BillingPlan> addBillingPlan(BillingPlan plan) async {
    try {
      final uri = Uri.parse('$baseUrl/billing_plans.php');
      final response = await client.post(uri, body: {
        'action': 'add_plan',
        'plan': jsonEncode(plan.toJson()),
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return BillingPlan.fromJson(data['plan']);
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to add billing plan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> updateBillingPlan(BillingPlan plan) async {
    try {
      final uri = Uri.parse('$baseUrl/billing_plans.php');
      final response = await client.post(uri, body: {
        'action': 'updated_plan',
        'plan': jsonEncode(plan.toJson()),
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        throw Exception('Failed to update billing plan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> deleteBillingPlan(String planId) async {
    try {
      final uri = Uri.parse('$baseUrl/billing_plans.php');
      final response = await client.post(uri, body: {
        'action': 'delete_plan',
        'plan_id': planId,
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        throw Exception('Failed to delete billing plan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<Subscription>> getSubscriptions({
    String? search,
    String? status,
    String? plan,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/subscriptions.php');
      final response = await client.post(uri, body: {
        'action': 'get_subscriptions',
        'search': search ?? '',
        'status': status ?? 'all',
        'plan': plan ?? 'all',
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final List<dynamic> subscriptionsData = data['subscriptions'];
          return subscriptionsData.map((json) => Subscription.fromJson(json)).toList();
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load subscriptions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<SubscriptionStats> getSubscriptionStats() async {
    try {
      final uri = Uri.parse('$baseUrl/subscriptions.php');
      final response = await client.post(uri, body: {
        'action': 'get_stats',
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return SubscriptionStats.fromJson(data['stats']);
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to load subscription stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> updateSubscriptionAutoRenew(String subscriptionId, bool autoRenew) async {
    try {
      final uri = Uri.parse('$baseUrl/subscriptions.php');
      final response = await client.post(uri, body: {
        'action': 'update_auto_renew',
        'subscription_id': subscriptionId,
        'auto_renew': autoRenew ? '1' : '0',
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        throw Exception('Failed to update auto-renew: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> cancelSubscription(String subscriptionId) async {
    try {
      final uri = Uri.parse('$baseUrl/subscriptions.php');
      final response = await client.post(uri, body: {
        'action': 'cancel_subscription',
        'subscription_id': subscriptionId,
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        throw Exception('Failed to cancel subscription: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> renewSubscription(String subscriptionId, int months) async {
    try {
      final uri = Uri.parse('$baseUrl/subscriptions.php');
      final response = await client.post(uri, body: {
        'action': 'renew_subscription',
        'subscription_id': subscriptionId,
        'months': months.toString(),
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        throw Exception('Failed to renew subscription: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<bool> changeSubscriptionPlan(String subscriptionId, String newPlan) async {
    try {
      final uri = Uri.parse('$baseUrl/subscriptions.php');
      final response = await client.post(uri, body: {
        'action': 'change_plan',
        'subscription_id': subscriptionId,
        'new_plan': newPlan,
      }).timeout(timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        throw Exception('Failed to change subscription plan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }


  void dispose() {
    client.close();
  }
}