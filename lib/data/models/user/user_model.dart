import 'package:flutter/foundation.dart';
import '../../../core/enums/app_enums.dart';
import '../base_model.dart';

class UserModel extends BaseModel {
  final String email;
  final String name;
  final String? phone;
  final UserType type;
  final String? avatarUrl;
  final String? schoolId;
  final String? fcmToken;
  final String? address;
  final DateTime? lastLogin;
  final List<String> permissions;

  UserModel({
    required String id,
    required this.email,
    required this.name,
    required this.type,
    this.phone,
    this.avatarUrl,
    this.schoolId,
    this.fcmToken,
    this.address,
    this.lastLogin,
    this.permissions = const [],
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
      'email': email,
      'name': name,
      'phone': phone,
      'type': type.name,
      'avatarUrl': avatarUrl,
      'schoolId': schoolId,
      'fcmToken': fcmToken,
      'address': address,
      'lastLogin': lastLogin?.toIso8601String(),
      'permissions': permissions,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'],
      type: UserType.values.firstWhere(
            (e) => e.name == (json['type'] ?? 'parent'),
        orElse: () => UserType.parent,
      ),
      avatarUrl: json['avatarUrl'],
      schoolId: json['schoolId'],
      fcmToken: json['fcmToken'],
      address: json['address'],
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      permissions: List<String>.from(json['permissions'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    UserType? type,
    String? avatarUrl,
    String? schoolId,
    String? fcmToken,
    String? address,
    DateTime? lastLogin,
    List<String>? permissions,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isDeleted,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      type: type ?? this.type,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      schoolId: schoolId ?? this.schoolId,
      fcmToken: fcmToken ?? this.fcmToken,
      address: address ?? this.address,
      lastLogin: lastLogin ?? this.lastLogin,
      permissions: permissions ?? this.permissions,
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
              other is UserModel &&
              runtimeType == other.runtimeType &&
              email == other.email &&
              name == other.name &&
              phone == other.phone &&
              type == other.type &&
              avatarUrl == other.avatarUrl &&
              schoolId == other.schoolId &&
              fcmToken == other.fcmToken &&
              address == other.address &&
              lastLogin == other.lastLogin &&
              listEquals(permissions, other.permissions);

  @override
  int get hashCode =>
      super.hashCode ^
      email.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      type.hashCode ^
      avatarUrl.hashCode ^
      schoolId.hashCode ^
      fcmToken.hashCode ^
      address.hashCode ^
      lastLogin.hashCode ^
      permissions.hashCode;

  @override
  String toString() {
    return 'UserModel{id: $id, email: $email, name: $name, type: $type, schoolId: $schoolId, isActive: $isActive}';
  }
}

class ParentModel extends BaseModel {
  final String userId;
  final String name;
  final String phone;
  final String? email;
  final String? address;
  final List<String> studentIds;
  final String? profileImage;
  final bool notificationsEnabled;
  final String? emergencyContact;
  final String? relationship;

  ParentModel({
    required String id,
    required this.userId,
    required this.name,
    required this.phone,
    this.email,
    this.address,
    this.studentIds = const [],
    this.profileImage,
    this.notificationsEnabled = true,
    this.emergencyContact,
    this.relationship,
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
      'address': address,
      'studentIds': studentIds,
      'profileImage': profileImage,
      'notificationsEnabled': notificationsEnabled,
      'emergencyContact': emergencyContact,
      'relationship': relationship,
    };
  }

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      address: json['address'],
      studentIds: List<String>.from(json['studentIds'] ?? []),
      profileImage: json['profileImage'],
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      emergencyContact: json['emergencyContact'],
      relationship: json['relationship'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  ParentModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    String? email,
    String? address,
    List<String>? studentIds,
    String? profileImage,
    bool? notificationsEnabled,
    String? emergencyContact,
    String? relationship,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isDeleted,
  }) {
    return ParentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      studentIds: studentIds ?? this.studentIds,
      profileImage: profileImage ?? this.profileImage,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      relationship: relationship ?? this.relationship,
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
              other is ParentModel &&
              runtimeType == other.runtimeType &&
              userId == other.userId &&
              name == other.name &&
              phone == other.phone &&
              email == other.email &&
              address == other.address &&
              listEquals(studentIds, other.studentIds) &&
              profileImage == other.profileImage &&
              notificationsEnabled == other.notificationsEnabled &&
              emergencyContact == other.emergencyContact &&
              relationship == other.relationship;

  @override
  int get hashCode =>
      super.hashCode ^
      userId.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      email.hashCode ^
      address.hashCode ^
      studentIds.hashCode ^
      profileImage.hashCode ^
      notificationsEnabled.hashCode ^
      emergencyContact.hashCode ^
      relationship.hashCode;

  @override
  String toString() {
    return 'ParentModel{id: $id, name: $name, phone: $phone, studentCount: ${studentIds.length}}';
  }
}