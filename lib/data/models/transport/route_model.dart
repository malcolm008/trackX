import 'package:flutter/foundation.dart';
import '../../../core/enums/app_enums.dart';
import '../base_model.dart';
import 'package:flutter/material.dart';

class RouteStop {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final String address;
  final List<String> studentIds;
  final DateTime? estimatedArrival;
  final DateTime? actualArrival;
  final bool isCompleted;
  final int orderIndex;
  final String? notes;
  final double? radius;

  RouteStop({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.address,
    this.studentIds = const [],
    this.estimatedArrival,
    this.actualArrival,
    this.isCompleted = false,
    this.orderIndex = 0,
    this.notes,
    this.radius,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lat': lat,
      'lng': lng,
      'address': address,
      'studentIds': studentIds,
      'estimatedArrival': estimatedArrival?.toIso8601String(),
      'actualArrival': actualArrival?.toIso8601String(),
      'isCompleted': isCompleted,
      'orderIndex': orderIndex,
      'notes': notes,
      'radius': radius,
    };
  }

  factory RouteStop.fromJson(Map<String, dynamic> json) {
    return RouteStop(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      lat: json['lat']?.toDouble() ?? 0.0,
      lng: json['lng']?.toDouble() ?? 0.0,
      address: json['address'] ?? '',
      studentIds: List<String>.from(json['studentIds'] ?? []),
      estimatedArrival: json['estimatedArrival'] != null ? DateTime.parse(json['estimatedArrival']) : null,
      actualArrival: json['actualArrival'] != null ? DateTime.parse(json['actualArrival']) : null,
      isCompleted: json['isCompleted'] ?? false,
      orderIndex: json['orderIndex'] ?? 0,
      notes: json['notes'],
      radius: json['radius']?.toDouble(),
    );
  }

