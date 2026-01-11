import 'package:flutter/foundation.dart';
import '../../../core/enums/app_enums.dart';
import 'package:flutter/material.dart';
import '../base_model.dart';

class SchoolModel extends BaseModel {
  final String name;
  final String address;
  final String? email;
  final String? phone;
  final String? logoUrl;
  final String? subscriptionId;
  final int studentCount;
  final int busCount;
  final int teacherCount;
  final DateTime? subscriptionExpiry;
  final String? website;
  final String? principalName;
  final String? principalPhone;
  final String? principalEmail;
  final SchoolType type;
  final String? timezone;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final double? latitude;
  final double? longitude;
  final List<String> features;
  final Map<String, dynamic>? settings;

  SchoolModel({
    required String id,
    required this.name,
    required this.address,
    this.email,
    this.phone,
    this.logoUrl,
    this.subscriptionId,
    this.studentCount = 0,
    this.busCount = 0,
    this.teacherCount = 0,
    this.subscriptionExpiry,
    this.website,
    this.principalName,
    this.principalPhone,
    this.principalEmail,
    this.type = SchoolType.high,
    this.timezone,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.features = const [],
    this.settings,
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
      'address': address,
      'email': email,
      'phone': phone,
      'logoUrl': logoUrl,
      'subscriptionId': subscriptionId,
      'studentCount': studentCount,
      'busCount': busCount,
      'teacherCount': teacherCount,
      'subscriptionExpiry': subscriptionExpiry?.toIso8601String(),
      'website': website,
      'principalName': principalName,
      'principalPhone': principalPhone,
      'principalEmail': principalEmail,
      'type': type.name,
      'timezone': timezone,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'features': features,
      'settings': settings,
    };
  }

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      email: json['email'],
      phone: json['phone'],
      logoUrl: json['logoUrl'],
      subscriptionId: json['subscriptionId'],
      studentCount: json['studentCount'] ?? 0,
      busCount: json['busCount'] ?? 0,
      teacherCount: json['teacherCount'] ?? 0,
      subscriptionExpiry: json['subscriptionExpiry'] != null ? DateTime.parse(json['subscriptionExpiry']) : null,
      website: json['website'],
      principalName: json['principalName'],
      principalPhone: json['principalPhone'],
      principalEmail: json['principalEmail'],
      type: SchoolType.values.firstWhere(
            (e) => e.name == (json['type'] ?? 'high'),
        orElse: () => SchoolType.high,
      ),
      timezone: json['timezone'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postalCode'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      features: List<String>.from(json['features'] ?? []),
      settings: json['settings'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  SchoolModel copyWith({
    String? id,
    String? name,
    String? address,
    String? email,
    String? phone,
    String? logoUrl,
    String? subscriptionId,
    int? studentCount,
    int? busCount,
    int? teacherCount,
    DateTime? subscriptionExpiry,
    String? website,
    String? principalName,
    String? principalPhone,
    String? principalEmail,
    SchoolType? type,
    String? timezone,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    double? latitude,
    double? longitude,
    List<String>? features,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isDeleted,
  }) {
    return SchoolModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      logoUrl: logoUrl ?? this.logoUrl,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      studentCount: studentCount ?? this.studentCount,
      busCount: busCount ?? this.busCount,
      teacherCount: teacherCount ?? this.teacherCount,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      website: website ?? this.website,
      principalName: principalName ?? this.principalName,
      principalPhone: principalPhone ?? this.principalPhone,
      principalEmail: principalEmail ?? this.principalEmail,
      type: type ?? this.type,
      timezone: timezone ?? this.timezone,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      features: features ?? this.features,
      settings: settings ?? this.settings,
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
              other is SchoolModel &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              address == other.address &&
              email == other.email &&
              phone == other.phone &&
              logoUrl == other.logoUrl &&
              subscriptionId == other.subscriptionId &&
              studentCount == other.studentCount &&
              busCount == other.busCount &&
              teacherCount == other.teacherCount &&
              subscriptionExpiry == other.subscriptionExpiry &&
              website == other.website &&
              principalName == other.principalName &&
              principalPhone == other.principalPhone &&
              principalEmail == other.principalEmail &&
              type == other.type &&
              timezone == other.timezone &&
              city == other.city &&
              state == other.state &&
              country == other.country &&
              postalCode == other.postalCode &&
              latitude == other.latitude &&
              longitude == other.longitude &&
              listEquals(features, other.features) &&
              mapEquals(settings, other.settings);

  @override
  int get hashCode =>
      super.hashCode ^
      name.hashCode ^
      address.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      logoUrl.hashCode ^
      subscriptionId.hashCode ^
      studentCount.hashCode ^
      busCount.hashCode ^
      teacherCount.hashCode ^
      subscriptionExpiry.hashCode ^
      website.hashCode ^
      principalName.hashCode ^
      principalPhone.hashCode ^
      principalEmail.hashCode ^
      type.hashCode ^
      timezone.hashCode ^
      city.hashCode ^
      state.hashCode ^
      country.hashCode ^
      postalCode.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      features.hashCode ^
      settings.hashCode;

  @override
  String toString() {
    return 'SchoolModel{id: $id, name: $name, address: $address, studentCount: $studentCount}';
  }
}

class SubscriptionModel extends BaseModel {
  final String schoolId;
  final SubscriptionPlan plan;
  final double amount;
  final PaymentStatus paymentStatus;
  final DateTime startDate;
  final DateTime endDate;
  final int? maxBuses;
  final int? maxStudents;
  final bool liveTracking;
  final bool analytics;
  final bool customReports;
  final bool multipleAdmins;
  final String? transactionId;
  final String? paymentMethod;
  final String? billingEmail;
  final String? billingPhone;
  final String? billingAddress;
  final bool autoRenew;
  final DateTime? nextBillingDate;
  final Map<String, dynamic>? features;

  SubscriptionModel({
    required String id,
    required this.schoolId,
    required this.plan,
    required this.amount,
    required this.paymentStatus,
    required this.startDate,
    required this.endDate,
    this.maxBuses,
    this.maxStudents,
    this.liveTracking = true,
    this.analytics = false,
    this.customReports = false,
    this.multipleAdmins = false,
    this.transactionId,
    this.paymentMethod,
    this.billingEmail,
    this.billingPhone,
    this.billingAddress,
    this.autoRenew = true,
    this.nextBillingDate,
    this.features,
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
      'plan': plan.name,
      'amount': amount,
      'paymentStatus': paymentStatus.name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'maxBuses': maxBuses,
      'maxStudents': maxStudents,
      'liveTracking': liveTracking,
      'analytics': analytics,
      'customReports': customReports,
      'multipleAdmins': multipleAdmins,
      'transactionId': transactionId,
      'paymentMethod': paymentMethod,
      'billingEmail': billingEmail,
      'billingPhone': billingPhone,
      'billingAddress': billingAddress,
      'autoRenew': autoRenew,
      'nextBillingDate': nextBillingDate?.toIso8601String(),
      'features': features,
    };
  }

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] ?? '',
      schoolId: json['schoolId'] ?? '',
      plan: SubscriptionPlan.values.firstWhere(
            (e) => e.name == (json['plan'] ?? 'basic'),
        orElse: () => SubscriptionPlan.basic,
      ),
      amount: json['amount']?.toDouble() ?? 0.0,
      paymentStatus: PaymentStatus.values.firstWhere(
            (e) => e.name == (json['paymentStatus'] ?? 'pending'),
        orElse: () => PaymentStatus.pending,
      ),
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toIso8601String()),
      maxBuses: json['maxBuses'],
      maxStudents: json['maxStudents'],
      liveTracking: json['liveTracking'] ?? true,
      analytics: json['analytics'] ?? false,
      customReports: json['customReports'] ?? false,
      multipleAdmins: json['multipleAdmins'] ?? false,
      transactionId: json['transactionId'],
      paymentMethod: json['paymentMethod'],
      billingEmail: json['billingEmail'],
      billingPhone: json['billingPhone'],
      billingAddress: json['billingAddress'],
      autoRenew: json['autoRenew'] ?? true,
      nextBillingDate: json['nextBillingDate'] != null ? DateTime.parse(json['nextBillingDate']) : null,
      features: json['features'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  SubscriptionModel copyWith({
    String? id,
    String? schoolId,
    SubscriptionPlan? plan,
    double? amount,
    PaymentStatus? paymentStatus,
    DateTime? startDate,
    DateTime? endDate,
    int? maxBuses,
    int? maxStudents,
    bool? liveTracking,
    bool? analytics,
    bool? customReports,
    bool? multipleAdmins,
    String? transactionId,
    String? paymentMethod,
    String? billingEmail,
    String? billingPhone,
    String? billingAddress,
    bool? autoRenew,
    DateTime? nextBillingDate,
    Map<String, dynamic>? features,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isDeleted,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      plan: plan ?? this.plan,
      amount: amount ?? this.amount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      maxBuses: maxBuses ?? this.maxBuses,
      maxStudents: maxStudents ?? this.maxStudents,
      liveTracking: liveTracking ?? this.liveTracking,
      analytics: analytics ?? this.analytics,
      customReports: customReports ?? this.customReports,
      multipleAdmins: multipleAdmins ?? this.multipleAdmins,
      transactionId: transactionId ?? this.transactionId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      billingEmail: billingEmail ?? this.billingEmail,
      billingPhone: billingPhone ?? this.billingPhone,
      billingAddress: billingAddress ?? this.billingAddress,
      autoRenew: autoRenew ?? this.autoRenew,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
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
              other is SubscriptionModel &&
              runtimeType == other.runtimeType &&
              schoolId == other.schoolId &&
              plan == other.plan &&
              amount == other.amount &&
              paymentStatus == other.paymentStatus &&
              startDate == other.startDate &&
              endDate == other.endDate &&
              maxBuses == other.maxBuses &&
              maxStudents == other.maxStudents &&
              liveTracking == other.liveTracking &&
              analytics == other.analytics &&
              customReports == other.customReports &&
              multipleAdmins == other.multipleAdmins &&
              transactionId == other.transactionId &&
              paymentMethod == other.paymentMethod &&
              billingEmail == other.billingEmail &&
              billingPhone == other.billingPhone &&
              billingAddress == other.billingAddress &&
              autoRenew == other.autoRenew &&
              nextBillingDate == other.nextBillingDate &&
              mapEquals(features, other.features);

  @override
  int get hashCode =>
      super.hashCode ^
      schoolId.hashCode ^
      plan.hashCode ^
      amount.hashCode ^
      paymentStatus.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      maxBuses.hashCode ^
      maxStudents.hashCode ^
      liveTracking.hashCode ^
      analytics.hashCode ^
      customReports.hashCode ^
      multipleAdmins.hashCode ^
      transactionId.hashCode ^
      paymentMethod.hashCode ^
      billingEmail.hashCode ^
      billingPhone.hashCode ^
      billingAddress.hashCode ^
      autoRenew.hashCode ^
      nextBillingDate.hashCode ^
      features.hashCode;

  @override
  String toString() {
    return 'SubscriptionModel{id: $id, schoolId: $schoolId, plan: $plan, amount: $amount, status: $paymentStatus}';
  }
}