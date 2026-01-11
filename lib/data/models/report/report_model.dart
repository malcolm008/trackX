import 'package:flutter/foundation.dart';
import '../../../core/enums/app_enums.dart';
import '../base_model.dart';

class ReportModel extends BaseModel {
  final String driverId;
  final ReportType type;
  final String title;
  final String description;
  final ReportStatus status;
  final String? busId;
  final String? routeId;
  final List<String> imageUrls;
  final String? resolvedBy;
  final String? resolutionNotes;
  final DateTime? resolvedAt;
  final String? location;
  final double? latitude;
  final double? longitude;
  final int severity; // 1-5 scale
  final bool requiresImmediateAction;
  final List<String> affectedStudentIds;
  final String? assignedTo;
  final DateTime? deadline;
  final Map<String, dynamic>? metadata;

  ReportModel({
    required String id,
    required this.driverId,
    required this.type,
    required this.title,
    required this.description,
    this.status = ReportStatus.pending,
    this.busId,
    this.routeId,
    this.imageUrls = const [],
    this.resolvedBy,
    this.resolutionNotes,
    this.resolvedAt,
    this.location,
    this.latitude,
    this.longitude,
    this.severity = 1,
    this.requiresImmediateAction = false,
    this.affectedStudentIds = const [],
    this.assignedTo,
    this.deadline,
    this.metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool isActive = true,
    bool isDeleted = false,
  }) : super(
    id: id,
    createdAt: createdAt ?? DateTime.now(),
    updatedAt: updatedAt,
    isActive: isActive,
    isDeleted: isDeleted,
  );

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'driverId': driverId,
      'type': type.name,
      'title': title,
      'description': description,
      'status': status.name,
      'busId': busId,
      'routeId': routeId,
      'imageUrls': imageUrls,
      'resolvedBy': resolvedBy,
      'resolutionNotes': resolutionNotes,
      'resolvedAt': resolvedAt?.toIso8601String(),
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'severity': severity,
      'requiresImmediateAction': requiresImmediateAction,
      'affectedStudentIds': affectedStudentIds,
      'assignedTo': assignedTo,
      'deadline': deadline?.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? '',
      driverId: json['driverId'] ?? '',
      type: ReportType.values.firstWhere(
            (e) => e.name == (json['type'] ?? 'other'),
        orElse: () => ReportType.other,
      ),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: ReportStatus.values.firstWhere(
            (e) => e.name == (json['status'] ?? 'pending'),
        orElse: () => ReportStatus.pending,
      ),
      busId: json['busId'],
      routeId: json['routeId'],
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      resolvedBy: json['resolvedBy'],
      resolutionNotes: json['resolutionNotes'],
      resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt']) : null,
      location: json['location'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      severity: json['severity'] ?? 1,
      requiresImmediateAction: json['requiresImmediateAction'] ?? false,
      affectedStudentIds: List<String>.from(json['affectedStudentIds'] ?? []),
      assignedTo: json['assignedTo'],
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  ReportModel copyWith({
    String? id,
    String? driverId,
    ReportType? type,
    String? title,
    String? description,
    ReportStatus? status,
    String? busId,
    String? routeId,
    List<String>? imageUrls,
    String? resolvedBy,
    String? resolutionNotes,
    DateTime? resolvedAt,
    String? location,
    double? latitude,
    double? longitude,
    int? severity,
    bool? requiresImmediateAction,
    List<String>? affectedStudentIds,
    String? assignedTo,
    DateTime? deadline,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isDeleted,
  }) {
    return ReportModel(
      id: id ?? this.id,
      driverId: driverId ?? this.driverId,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      busId: busId ?? this.busId,
      routeId: routeId ?? this.routeId,
      imageUrls: imageUrls ?? this.imageUrls,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      severity: severity ?? this.severity,
      requiresImmediateAction: requiresImmediateAction ?? this.requiresImmediateAction,
      affectedStudentIds: affectedStudentIds ?? this.affectedStudentIds,
      assignedTo: assignedTo ?? this.assignedTo,
      deadline: deadline ?? this.deadline,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is ReportModel &&
              runtimeType == other.runtimeType &&
              driverId == other.driverId &&
              type == other.type &&
              title == other.title &&
              description == other.description &&
              status == other.status &&
              busId == other.busId &&
              routeId == other.routeId &&
              listEquals(imageUrls, other.imageUrls) &&
              resolvedBy == other.resolvedBy &&
              resolutionNotes == other.resolutionNotes &&
              resolvedAt == other.resolvedAt &&
              location == other.location &&
              latitude == other.latitude &&
              longitude == other.longitude &&
              severity == other.severity &&
              requiresImmediateAction == other.requiresImmediateAction &&
              listEquals(affectedStudentIds, other.affectedStudentIds) &&
              assignedTo == other.assignedTo &&
              deadline == other.deadline &&
              mapEquals(metadata, other.metadata);

  @override
  int get hashCode =>
      super.hashCode ^
      driverId.hashCode ^
      type.hashCode ^
      title.hashCode ^
      description.hashCode ^
      status.hashCode ^
      busId.hashCode ^
      routeId.hashCode ^
      imageUrls.hashCode ^
      resolvedBy.hashCode ^
      resolutionNotes.hashCode ^
      resolvedAt.hashCode ^
      location.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      severity.hashCode ^
      requiresImmediateAction.hashCode ^
      affectedStudentIds.hashCode ^
      assignedTo.hashCode ^
      deadline.hashCode ^
      metadata.hashCode;

  @override
  String toString() {
    return 'ReportModel{id: $id, title: $title, type: $type, status: $status, severity: $severity}';
  }
}

class AnalyticsModel extends BaseModel {
  final DateTime date;
  final int totalTrips;
  final double totalDistance;
  final int onTimeTrips;
  final int delayedTrips;
  final double averageSpeed;
  final double fuelConsumed;
  final int maintenanceAlerts;
  final int totalStudents;
  final int attendancePercentage;
  final int driverRating;
  final int parentSatisfaction;
  final Map<String, int> routePerformance;
  final Map<String, dynamic> additionalMetrics;

  AnalyticsModel({
    required String id,
    required this.date,
    this.totalTrips = 0,
    this.totalDistance = 0.0,
    this.onTimeTrips = 0,
    this.delayedTrips = 0,
    this.averageSpeed = 0.0,
    this.fuelConsumed = 0.0,
    this.maintenanceAlerts = 0,
    this.totalStudents = 0,
    this.attendancePercentage = 0,
    this.driverRating = 0,
    this.parentSatisfaction = 0,
    this.routePerformance = const {},
    this.additionalMetrics = const {},
    DateTime? createdAt,
    DateTime? updatedAt,
    bool isActive = true,
    bool isDeleted = false,
  }) : super(
    id: id,
    createdAt: createdAt ?? DateTime.now(),
    updatedAt: updatedAt,
    isActive: isActive,
    isDeleted: isDeleted,
  );

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'date': date.toIso8601String(),
      'totalTrips': totalTrips,
      'totalDistance': totalDistance,
      'onTimeTrips': onTimeTrips,
      'delayedTrips': delayedTrips,
      'averageSpeed': averageSpeed,
      'fuelConsumed': fuelConsumed,
      'maintenanceAlerts': maintenanceAlerts,
      'totalStudents': totalStudents,
      'attendancePercentage': attendancePercentage,
      'driverRating': driverRating,
      'parentSatisfaction': parentSatisfaction,
      'routePerformance': routePerformance,
      'additionalMetrics': additionalMetrics,
    };
  }

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      totalTrips: json['totalTrips'] ?? 0,
      totalDistance: json['totalDistance']?.toDouble() ?? 0.0,
      onTimeTrips: json['onTimeTrips'] ?? 0,
      delayedTrips: json['delayedTrips'] ?? 0,
      averageSpeed: json['averageSpeed']?.toDouble() ?? 0.0,
      fuelConsumed: json['fuelConsumed']?.toDouble() ?? 0.0,
      maintenanceAlerts: json['maintenanceAlerts'] ?? 0,
      totalStudents: json['totalStudents'] ?? 0,
      attendancePercentage: json['attendancePercentage'] ?? 0,
      driverRating: json['driverRating'] ?? 0,
      parentSatisfaction: json['parentSatisfaction'] ?? 0,
      routePerformance: Map<String, int>.from(json['routePerformance'] ?? {}),
      additionalMetrics: Map<String, dynamic>.from(json['additionalMetrics'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  AnalyticsModel copyWith({
    String? id,
    DateTime? date,
    int? totalTrips,
    double? totalDistance,
    int? onTimeTrips,
    int? delayedTrips,
    double? averageSpeed,
    double? fuelConsumed,
    int? maintenanceAlerts,
    int? totalStudents,
    int? attendancePercentage,
    int? driverRating,
    int? parentSatisfaction,
    Map<String, int>? routePerformance,
    Map<String, dynamic>? additionalMetrics,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isDeleted,
  }) {
    return AnalyticsModel(
      id: id ?? this.id,
      date: date ?? this.date,
      totalTrips: totalTrips ?? this.totalTrips,
      totalDistance: totalDistance ?? this.totalDistance,
      onTimeTrips: onTimeTrips ?? this.onTimeTrips,
      delayedTrips: delayedTrips ?? this.delayedTrips,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      fuelConsumed: fuelConsumed ?? this.fuelConsumed,
      maintenanceAlerts: maintenanceAlerts ?? this.maintenanceAlerts,
      totalStudents: totalStudents ?? this.totalStudents,
      attendancePercentage: attendancePercentage ?? this.attendancePercentage,
      driverRating: driverRating ?? this.driverRating,
      parentSatisfaction: parentSatisfaction ?? this.parentSatisfaction,
      routePerformance: routePerformance ?? this.routePerformance,
      additionalMetrics: additionalMetrics ?? this.additionalMetrics,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is AnalyticsModel &&
              runtimeType == other.runtimeType &&
              date == other.date &&
              totalTrips == other.totalTrips &&
              totalDistance == other.totalDistance &&
              onTimeTrips == other.onTimeTrips &&
              delayedTrips == other.delayedTrips &&
              averageSpeed == other.averageSpeed &&
              fuelConsumed == other.fuelConsumed &&
              maintenanceAlerts == other.maintenanceAlerts &&
              totalStudents == other.totalStudents &&
              attendancePercentage == other.attendancePercentage &&
              driverRating == other.driverRating &&
              parentSatisfaction == other.parentSatisfaction &&
              mapEquals(routePerformance, other.routePerformance) &&
              mapEquals(additionalMetrics, other.additionalMetrics);

  @override
  int get hashCode =>
      super.hashCode ^
      date.hashCode ^
      totalTrips.hashCode ^
      totalDistance.hashCode ^
      onTimeTrips.hashCode ^
      delayedTrips.hashCode ^
      averageSpeed.hashCode ^
      fuelConsumed.hashCode ^
      maintenanceAlerts.hashCode ^
      totalStudents.hashCode ^
      attendancePercentage.hashCode ^
      driverRating.hashCode ^
      parentSatisfaction.hashCode ^
      routePerformance.hashCode ^
      additionalMetrics.hashCode;

  @override
  String toString() {
    return 'AnalyticsModel{id: $id, date: $date, totalTrips: $totalTrips, attendance: ${attendancePercentage}%}';
  }
}