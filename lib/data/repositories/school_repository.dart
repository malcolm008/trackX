import 'dart:async';
import '../models/school/school_model.dart';
import 'base_repository.dart';
import '../../core/enums/app_enums.dart';

abstract class SchoolRepository extends BaseRepository<SchoolModel> {
  Future<void> updateSubscription(String schoolId, String subscriptionId);
  Future<List<SchoolModel>> getActiveSchools();
  Future<List<SchoolModel>> getSchoolsNearby(double lat, double lng, double radius);
  Future<List<SchoolModel>> searchSchools(String query);
  Future<void> updateSchoolSettings(String schoolId, Map<String, dynamic> settings);
  Future<Map<String, dynamic>> getSchoolStats(String schoolId);
}

class MockSchoolRepository implements SchoolRepository {
  final List<SchoolModel> _schools = [];

  @override
  Future<List<SchoolModel>> getAll({Map<String, dynamic>? filters}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var filteredSchools = List<SchoolModel>.from(_schools);

    if (filters != null) {
      if (filters.containsKey('isActive')) {
        final isActive = filters['isActive'] as bool;
        filteredSchools = filteredSchools.where((school) => school.isActive == isActive).toList();
      }

      if (filters.containsKey('type')) {
        final type = filters['type'] as SchoolType;
        filteredSchools = filteredSchools.where((school) => school.type == type).toList();
      }

      if (filters.containsKey('city')) {
        final city = filters['city'] as String;
        filteredSchools = filteredSchools.where((school) => school.city == city).toList();
      }
    }

    return filteredSchools;
  }

  @override
  Future<SchoolModel?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _schools.firstWhere((school) => school.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<SchoolModel> create(SchoolModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _schools.add(item);
    return item;
  }

  @override
  Future<SchoolModel> update(String id, SchoolModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _schools.indexWhere((school) => school.id == id);
    if (index != -1) {
      _schools[index] = item;
      return item;
    }

    throw RepositoryFailure('School not found');
  }

  @override
  Future<bool> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final initialLength = _schools.length;
    _schools.removeWhere((school) => school.id == id);

    return _schools.length < initialLength;
  }

  @override
  Stream<List<SchoolModel>> watchAll({Map<String, dynamic>? filters}) {
    return Stream.value(_schools);
  }

  @override
  Stream<SchoolModel?> watchById(String id) {
    try {
      final school = _schools.firstWhere((school) => school.id == id);
      return Stream.value(school);
    } catch (e) {
      return Stream.value(null);
    }
  }

  @override
  Future<void> updateSubscription(String schoolId, String subscriptionId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final school = _schools.firstWhere((school) => school.id == schoolId);
    if (school != null) {
      final index = _schools.indexOf(school);
      _schools[index] = school.copyWith(subscriptionId: subscriptionId);
    }
  }

  @override
  Future<List<SchoolModel>> getActiveSchools() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _schools.where((school) => school.isActive).toList();
  }

  @override
  Future<List<SchoolModel>> getSchoolsNearby(double lat, double lng, double radius) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock implementation - in real app, this would calculate distance
    return _schools.where((school) =>
    school.latitude != null &&
        school.longitude != null
    ).toList();
  }

  @override
  Future<List<SchoolModel>> searchSchools(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _schools.where((school) =>
    school.name.toLowerCase().contains(query.toLowerCase()) ||
        school.address.toLowerCase().contains(query.toLowerCase()) ||
        (school.city?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
        (school.principalName?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  @override
  Future<void> updateSchoolSettings(String schoolId, Map<String, dynamic> settings) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final school = _schools.firstWhere((school) => school.id == schoolId);
    if (school != null) {
      final index = _schools.indexOf(school);
      _schools[index] = school.copyWith(settings: settings);
    }
  }

  @override
  Future<Map<String, dynamic>> getSchoolStats(String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return {
      'totalStudents': 450,
      'totalBuses': 12,
      'totalRoutes': 8,
      'activeRoutes': 6,
      'attendanceToday': 98.5,
      'pendingReports': 3,
      'subscriptionStatus': 'active',
      'subscriptionExpiry': DateTime.now().add(const Duration(days: 30)),
    };
  }
}