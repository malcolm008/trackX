import 'dart:convert';
import 'package:bustracker_007/data/models/web/subscription_plan.dart';
import 'package:bustracker_007/data/models/web/school_subscription.dart';
import 'package:bustracker_007/core/services/api_service.dart';

class SubscriptionRepository {
  final ApiService _apiService = ApiService();

  Future<List<SubscriptionPlan>> getPlans() async {
    try {
      final response = await _apiService.getPlans();
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SubscriptionPlan.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching plans: $e');
      rethrow;
    }
  }

  Future<List<SchoolSubscription>> getSubscriptions({
    String? status,
    String? schoolId,
  }) async {
    try {
      final Map<String, dynamic> filters = {};
      if (status != null && status != 'all') filters['status'] = status;
      if (schoolId != null) filters['school_id'] = schoolId;

      final response = await _apiService.getSubscriptions(filters: filters);
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SchoolSubscription.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching subscriptions: $e');
      rethrow;
    }
  }

  Future<SchoolSubscription> createSubscription(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.createSubscription(data);
      final responseData = json.decode(response.body);
      return SchoolSubscription.fromJson(responseData);
    } catch (e) {
      print('Error creating subscription: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSubscriptionStats() async {
    try {
      final subscriptions = await getSubscriptions();

      final totalActive = subscriptions.where((s) => s.status == 'active').length;
      final totalExpiring = subscriptions.where((s) => s.status == 'expiring').length;
      final totalTrial = subscriptions.where((s) => s.status == 'trial').length;

      final totalRevenue = subscriptions
          .where((s) => s.status == 'active')
          .fold(0.0, (sum, subscription) => sum + subscription.amount);

      // Calculate renewal rate (example calculation)
      final renewals = subscriptions.where((s) => s.autoRenew).length;
      final renewalRate = subscriptions.isNotEmpty
          ? (renewals / subscriptions.length) * 100
          : 0;

      return {
        'total_revenue': totalRevenue,
        'active_subscriptions': totalActive,
        'trial_users': totalTrial,
        'renewal_rate': renewalRate,
        'expiring_soon': totalExpiring,
      };
    } catch (e) {
      print('Error getting subscription stats: $e');
      rethrow;
    }
  }
}