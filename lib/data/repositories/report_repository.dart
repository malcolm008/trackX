import 'dart:async';
import '../models/report/report_model.dart';
import 'base_repository.dart';
import '../../core/enums/app_enums.dart';

abstract class ReportRepository extends BaseRepository<ReportModel> {
  Future<List<ReportModel>> getReportsByDriver(String driverId);
  Future<List<ReportModel>> getReportsByType(ReportType type);
  Future<List<ReportModel>> getPendingReports();
  Future<void> updateReportStatus(String reportId, ReportStatus status, String resolvedBy);
  Future<List<ReportModel>> getReportsBySchool(String schoolId);
  Future<List<ReportModel>> searchReports(String query);
  Future<void> assignReport(String reportId, String assignedTo);
  Future<List<ReportModel>> getReportsByDateRange(DateTime start, DateTime end);
}

class MockReportRepository implements ReportRepository {
  final List<ReportModel> _reports = [];

  @override
  Future<List<ReportModel>> getAll({Map<String, dynamic>? filters}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    var filteredReports = List<ReportModel>.from(_reports);

    if (filters != null) {
      if (filters.containsKey('driverId')) {
        final driverId = filters['driverId'] as String;
        filteredReports = filteredReports.where((report) => report.driverId == driverId).toList();
      }

      if (filters.containsKey('type')) {
        final type = filters['type'] as ReportType;
        filteredReports = filteredReports.where((report) => report.type == type).toList();
      }

      if (filters.containsKey('status')) {
        final status = filters['status'] as ReportStatus;
        filteredReports = filteredReports.where((report) => report.status == status).toList();
      }

      if (filters.containsKey('busId')) {
        final busId = filters['busId'] as String;
        filteredReports = filteredReports.where((report) => report.busId == busId).toList();
      }

      if (filters.containsKey('routeId')) {
        final routeId = filters['routeId'] as String;
        filteredReports = filteredReports.where((report) => report.routeId == routeId).toList();
      }

      if (filters.containsKey('severity')) {
        final severity = filters['severity'] as int;
        filteredReports = filteredReports.where((report) => report.severity == severity).toList();
      }

      if (filters.containsKey('requiresImmediateAction')) {
        final requiresAction = filters['requiresImmediateAction'] as bool;
        filteredReports = filteredReports.where((report) => report.requiresImmediateAction == requiresAction).toList();
      }
    }

    return filteredReports;
  }

  @override
  Future<ReportModel?> getById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _reports.firstWhere((report) => report.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ReportModel> create(ReportModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _reports.add(item);
    return item;
  }

  @override
  Future<ReportModel> update(String id, ReportModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _reports.indexWhere((report) => report.id == id);
    if (index != -1) {
      _reports[index] = item;
      return item;
    }

    throw RepositoryFailure('Report not found');
  }

  @override
  Future<bool> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final initialLength = _reports.length;
    _reports.removeWhere((report) => report.id == id);

    return _reports.length < initialLength;
  }

  @override
  Stream<List<ReportModel>> watchAll({Map<String, dynamic>? filters}) {
    return Stream.value(_reports);
  }

  @override
  Stream<ReportModel?> watchById(String id) {
    try {
      final report = _reports.firstWhere((report) => report.id == id);
      return Stream.value(report);
    } catch (e) {
      return Stream.value(null);
    }
  }

  @override
  Future<List<ReportModel>> getReportsByDriver(String driverId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _reports.where((report) => report.driverId == driverId).toList();
  }

  @override
  Future<List<ReportModel>> getReportsByType(ReportType type) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _reports.where((report) => report.type == type).toList();
  }

  @override
  Future<List<ReportModel>> getPendingReports() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _reports.where((report) => report.status == ReportStatus.pending).toList();
  }

  @override
  Future<void> updateReportStatus(String reportId, ReportStatus status, String resolvedBy) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final report = _reports.firstWhere((report) => report.id == reportId);
    if (report != null) {
      final index = _reports.indexOf(report);
      _reports[index] = report.copyWith(
        status: status,
        resolvedBy: resolvedBy,
        resolvedAt: status == ReportStatus.resolved ? DateTime.now() : null,
      );
    }
  }

  @override
  Future<List<ReportModel>> getReportsBySchool(String schoolId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _reports;
  }

  @override
  Future<List<ReportModel>> searchReports(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _reports.where((report) =>
    report.title.toLowerCase().contains(query.toLowerCase()) ||
        report.description.toLowerCase().contains(query.toLowerCase()) ||
        (report.location?.toLowerCase().contains(query.toLowerCase()) ?? false)
    ).toList();
  }

  @override
  Future<void> assignReport(String reportId, String assignedTo) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final report = _reports.firstWhere((report) => report.id == reportId);
    if (report != null) {
      final index = _reports.indexOf(report);
      _reports[index] = report.copyWith(assignedTo: assignedTo);
    }
  }

  @override
  Future<List<ReportModel>> getReportsByDateRange(DateTime start, DateTime end) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _reports.where((report) =>
    report.createdAt.isAfter(start.subtract(const Duration(days: 1))) &&
        report.createdAt.isBefore(end.add(const Duration(days: 1)))
    ).toList();
  }
}