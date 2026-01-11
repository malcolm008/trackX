import 'package:flutter/foundation.dart';
import '../base_model.dart';

class LocationModel extends BaseModel {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? speed;
  final double? heading;
  final DateTime timestamp;
  final String? deviceId;
  final String? busId;
  final String? routeId;
  final String? driverId;
  final bool isMoving;
  final double? altitude;
  final String? provider;
  final Map<String, dynamic>? additionalData;

  LocationModel({
    required String id,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.speed,
    this.heading,
    required this.timestamp,
    this.deviceId,
    this.busId,
    this.routeId,
    this.driverId,
    this.isMoving = false,
    this.altitude,
    this.provider,
    this.additionalData,
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
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'speed': speed,
      'heading': heading,
      'timestamp': timestamp.toIso8601String(),
      'deviceId': deviceId,
      'busId': busId,
      'routeId': routeId,
      'driverId': driverId,
      'isMoving': isMoving,
      'altitude': altitude,
      'provider': provider,
      'additionalData': additionalData,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      accuracy: json['accuracy']?.toDouble(),
      speed: json['speed']?.toDouble(),
      heading: json['heading']?.toDouble(),
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      deviceId: json['deviceId'],
      busId: json['busId'],
      routeId: json['routeId'],
      driverId: json['driverId'],
      isMoving: json['isMoving'] ?? false,
      altitude: json['altitude']?.toDouble(),
      provider: json['provider'],
      additionalData: json['additionalData'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  LocationModel copyWith({
    String? id,
    double? latitude,
    double? longitude,
    double? accuracy,
    double? speed,
    double? heading,
    DateTime? timestamp,
    String? deviceId,
    String? busId,
    String? routeId,
    String? driverId,
    bool? isMoving,
    double? altitude,
    String? provider,
    Map<String, dynamic>? additionalData,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isDeleted,
  }) {
    return LocationModel(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      timestamp: timestamp ?? this.timestamp,
      deviceId: deviceId ?? this.deviceId,
      busId: busId ?? this.busId,
      routeId: routeId ?? this.routeId,
      driverId: driverId ?? this.driverId,
      isMoving: isMoving ?? this.isMoving,
      altitude: altitude ?? this.altitude,
      provider: provider ?? this.provider,
      additionalData: additionalData ?? this.additionalData,
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
              other is LocationModel &&
              runtimeType == other.runtimeType &&
              latitude == other.latitude &&
              longitude == other.longitude &&
              accuracy == other.accuracy &&
              speed == other.speed &&
              heading == other.heading &&
              timestamp == other.timestamp &&
              deviceId == other.deviceId &&
              busId == other.busId &&
              routeId == other.routeId &&
              driverId == other.driverId &&
              isMoving == other.isMoving &&
              altitude == other.altitude &&
              provider == other.provider &&
              mapEquals(additionalData, other.additionalData);

  @override
  int get hashCode =>
      super.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      accuracy.hashCode ^
      speed.hashCode ^
      heading.hashCode ^
      timestamp.hashCode ^
      deviceId.hashCode ^
      busId.hashCode ^
      routeId.hashCode ^
      driverId.hashCode ^
      isMoving.hashCode ^
      altitude.hashCode ^
      provider.hashCode ^
      additionalData.hashCode;

  @override
  String toString() {
    return 'LocationModel{id: $id, lat: $latitude, lng: $longitude, timestamp: $timestamp, busId: $busId}';
  }
}

class GeofenceModel extends BaseModel {
  final String name;
  final double latitude;
  final double longitude;
  final double radius;
  final String? stopId;
  final String? schoolId;
  final String? busId;
  final String? routeId;
  final GeofenceType type;
  final bool notifyOnEntry;
  final bool notifyOnExit;
  final String? notificationMessage;
  final Map<String, dynamic>? metadata;

  GeofenceModel({
    required String id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
    this.stopId,
    this.schoolId,
    this.busId,
    this.routeId,
    this.type = GeofenceType.pickup,
    this.notifyOnEntry = true,
    this.notifyOnExit = false,
    this.notificationMessage,
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
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'stopId': stopId,
      'schoolId': schoolId,
      'busId': busId,
      'routeId': routeId,
      'type': type.name,
      'notifyOnEntry': notifyOnEntry,
      'notifyOnExit': notifyOnExit,
      'notificationMessage': notificationMessage,
      'metadata': metadata,
    };
  }

  factory GeofenceModel.fromJson(Map<String, dynamic> json) {
    return GeofenceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      radius: json['radius']?.toDouble() ?? 100.0,
      stopId: json['stopId'],
      schoolId: json['schoolId'],
      busId: json['busId'],
      routeId: json['routeId'],
      type: GeofenceType.values.firstWhere(
            (e) => e.name == (json['type'] ?? 'pickup'),
        orElse: () => GeofenceType.pickup,
      ),
      notifyOnEntry: json['notifyOnEntry'] ?? true,
      notifyOnExit: json['notifyOnExit'] ?? false,
      notificationMessage: json['notificationMessage'],
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  GeofenceModel copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    double? radius,
    String? stopId,
    String? schoolId,
    String? busId,
    String? routeId,
    GeofenceType? type,
    bool? notifyOnEntry,
    bool? notifyOnExit,
    String? notificationMessage,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isDeleted,
  }) {
    return GeofenceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      stopId: stopId ?? this.stopId,
      schoolId: schoolId ?? this.schoolId,
      busId: busId ?? this.busId,
      routeId: routeId ?? this.routeId,
      type: type ?? this.type,
      notifyOnEntry: notifyOnEntry ?? this.notifyOnEntry,
      notifyOnExit: notifyOnExit ?? this.notifyOnExit,
      notificationMessage: notificationMessage ?? this.notificationMessage,
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
              other is GeofenceModel &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              latitude == other.latitude &&
              longitude == other.longitude &&
              radius == other.radius &&
              stopId == other.stopId &&
              schoolId == other.schoolId &&
              busId == other.busId &&
              routeId == other.routeId &&
              type == other.type &&
              notifyOnEntry == other.notifyOnEntry &&
              notifyOnExit == other.notifyOnExit &&
              notificationMessage == other.notificationMessage &&
              mapEquals(metadata, other.metadata);

  @override
  int get hashCode =>
      super.hashCode ^
      name.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      radius.hashCode ^
      stopId.hashCode ^
      schoolId.hashCode ^
      busId.hashCode ^
      routeId.hashCode ^
      type.hashCode ^
      notifyOnEntry.hashCode ^
      notifyOnExit.hashCode ^
      notificationMessage.hashCode ^
      metadata.hashCode;

  @override
  String toString() {
    return 'GeofenceModel{id: $id, name: $name, type: $type, radius: $radius}';
  }
}

enum GeofenceType {
  pickup,
  dropoff,
  school,
  home,
  warning,
  restricted,
  custom
}