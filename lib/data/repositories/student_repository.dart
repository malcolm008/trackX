import 'dart:async';
import '../models/student/student_model.dart';
import 'base_repository.dart';

abstract class StudentRepository extends BaseRepository<StudentModel> {
  Future<List<StudentModel>> getStudentsByParent(String parentId);
  Future<List<StudentModel>> getStudentsByRoute(String routeId);
  Future<List<StudentModel>> getStudentsByBus(String busId);
  Future<void> assignToRoute(String studentId, String routeId);
  Future<void> removeFromRoute(String studentId);
  Future<void> updatePickupLocation(String studentId, String stopId);
  Future<List<StudentModel>> searchStudents(String query);
  Future<void> assignToBus(String studentId, String busId);
  Future<void> updateStudentStatus(String studentId, bool isActive);
  Future<List<StudentModel>> getStudentsByGrade(int grade, String section);
}

class MockStudentRepository implements StudentRepository {
  final List<StudentModel> _students = [];

  @override
  Future<List<StudentModel>> getAll({Map<String, dynamic>? filters}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var filteredStudents = List<StudentModel>.from(_students);

    if (filters != null) {
      if (filters.containsKey('schoolId')) {
        final schoolId = filters['schoolId'] as String;
        filteredStudents = filteredStudents.where((student) => student.schoolId == schoolId).toList();
      }

      if (filters.containsKey('parentId')) {
        final parentId = filters['parentId'] as String;
        filteredStudents = filteredStudents.where((student) => student.parentId == parentId).toList();
      }

      if (filters.containsKey('routeId')) {
        final routeId = filters['routeId'] as String;
        filteredStudents = filteredStudents.where((student) => student.routeId == routeId).toList();
      }

      if (filters.containsKey('busId')) {
        final busId = filters['busId'] as String;
        filteredStudents = filteredStudents.where((student) => student.busId == busId).toList();
      }

      if (filters.containsKey('isActive')) {
        final isActive = filters['isActive'] as bool;
        filteredStudents = filteredStudents.where((student) => student.isActive == isActive).toList();
      }
    }

    return filteredStudents;
  }

  @override
  Future<StudentModel?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _students.firstWhere((student) => student.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<StudentModel> create(StudentModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _students.add(item);
    return item;
  }

  @override
  Future<StudentModel> update(String id, StudentModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _students.indexWhere((student) => student.id == id);
    if (index != -1) {
      _students[index] = item;
      return item;
    }

    throw RepositoryFailure('Student not found');
  }

  @override
  Future<bool> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final initialLength = _students.length;
    _students.removeWhere((student) => student.id == id);

    return _students.length < initialLength;
  }

  @override
  Stream<List<StudentModel>> watchAll({Map<String, dynamic>? filters}) {
    return Stream.value(_students);
  }

  @override
  Stream<StudentModel?> watchById(String id) {
    try {
      final student = _students.firstWhere((student) => student.id == id);
      return Stream.value(student);
    } catch (e) {
      return Stream.value(null);
    }
  }

  @override
  Future<List<StudentModel>> getStudentsByParent(String parentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _students.where((student) => student.parentId == parentId).toList();
  }

  @override
  Future<List<StudentModel>> getStudentsByRoute(String routeId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _students.where((student) => student.routeId == routeId).toList();
  }

  @override
  Future<List<StudentModel>> getStudentsByBus(String busId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _students.where((student) => student.busId == busId).toList();
  }

  @override
  Future<void> assignToRoute(String studentId, String routeId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final student = _students.firstWhere((student) => student.id == studentId);
    if (student != null) {
      final index = _students.indexOf(student);
      _students[index] = student.copyWith(routeId: routeId);
    }
  }

  @override
  Future<void> removeFromRoute(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final student = _students.firstWhere((student) => student.id == studentId);
    if (student != null) {
      final index = _students.indexOf(student);
      _students[index] = student.copyWith(routeId: null);
    }
  }

  @override
  Future<void> updatePickupLocation(String studentId, String stopId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final student = _students.firstWhere((student) => student.id == studentId);
    if (student != null) {
      final index = _students.indexOf(student);
      _students[index] = student.copyWith(pickupStopId: stopId);
    }
  }

  @override
  Future<List<StudentModel>> searchStudents(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _students.where((student) =>
    student.name.toLowerCase().contains(query.toLowerCase()) ||
        (student.studentIdNumber?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
        (student.classTeacher?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  @override
  Future<void> assignToBus(String studentId, String busId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final student = _students.firstWhere((student) => student.id == studentId);
    if (student != null) {
      final index = _students.indexOf(student);
      _students[index] = student.copyWith(busId: busId);
    }
  }

  @override
  Future<void> updateStudentStatus(String studentId, bool isActive) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final student = _students.firstWhere((student) => student.id == studentId);
    if (student != null) {
      final index = _students.indexOf(student);
      _students[index] = student.copyWith(isActive: isActive);
    }
  }

  @override
  Future<List<StudentModel>> getStudentsByGrade(int grade, String section) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _students.where((student) =>
    student.grade == grade && student.section == section
    ).toList();
  }
}