  RouteStop copyWith({
    String? id,
    String? name,
    double? lat,
    double? lng,
    String? address,
    List<String>? studentIds,
    DateTime? estimatedArrival,
    DateTime? actualArrival,
    bool? isCompleted,
    int? orderIndex,
    String? notes,
    double? radius,
  }) {
    return RouteStop(
      id: id ?? this.id,
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      address: address ?? this.address,
      studentIds: studentIds ?? this.studentIds,
      estimatedArrival: estimatedArrival ?? this.estimatedArrival,
      actualArrival: actualArrival ?? this.actualArrival,
      isCompleted: isCompleted ?? this.isCompleted,
      orderIndex: orderIndex ?? this.orderIndex,
      notes: notes ?? this.notes,
      radius: radius ?? this.radius,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RouteStop &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              name == other.name &&
              lat == other.lat &&
              lng == other.lng &&
              address == other.address &&
              listEquals(studentIds, other.studentIds) &&
              estimatedArrival == other.estimatedArrival &&
              actualArrival == other.actualArrival &&
              isCompleted == other.isCompleted &&
              orderIndex == other.orderIndex &&
              notes == other.notes &&
              radius == other.radius;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      address.hashCode ^
      studentIds.hashCode ^
      estimatedArrival.hashCode ^
      actualArrival.hashCode ^
      isCompleted.hashCode ^
      orderIndex.hashCode ^
      notes.hashCode ^
      radius.hashCode;

  @override
  String toString() {
    return 'RouteStop{id: $id, name: $name, order: $orderIndex, completed: $isCompleted}';
  }
}

class RouteModel extends BaseModel {
  final String schoolId;
  final String name;
  final String busId;
  final String? driverId;
  final List<RouteStop> stops;
  final double totalDistance;
  final int estimatedTime;
  final RouteStatus status;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final int studentCount;
  final List<String> studentIds;
  final DateTime? lastRunDate;
  final double? averageSpeed;
  final int totalRuns;
  final String? colorCode;
  final List<String> weekDays;
  final bool isActiveToday;

  RouteModel({
    required String id,
    required this.schoolId,
    required this.name,
    required this.busId,
    this.driverId,
    this.stops = const [],
    this.totalDistance = 0.0,
    this.estimatedTime = 0,
    this.status = RouteStatus.inactive,
    this.startTime,
    this.endTime,
    this.studentCount = 0,
    this.studentIds = const [],
    this.lastRunDate,
    this.averageSpeed,
    this.totalRuns = 0,
    this.colorCode,
    this.weekDays = const [],
    this.isActiveToday = true,
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
      'schoolId': schoolId,
      'name': name,
      'busId': busId,
      'driverId': driverId,
      'stops': stops.map((stop) => stop.toJson()).toList(),
      'totalDistance': totalDistance,
      'estimatedTime': estimatedTime,
      'status': status.name,
      'startTime': startTime != null ? '${startTime!.hour}:${startTime!.minute}' : null,
      'endTime': endTime != null ? '${endTime!.hour}:${endTime!.minute}' : null,
      'studentCount': studentCount,
      'studentIds': studentIds,
      'lastRunDate': lastRunDate?.toIso8601String(),
      'averageSpeed': averageSpeed,
      'totalRuns': totalRuns,
      'colorCode': colorCode,
      'weekDays': weekDays,
      'isActiveToday': isActiveToday,
    };
  }

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    TimeOfDay? parseTime(String? timeString) {
      if (timeString == null) return null;
      final parts = timeString.split(':');
      if (parts.length != 2) return null;
      return TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }

    return RouteModel(
      id: json['id'] ?? '',
      schoolId: json['schoolId'] ?? '',
      name: json['name'] ?? '',
      busId: json['busId'] ?? '',
      driverId: json['driverId'],
      stops: (json['stops'] as List<dynamic>?)
          ?.map((stop) => RouteStop.fromJson(stop))
          .toList() ??
          [],
      totalDistance: json['totalDistance']?.toDouble() ?? 0.0,
      estimatedTime: json['estimatedTime'] ?? 0,
      status: RouteStatus.values.firstWhere(
            (e) => e.name == (json['status'] ?? 'inactive'),
        orElse: () => RouteStatus.inactive,
      ),
      startTime: parseTime(json['startTime']),
      endTime: parseTime(json['endTime']),
      studentCount: json['studentCount'] ?? 0,
      studentIds: List<String>.from(json['studentIds'] ?? []),
      lastRunDate: json['lastRunDate'] != null ? DateTime.parse(json['lastRunDate']) : null,
      averageSpeed: json['averageSpeed']?.toDouble(),
      totalRuns: json['totalRuns'] ?? 0,
      colorCode: json['colorCode'],
      weekDays: List<String>.from(json['weekDays'] ?? []),
      isActiveToday: json['isActiveToday'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  RouteModel copyWith({
    String? id,
    String? schoolId,
    String? name,
    String? busId,
    String? driverId,
    List<RouteStop>? stops,
    double? totalDistance,
    int? estimatedTime,
    RouteStatus? status,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    int? studentCount,
    List<String>? studentIds,
    DateTime? lastRunDate,
    double? averageSpeed,
    int? totalRuns,
    String? colorCode,
    List<String>? weekDays,
    bool? isActiveToday,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isDeleted,
  }) {
    return RouteModel(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      name: name ?? this.name,
      busId: busId ?? this.busId,
      driverId: driverId ?? this.driverId,
      stops: stops ?? this.stops,
      totalDistance: totalDistance ?? this.totalDistance,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      studentCount: studentCount ?? this.studentCount,
      studentIds: studentIds ?? this.studentIds,
      lastRunDate: lastRunDate ?? this.lastRunDate,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      totalRuns: totalRuns ?? this.totalRuns,
      colorCode: colorCode ?? this.colorCode,
      weekDays: weekDays ?? this.weekDays,
      isActiveToday: isActiveToday ?? this.isActiveToday,
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
              other is RouteModel &&
              runtimeType == other.runtimeType &&
              schoolId == other.schoolId &&
              name == other.name &&
              busId == other.busId &&
              driverId == other.driverId &&
              listEquals(stops, other.stops) &&
              totalDistance == other.totalDistance &&
              estimatedTime == other.estimatedTime &&
              status == other.status &&
              startTime == other.startTime &&
              endTime == other.endTime &&
              studentCount == other.studentCount &&
              listEquals(studentIds, other.studentIds) &&
              lastRunDate == other.lastRunDate &&
              averageSpeed == other.averageSpeed &&
              totalRuns == other.totalRuns &&
              colorCode == other.colorCode &&
              listEquals(weekDays, other.weekDays) &&
              isActiveToday == other.isActiveToday;

  @override
  int get hashCode =>
      super.hashCode ^
      schoolId.hashCode ^
      name.hashCode ^
      busId.hashCode ^
      driverId.hashCode ^
      stops.hashCode ^
      totalDistance.hashCode ^
      estimatedTime.hashCode ^
      status.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      studentCount.hashCode ^
      studentIds.hashCode ^
      lastRunDate.hashCode ^
      averageSpeed.hashCode ^
      totalRuns.hashCode ^
      colorCode.hashCode ^
      weekDays.hashCode ^
      isActiveToday.hashCode;

  @override
  String toString() {
    return 'RouteModel{id: $id, name: $name, status: $status, stops: ${stops.length}, studentCount: $studentCount}';
  }
}