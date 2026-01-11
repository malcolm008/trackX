import 'dart:async';
import '../models/student/student_model.dart';
import 'base_repository.dart';
import '../../core/enums/app_enums.dart';

abstract class AttendanceRepository extends BaseRepository<AttendanceModel> {
  Future<List<AttendanceModel>> getAttendanceByDate(DateTime date);
  Future<List<AttendanceModel>> getAttendanceByStudent(String studentId);
  Future<List<AttendanceModel>> getAttendanceByRoute(String routeId, DateTime date);
  Future<AttendanceModel> markAttendance(AttendanceModel attendance);
  Future<AttendanceSummary> getDailySummary(DateTime date, String schoolId);
  Future<Map<DateTime, AttendanceSummary>> getMonthlySummary(DateTime month, String schoolId);
  Future<List<AttendanceModel>> getAttendanceByDateRange(DateTime start, DateTime end);
  Future<void> bulkMarkAttendance(List<AttendanceModel> attendanceList);
  Future<AttendanceModel?> getTodayAttendance(String studentId);
}

class MockAttendanceRepository implements AttendanceRepository {
  final List<AttendanceModel> _attendance = [];

  @override
  Future<List<AttendanceModel>> getAll({Map<String, dynamic>? filters}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var filteredAttendance = List<AttendanceModel>.from(_attendance);

    if (filters != null) {
      if (filters.containsKey('studentId')) {
        final studentId = filters['studentId'] as String;
        filteredAttendance = filteredAttendance.where((att) => att.studentId == studentId).toList();
      }

      if (filters.containsKey('routeId')) {
        final routeId = filters['routeId'] as String;
        filteredAttendance = filteredAttendance.where((att) => att.routeId == routeId).toList();
      }

      if (filters.containsKey('date')) {
        final date = filters['date'] as DateTime;
        filteredAttendance = filteredAttendance.where((att) =>
        att.date.year == date.year &&
            att.date.month == date.month &&
            att.date.day == date.day
        ).toList();
      }

      if (filters.containsKey('status')) {
        final status = filters['status'] as AttendanceStatus;
        filteredAttendance = filteredAttendance.where((att) => att.status == status).toList();
      }
    }

    return filteredAttendance;
  }

  @override
  Future<AttendanceModel?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _attendance.firstWhere((att) => att.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AttendanceModel> create(AttendanceModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _attendance.add(item);
    return item;
  }

  @override
  Future<AttendanceModel> update(String id, AttendanceModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _attendance.indexWhere((att) => att.id == id);
    if (index != -1) {
      _attendance[index] = item;
      return item;
    }

    throw RepositoryFailure('Attendance record not found');
  }

  @override
  Future<bool> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final initialLength = _attendance.length;
    _attendance.removeWhere((att) => att.id == id);

    return _attendance.length < initialLength;
  }

  @override
  Stream<List<AttendanceModel>> watchAll({Map<String, dynamic>? filters}) {
    return Stream.value(_attendance);
  }

  @override
  Stream<AttendanceModel?> watchById(String id) {
    try {
      final attendance = _attendance.firstWhere((att) => att.id == id);
      return Stream.value(attendance);
    } catch (e) {
      return Stream.value(null);
    }
  }

  @override
  Future<List<AttendanceModel>> getAttendanceByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _attendance.where((att) =>
    att.date.year == date.year &&
        att.date.month == date.month &&
        att.date.day == date.day
    ).toList();
  }

  @override
  Future<List<AttendanceModel>> getAttendanceByStudent(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _attendance.where((att) => att.studentId == studentId).toList();
  }

  @override
  Future<List<AttendanceModel>> getAttendanceByRoute(String routeId, DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _attendance.where((att) =>
    att.routeId == routeId &&
        att.date.year == date.year &&
        att.date.month == date.month &&
        att.date.day == date.day
    ).toList();
  }

  @override
  Future<AttendanceModel> markAttendance(AttendanceModel attendance) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Check if attendance already exists for this student and date
    final existingIndex = _attendance.indexWhere((att) =>
    att.studentId == attendance.studentId &&
        att.date.year == attendance.date.year &&
        att.date.month == attendance.date.month &&
        att.date.day == attendance.date.day
    );

    if (existingIndex != -1) {
      _attendance[existingIndex] = attendance;
      return attendance;
    } else {
      _attendance.add(attendance);
      return attendance;
    }
  }

  @override
  Future<AttendanceSummary> getDailySummary(DateTime date, String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final dailyAttendance = await getAttendanceByDate(date);

    return AttendanceSummary(
      date: date,
      totalStudents: dailyAttendance.length,
      presentCount: dailyAttendance.where((att) => att.status == AttendanceStatus.present).length,
      absentCount: dailyAttendance.where((att) => att.status == AttendanceStatus.absent).length,
      lateCount: dailyAttendance.where((att) => att.status == AttendanceStatus.late).length,
      excusedCount: dailyAttendance.where((att) => att.status == AttendanceStatus.excused).length,
      presentStudentIds: dailyAttendance
          .where((att) => att.status == AttendanceStatus.present)
          .map((att) => att.studentId)
          .toList(),
      absentStudentIds: dailyAttendance
          .where((att) => att.status == AttendanceStatus.absent)
          .map((att) => att.studentId)
          .toList(),
      lateStudentIds: dailyAttendance
          .where((att) => att.status == AttendanceStatus.late)
          .map((att) => att.studentId)
          .toList(),
    );
  }

  @override
  Future<Map<DateTime, AttendanceSummary>> getMonthlySummary(DateTime month, String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final Map<DateTime, AttendanceSummary> monthlySummary = {};

    // Generate dummy data for the month
    for (int day = 1; day <= 30; day++) {
      final date = DateTime(month.year, month.month, day);
      monthlySummary[date] = AttendanceSummary(
        date: date,
        totalStudents: 100,
        presentCount: 85 + (day % 10),
        absentCount: 10 - (day % 10),
        lateCount: 5,
        excusedCount: 0,
      );
    }

    return monthlySummary;
  }

  @override
  Future<List<AttendanceModel>> getAttendanceByDateRange(DateTime start, DateTime end) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _attendance.where((att) =>
    att.date.isAfter(start.subtract(const Duration(days: 1))) &&
        att.date.isBefore(end.add(const Duration(days: 1)))
    ).toList();
  }

  @override
  Future<void> bulkMarkAttendance(List<AttendanceModel> attendanceList) async {
    await Future.delayed(const Duration(milliseconds: 500));

    for (final attendance in attendanceList) {
      await markAttendance(attendance);
    }
  }

  @override
  Future<AttendanceModel?> getTodayAttendance(String studentId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final today = DateTime.now();

    try {
      return _attendance.firstWhere((att) =>
      att.studentId == studentId &&
          att.date.year == today.year &&
          att.date.month == today.month &&
          att.date.day == today.day
      );
    } catch (e) {
      return null;
    }
  }
}