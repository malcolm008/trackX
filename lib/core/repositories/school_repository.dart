import 'dart:convert';
import '../../data/models/web/school.dart';
import '../services/api_service.dart';

class SchoolRepository {
  final ApiService _apiService = ApiService();

  Future<List<School>> getSchools({
    String? status,
    String? subscriptionType,
    String? search,
  }) async {
    try {
      final Map<String, dynamic> filters = {};
      if (status != null && status != 'all') filters['status'] = status;
      if (search != null && search.isNotEmpty) filters['search'] = search;

      final response = await _apiService.getSchools(filters: filters);
      final List<dynamic> data = json.decode(response.body);

      return data.map((json) => School.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching schools: $e');
      rethrow;
    }
  }

  Future<School> getSchoolById(int id) async {
    try {
      final response = await _apiService.getSchool(id);
      final data = json.decode(response.body);
      return School.fromJson(data);
    } catch (e) {
      print('Error fetching school: $e');
      rethrow;
    }
  }

  Future<School> createSchool(School school) async {
    try {
      final response = await _apiService.createSchool(school.toJson());
      final data = json.decode(response.body);
      return School.fromJson(data);
    } catch (e) {
      print('Error creating school: $e');
      rethrow;
    }
  }

  Future<School> updateSchool(int id, School school) async {
    try {
      final response = await _apiService.updateSchool(id, school.toJson());
      final data = json.decode(response.body);
      return School.fromJson(data);
    } catch (e) {
      print('Error updating school: $e');
      rethrow;
    }
  }

  Future<void> deleteSchool(int id) async {
    try {
      await _apiService.deleteSchool(id);
    } catch (e) {
      print('Error deleting school: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getSchoolStats() async {
    try {
      final schools = await getSchools();

      final totalSchools = schools.length;
      final activeSchools = schools.where((s) => s.status == 'active').length;
      final expiringSchools = schools.where((s) => s.status == 'expiring').length;
      final totalStudents = schools.fold(0, (sum, school) => sum + school.totalStudents);
      final totalBuses = schools.fold(0, (sum, school) => sum + school.totalBuses);

      // Calculate new schools this month
      final now = DateTime.now();
      final thisMonthStart = DateTime(now.year, now.month, 1);
      final newThisMonth = schools.where((s) =>
          s.createdAt.isAfter(thisMonthStart)).length;

      return {
        'total_schools': totalSchools,
        'active_schools': activeSchools,
        'expiring_schools': expiringSchools,
        'new_this_month': newThisMonth,
        'total_students': totalStudents,
        'total_buses': totalBuses,
        'revenue_per_month': 12450.0, // This should come from subscriptions
      };
    } catch (e) {
      print('Error getting school stats: $e');
      rethrow;
    }
  }
}