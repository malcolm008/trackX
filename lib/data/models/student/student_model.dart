import 'package:flutter/foundation.dart';
import '../../../core/enums/app_enums.dart';
import 'package:flutter/material.dart';
import '../base_model.dart';

class StudentModel extends BaseModel {
  final String schoolId;
  final String name;
  final int grade;
  final String section;
  final String? parentId;
  final String? busId;
  final String? routeId;
  final String? pickupStopId;
  final String? dropoffStopId;
  final String? profileImage;
  final String? emergencyContact;
  final String? medicalNotes;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? bloodGroup;
  final List<String> allergies;
  final List<String> medications;
  final bool requiresSpecialAssistance;
  final String? specialInstructions;
  final String? studentIdNumber;
  final String? classTeacher;
  final Map<String, dynamic>? additionalInfo;

  StudentModel({
    required String id,
    required this.schoolId,
    required this.name,
    required this.grade,
    required this.section,
    this.parentId,
    this.busId,
    this.routeId,
    this.pickupStopId,
    this.dropoffStopId,
    this.profileImage,
    this.emergencyContact,
    this.medicalNotes,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.allergies = const [],
    this.medications = const [],
    this.requiresSpecialAssistance = false,
    this.specialInstructions,
    this.studentIdNumber,
    this.classTeacher,
    this.additionalInfo,
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
      'grade': grade,
      'section': section,
      'parentId': parentId,
      'busId': busId,
      'routeId': routeId,
      'pickupStopId': pickupStopId,
      'dropoffStopId': dropoffStopId,
      'profileImage': profileImage,
      'emergencyContact': emergencyContact,
      'medicalNotes': medicalNotes,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'bloodGroup': bloodGroup,
      'allergies': allergies,
      'medications': medications,
      'requiresSpecialAssistance': requiresSpecialAssistance,
      'specialInstructions': specialInstructions,
      'studentIdNumber': studentIdNumber,
      'classTeacher': classTeacher,
      'additionalInfo': additionalInfo,
    };
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] ?? '',
      schoolId: json['schoolId'] ?? '',
      name: json['name'] ?? '',
      grade: json['grade'] ?? 0,
      section: json['section'] ?? '',
      parentId: json['parentId'],
      busId: json['busId'],
      routeId: json['routeId'],
      pickupStopId: json['pickupStopId'],
      dropoffStopId: json['dropoffStopId'],
      profileImage: json['profileImage'],
      emergencyContact: json['emergencyContact'],
      medicalNotes: json['medicalNotes'],
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
      gender: json['gender'],
      bloodGroup: json['bloodGroup'],
      allergies: List<String>.from(json['allergies'] ?? []),
      medications: List<String>.from(json['medications'] ?? []),
      requiresSpecialAssistance: json['requiresSpecialAssistance'] ?? false,
      specialInstructions: json['specialInstructions'],
      studentIdNumber: json['studentIdNumber'],
      classTeacher: json['classTeacher'],
      additionalInfo: json['additionalInfo'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  StudentModel copyWith({
    String? id,
    String? schoolId,
    String? name,
    int? grade,
    String? section,
    String? parentId,
    String? busId,
    String? routeId,
    String? pickupStopId,
    String? dropoffStopId,
    String? profileImage,
    String? emergencyContact,
    String? medicalNotes,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodGroup,
    List<String>? allergies,
    List<String>? medications,
    bool? requiresSpecialAssistance,
    String? specialInstructions,
    String? studentIdNumber,
    String? classTeacher,
    Map<String, dynamic>? additionalInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isDeleted,
  }) {
    return StudentModel(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      section: section ?? this.section,
      parentId: parentId ?? this.parentId,
      busId: busId ?? this.busId,
      routeId: routeId ?? this.routeId,
      pickupStopId: pickupStopId ?? this.pickupStopId,
      dropoffStopId: dropoffStopId ?? this.dropoffStopId,
      profileImage: profileImage ?? this.profileImage,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      medicalNotes: medicalNotes ?? this.medicalNotes,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      requiresSpecialAssistance: requiresSpecialAssistance ?? this.requiresSpecialAssistance,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      studentIdNumber: studentIdNumber ?? this.studentIdNumber,
      classTeacher: classTeacher ?? this.classTeacher,
      additionalInfo: additionalInfo ?? this.additionalInfo,
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
              other is StudentModel &&
              runtimeType == other.runtimeType &&
              schoolId == other.schoolId &&
              name == other.name &&
              grade == other.grade &&
              section == other.section &&
              parentId == other.parentId &&
              busId == other.busId &&
              routeId == other.routeId &&
              pickupStopId == other.pickupStopId &&
              dropoffStopId == other.dropoffStopId &&
              profileImage == other.profileImage &&
              emergencyContact == other.emergencyContact &&
              medicalNotes == other.medicalNotes &&
              dateOfBirth == other.dateOfBirth &&
              gender == other.gender &&
              bloodGroup == other.bloodGroup &&
              listEquals(allergies, other.allergies) &&
              listEquals(medications, other.medications) &&
              requiresSpecialAssistance == other.requiresSpecialAssistance &&
              specialInstructions == other.specialInstructions &&
              studentIdNumber == other.studentIdNumber &&
              classTeacher == other.classTeacher &&
              mapEquals(additionalInfo, other.additionalInfo);

  @override
  int get hashCode =>
      super.hashCode ^
      schoolId.hashCode ^
      name.hashCode ^
      grade.hashCode ^
      section.hashCode ^
      parentId.hashCode ^
      busId.hashCode ^
      routeId.hashCode ^
      pickupStopId.hashCode ^
      dropoffStopId.hashCode ^
      profileImage.hashCode ^
      emergencyContact.hashCode ^
      medicalNotes.hashCode ^
      dateOfBirth.hashCode ^
      gender.hashCode ^
      bloodGroup.hashCode ^
      allergies.hashCode ^
      medications.hashCode ^
      requiresSpecialAssistance.hashCode ^
      specialInstructions.hashCode ^
      studentIdNumber.hashCode ^
      classTeacher.hashCode ^
      additionalInfo.hashCode;

  @override
  String toString() {
    return 'StudentModel{id: $id, name: $name, grade: $grade, section: $section, parentId: $parentId}';
  }
}

class AttendanceModel extends BaseModel {
  final String studentId;
  final String routeId;
  final DateTime date;
  final AttendanceStatus status;
  final TimeOfDay? pickupTime;
  final TimeOfDay? dropoffTime;
  final String? markedBy;
  final String? notes;
  final double? pickupLat;
  final double? pickupLng;
  final double? dropoffLat;
  final double? dropoffLng;
  final String? busId;
  final String? driverId;
  final bool isVerified;
  final String? verificationMethod;
  final DateTime? verificationTime;

  AttendanceModel({
    required String id,
    required this.studentId,
    required this.routeId,
    required this.date,
    required this.status,
    this.pickupTime,
    this.dropoffTime,
    this.markedBy,
    this.notes,
    this.pickupLat,
    this.pickupLng,
    this.dropoffLat,
    this.dropoffLng,
    this.busId,
    this.driverId,
    this.isVerified = false,
    this.verificationMethod,
    this.verificationTime,
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
      'studentId': studentId,
      'routeId': routeId,
      'date': date.toIso8601String(),
      'status': status.name,
      'pickupTime': pickupTime != null ? '${pickupTime!.hour}:${pickupTime!.minute}' : null,
      'dropoffTime': dropoffTime != null ? '${dropoffTime!.hour}:${dropoffTime!.minute}' : null,
      'markedBy': markedBy,
      'notes': notes,
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'dropoffLat': dropoffLat,
      'dropoffLng': dropoffLng,
      'busId': busId,
      'driverId': driverId,
      'isVerified': isVerified,
      'verificationMethod': verificationMethod,
      'verificationTime': verificationTime?.toIso8601String(),
    };
  }

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    TimeOfDay? parseTime(String? timeString) {
      if (timeString == null) return null;
      final parts = timeString.split(':');
      if (parts.length != 2) return null;
      return TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }

    return AttendanceModel(
      id: json['id'] ?? '',
      studentId: json['studentId'] ?? '',
      routeId: json['routeId'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      status: AttendanceStatus.values.firstWhere(
            (e) => e.name == (json['status'] ?? 'absent'),
        orElse: () => AttendanceStatus.absent,
      ),
      pickupTime: parseTime(json['pickupTime']),
      dropoffTime: parseTime(json['dropoffTime']),
      markedBy: json['markedBy'],
      notes: json['notes'],
      pickupLat: json['pickupLat']?.toDouble(),
      pickupLng: json['pickupLng']?.toDouble(),
      dropoffLat: json['dropoffLat']?.toDouble(),
      dropoffLng: json['dropoffLng']?.toDouble(),
      busId: json['busId'],
      driverId: json['driverId'],
      isVerified: json['isVerified'] ?? false,
      verificationMethod: json['verificationMethod'],
      verificationTime: json['verificationTime'] != null ? DateTime.parse(json['verificationTime']) : null,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  AttendanceModel copyWith({
    String? id,
    String? studentId,
    String? routeId,
    DateTime? date,
    AttendanceStatus? status,
    TimeOfDay? pickupTime,
    TimeOfDay? dropoffTime,
    String? markedBy,
    String? notes,
    double? pickupLat,
    double? pickupLng,
    double? dropoffLat,
    double? dropoffLng,
    String? busId,
    String? driverId,
    bool? isVerified,
    String? verificationMethod,
    DateTime? verificationTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isDeleted,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      routeId: routeId ?? this.routeId,
      date: date ?? this.date,
      status: status ?? this.status,
      pickupTime: pickupTime ?? this.pickupTime,
      dropoffTime: dropoffTime ?? this.dropoffTime,
      markedBy: markedBy ?? this.markedBy,
      notes: notes ?? this.notes,
      pickupLat: pickupLat ?? this.pickupLat,
      pickupLng: pickupLng ?? this.pickupLng,
      dropoffLat: dropoffLat ?? this.dropoffLat,
      dropoffLng: dropoffLng ?? this.dropoffLng,
      busId: busId ?? this.busId,
      driverId: driverId ?? this.driverId,
      isVerified: isVerified ?? this.isVerified,
      verificationMethod: verificationMethod ?? this.verificationMethod,
      verificationTime: verificationTime ?? this.verificationTime,
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
              other is AttendanceModel &&
              runtimeType == other.runtimeType &&
              studentId == other.studentId &&
              routeId == other.routeId &&
              date == other.date &&
              status == other.status &&
              pickupTime == other.pickupTime &&
              dropoffTime == other.dropoffTime &&
              markedBy == other.markedBy &&
              notes == other.notes &&
              pickupLat == other.pickupLat &&
              pickupLng == other.pickupLng &&
              dropoffLat == other.dropoffLat &&
              dropoffLng == other.dropoffLng &&
              busId == other.busId &&
              driverId == other.driverId &&
              isVerified == other.isVerified &&
              verificationMethod == other.verificationMethod &&
              verificationTime == other.verificationTime;

  @override
  int get hashCode =>
      super.hashCode ^
      studentId.hashCode ^
      routeId.hashCode ^
      date.hashCode ^
      status.hashCode ^
      pickupTime.hashCode ^
      dropoffTime.hashCode ^
      markedBy.hashCode ^
      notes.hashCode ^
      pickupLat.hashCode ^
      pickupLng.hashCode ^
      dropoffLat.hashCode ^
      dropoffLng.hashCode ^
      busId.hashCode ^
      driverId.hashCode ^
      isVerified.hashCode ^
      verificationMethod.hashCode ^
      verificationTime.hashCode;

  @override
  String toString() {
    return 'AttendanceModel{id: $id, studentId: $studentId, date: $date, status: $status}';
  }
}

class AttendanceSummary {
  final DateTime date;
  final int totalStudents;
  final int presentCount;
  final int absentCount;
  final int lateCount;
  final int excusedCount;
  final List<String> presentStudentIds;
  final List<String> absentStudentIds;
  final List<String> lateStudentIds;
  final double attendancePercentage;

  AttendanceSummary({
    required this.date,
    this.totalStudents = 0,
    this.presentCount = 0,
    this.absentCount = 0,
    this.lateCount = 0,
    this.excusedCount = 0,
    this.presentStudentIds = const [],
    this.absentStudentIds = const [],
    this.lateStudentIds = const [],
  }) : attendancePercentage = totalStudents > 0
      ? ((presentCount + lateCount) / totalStudents) * 100
      : 0;

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalStudents': totalStudents,
      'presentCount': presentCount,
      'absentCount': absentCount,
      'lateCount': lateCount,
      'excusedCount': excusedCount,
      'presentStudentIds': presentStudentIds,
      'absentStudentIds': absentStudentIds,
      'lateStudentIds': lateStudentIds,
      'attendancePercentage': attendancePercentage,
    };
  }

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      totalStudents: json['totalStudents'] ?? 0,
      presentCount: json['presentCount'] ?? 0,
      absentCount: json['absentCount'] ?? 0,
      lateCount: json['lateCount'] ?? 0,
      excusedCount: json['excusedCount'] ?? 0,
      presentStudentIds: List<String>.from(json['presentStudentIds'] ?? []),
      absentStudentIds: List<String>.from(json['absentStudentIds'] ?? []),
      lateStudentIds: List<String>.from(json['lateStudentIds'] ?? []),
    );
  }

  AttendanceSummary copyWith({
    DateTime? date,
    int? totalStudents,
    int? presentCount,
    int? absentCount,
    int? lateCount,
    int? excusedCount,
    List<String>? presentStudentIds,
    List<String>? absentStudentIds,
    List<String>? lateStudentIds,
  }) {
    return AttendanceSummary(
      date: date ?? this.date,
      totalStudents: totalStudents ?? this.totalStudents,
      presentCount: presentCount ?? this.presentCount,
      absentCount: absentCount ?? this.absentCount,
      lateCount: lateCount ?? this.lateCount,
      excusedCount: excusedCount ?? this.excusedCount,
      presentStudentIds: presentStudentIds ?? this.presentStudentIds,
      absentStudentIds: absentStudentIds ?? this.absentStudentIds,
      lateStudentIds: lateStudentIds ?? this.lateStudentIds,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AttendanceSummary &&
              runtimeType == other.runtimeType &&
              date == other.date &&
              totalStudents == other.totalStudents &&
              presentCount == other.presentCount &&
              absentCount == other.absentCount &&
              lateCount == other.lateCount &&
              excusedCount == other.excusedCount &&
              listEquals(presentStudentIds, other.presentStudentIds) &&
              listEquals(absentStudentIds, other.absentStudentIds) &&
              listEquals(lateStudentIds, other.lateStudentIds) &&
              attendancePercentage == other.attendancePercentage;

  @override
  int get hashCode =>
      date.hashCode ^
      totalStudents.hashCode ^
      presentCount.hashCode ^
      absentCount.hashCode ^
      lateCount.hashCode ^
      excusedCount.hashCode ^
      presentStudentIds.hashCode ^
      absentStudentIds.hashCode ^
      lateStudentIds.hashCode ^
      attendancePercentage.hashCode;

  @override
  String toString() {
    return 'AttendanceSummary{date: $date, present: $presentCount, absent: $absentCount, percentage: ${attendancePercentage.toStringAsFixed(1)}%}';
  }
}