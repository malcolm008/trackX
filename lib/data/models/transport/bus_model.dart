import 'package:flutter/foundation.dart';
import '../../../core/enums/app_enums.dart';
import '../base_model.dart';

class BusModel extends BaseModel {
  final String schoolId;
  final String plateNumber;
  final String model;
  final int capacity;
  final int year;
  final String? driverId;
  final String? currentRouteId;
  final BusStatus status;
  final String? color;
  final String? imageUrl;
  final DateTime? lastServiceDate;
  final DateTime? nextServiceDate;
  final double? currentLat;
  final double? currentLng;
  final double? averageSpeed;
  final double? fuelLevel;
  final int totalTrips;
  final double totalDistance;
  final String? registrationNumber;
  final String? insuranceNumber;
  final DateTime? insuranceExpiry;
  final List<String> features;

  BusModel({
    required String id,
    required this.schoolId,
    required this.plateNumber,
    required this.model,
    required this.capacity,
    required this.year,
    this.driverId,
    this.currentRouteId,
    this.status = BusStatus.inactive,
    this.color,
    this.imageUrl,
    this.lastServiceDate,
    this.nextServiceDate,
    this.currentLat,
    this.currentLng,
    this.averageSpeed,
    this.fuelLevel,
    this.totalTrips = 0,
    this.totalDistance = 0.0,
    this.registrationNumber,
    this.insuranceNumber,
    this.insuranceExpiry,
    this.features = const [],
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
      'plateNumber': plateNumber,
      'model': model,
      'capacity': capacity,
      'year': year,
      'driverId': driverId,
      'currentRouteId': currentRouteId,
      'status': status.name,
      'color': color,
      'imageUrl': imageUrl,
      'lastServiceDate': lastServiceDate?.toIso8601String(),
      'nextServiceDate': nextServiceDate?.toIso8601String(),
      'currentLat': currentLat,
      'currentLng': currentLng,
      'averageSpeed': averageSpeed,
      'fuelLevel': fuelLevel,
      'totalTrips': totalTrips,
      'totalDistance': totalDistance,
      'registrationNumber': registrationNumber,
      'insuranceNumber': insuranceNumber,
      'insuranceExpiry': insuranceExpiry?.toIso8601String(),
      'features': features,
    };
  }

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      id: json['id'] ?? '',
      schoolId: json['schoolId'] ?? '',
      plateNumber: json['plateNumber'] ?? '',
      model: json['model'] ?? '',
      capacity: json['capacity'] ?? 0,
      year: json['year'] ?? DateTime.now().year,
      driverId: json['driverId'],
      currentRouteId: json['currentRouteId'],
      status: BusStatus.values.firstWhere(
            (e) => e.name == (json['status'] ?? 'inactive'),
        orElse: () => BusStatus.inactive,
      ),
      color: json['color'],
      imageUrl: json['imageUrl'],
      lastServiceDate: json['lastServiceDate'] != null ? DateTime.parse(json['lastServiceDate']) : null,
      nextServiceDate: json['nextServiceDate'] != null ? DateTime.parse(json['nextServiceDate']) : null,
      currentLat: json['currentLat']?.toDouble(),
      currentLng: json['currentLng']?.toDouble(),
      averageSpeed: json['averageSpeed']?.toDouble(),
      fuelLevel: json['fuelLevel']?.toDouble(),
      totalTrips: json['totalTrips'] ?? 0,
      totalDistance: json['totalDistance']?.toDouble() ?? 0.0,
      registrationNumber: json['registrationNumber'],
      insuranceNumber: json['insuranceNumber'],
      insuranceExpiry: json['insuranceExpiry'] != null ? DateTime.parse(json['insuranceExpiry']) : null,
      features: List<String>.from(json['features'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  BusModel copyWith({
    String? id,
    String? schoolId,
    String? plateNumber,
    String? model,
    int? capacity,
    int? year,
    String? driverId,
    String? currentRouteId,
    BusStatus? status,
    String? color,
    String? imageUrl,
    DateTime? lastServiceDate,
    DateTime? nextServiceDate,
    double? currentLat,
    double? currentLng,
    double? averageSpeed,
    double? fuelLevel,
    int? totalTrips,
    double? totalDistance,
    String? registrationNumber,
    String? insuranceNumber,
    DateTime? insuranceExpiry,
    List<String>? features,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isDeleted,
  }) {
    return BusModel(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      plateNumber: plateNumber ?? this.plateNumber,
      model: model ?? this.model,
      capacity: capacity ?? this.capacity,
      year: year ?? this.year,
      driverId: driverId ?? this.driverId,
      currentRouteId: currentRouteId ?? this.currentRouteId,
      status: status ?? this.status,
      color: color ?? this.color,
      imageUrl: imageUrl ?? this.imageUrl,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      nextServiceDate: nextServiceDate ?? this.nextServiceDate,
      currentLat: currentLat ?? this.currentLat,
      currentLng: currentLng ?? this.currentLng,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      fuelLevel: fuelLevel ?? this.fuelLevel,
      totalTrips: totalTrips ?? this.totalTrips,
      totalDistance: totalDistance ?? this.totalDistance,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      insuranceExpiry: insuranceExpiry ?? this.insuranceExpiry,
      features: features ?? this.features,
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
              other is BusModel &&
              runtimeType == other.runtimeType &&
              schoolId == other.schoolId &&
              plateNumber == other.plateNumber &&
              model == other.model &&
              capacity == other.capacity &&
              year == other.year &&
              driverId == other.driverId &&
              currentRouteId == other.currentRouteId &&
              status == other.status &&
              color == other.color &&
              imageUrl == other.imageUrl &&
              lastServiceDate == other.lastServiceDate &&
              nextServiceDate == other.nextServiceDate &&
              currentLat == other.currentLat &&
              currentLng == other.currentLng &&
              averageSpeed == other.averageSpeed &&
              fuelLevel == other.fuelLevel &&
              totalTrips == other.totalTrips &&
              totalDistance == other.totalDistance &&
              registrationNumber == other.registrationNumber &&
              insuranceNumber == other.insuranceNumber &&
              insuranceExpiry == other.insuranceExpiry &&
              listEquals(features, other.features);

  @override
  int get hashCode =>
      super.hashCode ^
      schoolId.hashCode ^
      plateNumber.hashCode ^
      model.hashCode ^
      capacity.hashCode ^
      year.hashCode ^
      driverId.hashCode ^
      currentRouteId.hashCode ^
      status.hashCode ^
      color.hashCode ^
      imageUrl.hashCode ^
      lastServiceDate.hashCode ^
      nextServiceDate.hashCode ^
      currentLat.hashCode ^
      currentLng.hashCode ^
      averageSpeed.hashCode ^
      fuelLevel.hashCode ^
      totalTrips.hashCode ^
      totalDistance.hashCode ^
      registrationNumber.hashCode ^
      insuranceNumber.hashCode ^
      insuranceExpiry.hashCode ^
      features.hashCode;

  @override
  String toString() {
    return 'BusModel{id: $id, plateNumber: $plateNumber, model: $model, status: $status, driverId: $driverId}';
  }
}

class DriverModel extends BaseModel {
  final String userId;
  final String name;
  final String phone;
  final String? email;
  final String? licenseNumber;
  final DateTime? licenseExpiry;
  final String? profileImage;
  final String? assignedBusId;
  final double rating;
  final int totalTrips;
  final bool isAvailable;
  final int yearsOfExperience;
  final String? emergencyContact;
  final List<String> certifications;
  final DateTime? hireDate;
  final double? currentLat;
  final double? currentLng;

  DriverModel({
    required String id,
    required this.userId,
    required this.name,
    required this.phone,
    this.email,
    this.licenseNumber,
    this.licenseExpiry,
    this.profileImage,
    this.assignedBusId,
    this.rating = 0.0,
    this.totalTrips = 0,
    this.isAvailable = true,
    this.yearsOfExperience = 0,
    this.emergencyContact,
    this.certifications = const [],
    this.hireDate,
    this.currentLat,
    this.currentLng,
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
      'userId': userId,
      'name': name,
      'phone': phone,
      'email': email,
      'licenseNumber': licenseNumber,
      'licenseExpiry': licenseExpiry?.toIso8601String(),
      'profileImage': profileImage,
      'assignedBusId': assignedBusId,
      'rating': rating,
      'totalTrips': totalTrips,
      'isAvailable': isAvailable,
      'yearsOfExperience': yearsOfExperience,
      'emergencyContact': emergencyContact,
      'certifications': certifications,
      'hireDate': hireDate?.toIso8601String(),
      'currentLat': currentLat,
      'currentLng': currentLng,
    };
  }

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      licenseNumber: json['licenseNumber'],
      licenseExpiry: json['licenseExpiry'] != null ? DateTime.parse(json['licenseExpiry']) : null,
      profileImage: json['profileImage'],
      assignedBusId: json['assignedBusId'],
      rating: json['rating']?.toDouble() ?? 0.0,
      totalTrips: json['totalTrips'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      yearsOfExperience: json['yearsOfExperience'] ?? 0,
      emergencyContact: json['emergencyContact'],
      certifications: List<String>.from(json['certifications'] ?? []),
      hireDate: json['hireDate'] != null ? DateTime.parse(json['hireDate']) : null,
      currentLat: json['currentLat']?.toDouble(),
      currentLng: json['currentLng']?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  DriverModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    String? email,
    String? licenseNumber,
    DateTime? licenseExpiry,
    String? profileImage,
    String? assignedBusId,
    double? rating,
    int? totalTrips,
    bool? isAvailable,
    int? yearsOfExperience,
    String? emergencyContact,
    List<String>? certifications,
    DateTime? hireDate,
    double? currentLat,
    double? currentLng,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isDeleted,
  }) {
    return DriverModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      licenseExpiry: licenseExpiry ?? this.licenseExpiry,
      profileImage: profileImage ?? this.profileImage,
      assignedBusId: assignedBusId ?? this.assignedBusId,
      rating: rating ?? this.rating,
      totalTrips: totalTrips ?? this.totalTrips,
      isAvailable: isAvailable ?? this.isAvailable,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      certifications: certifications ?? this.certifications,
      hireDate: hireDate ?? this.hireDate,
      currentLat: currentLat ?? this.currentLat,
      currentLng: currentLng ?? this.currentLng,
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
              other is DriverModel &&
              runtimeType == other.runtimeType &&
              userId == other.userId &&
              name == other.name &&
              phone == other.phone &&
              email == other.email &&
              licenseNumber == other.licenseNumber &&
              licenseExpiry == other.licenseExpiry &&
              profileImage == other.profileImage &&
              assignedBusId == other.assignedBusId &&
              rating == other.rating &&
              totalTrips == other.totalTrips &&
              isAvailable == other.isAvailable &&
              yearsOfExperience == other.yearsOfExperience &&
              emergencyContact == other.emergencyContact &&
              listEquals(certifications, other.certifications) &&
              hireDate == other.hireDate &&
              currentLat == other.currentLat &&
              currentLng == other.currentLng;

  @override
  int get hashCode =>
      super.hashCode ^
      userId.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      email.hashCode ^
      licenseNumber.hashCode ^
      licenseExpiry.hashCode ^
      profileImage.hashCode ^
      assignedBusId.hashCode ^
      rating.hashCode ^
      totalTrips.hashCode ^
      isAvailable.hashCode ^
      yearsOfExperience.hashCode ^
      emergencyContact.hashCode ^
      certifications.hashCode ^
      hireDate.hashCode ^
      currentLat.hashCode ^
      currentLng.hashCode;

  @override
  String toString() {
    return 'DriverModel{id: $id, name: $name, phone: $phone, assignedBusId: $assignedBusId, isAvailable: $isAvailable}';
  }
}