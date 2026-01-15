class School {
  final int? id;
  final String schoolId;
  final String name;
  final String email;
  final String phone;
  final String address;
  final int students;
  final int buses;
  final String status;
  final String subscription;
  final String? subscriptionId;
  final DateTime? subscriptionStartDate;
  final DateTime? subscriptionEndDate;
  final bool autoRenew;
  final String subscriptionStatus;
  final double subscriptionAmount;
  final DateTime? subscriptionUpdatedAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  School({
    this.id,
    required this.schoolId,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.students,
    required this.buses,
    required this.status,
    required this.subscription,
    required this.createdAt,
    this.updatedAt,
    this.subscriptionId,
    this.subscriptionStartDate,
    this.subscriptionAmount = 0.0,
    this.autoRenew = true,
    this.subscriptionEndDate,
    this.subscriptionStatus = 'active',
    this.subscriptionUpdatedAt,
});

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'] as int?,
      schoolId: json['school_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      students: json['students'] as int,
      buses: json['buses'] as int,
      status: json['status'] as String,
      subscription: json['subscription'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      subscriptionId: json['subscription_id'] as String?,
      subscriptionStartDate: json['subscription_start_date'] != null
          ? DateTime.parse(json['subscription_start_date'] as String)
          : null,
      subscriptionEndDate: json['subscription_end_date'] != null
          ? DateTime.parse(json['subscription_end_date'] as String)
          : null,
      autoRenew: (json['auto_renew'] as int?) == 1,
      subscriptionStatus: json['subscription_status'] as String? ?? 'active',
      subscriptionAmount: (json['subscription_amount'] as num?)?.toDouble() ?? 0.0,
      subscriptionUpdatedAt: json['subscription_updated_at'] != null
          ? DateTime.parse(json['subscription_updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_id': schoolId,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'students': students,
      'buses': buses,
      'status': status,
      'subscription': subscription,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'subscription_id': subscriptionId,
      'subscription_start_date': subscriptionStartDate?.toIso8601String(),
      'subscription_end_date': subscriptionEndDate?.toIso8601String(),
      'auto_renew': autoRenew ? 1 : 0,
      'subscription_status': subscriptionStatus,
      'subscription_amount': subscriptionAmount,
      'subscription_updated_at': subscriptionUpdatedAt?.toIso8601String(),
    };
  }

  School copyWith({
    int? id,
    String? schoolId,
    String? name,
    String? email,
    String? phone,
    String? address,
    int? students,
    int? buses,
    String? status,
    String? subscription,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? subscriptionId,
    DateTime? subscriptionStartDate,
    DateTime? subscriptionEndDate,
    bool? autoRenew,
    String? subscriptionStatus,
    double? subscriptionAmount,
    DateTime? subscriptionUpdatedAt,
}) {
    return School(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      students: students ?? this.students,
      buses: buses ?? this.buses,
      status: status ?? this.status,
      subscription: subscription ?? this.subscription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      subscriptionStartDate: subscriptionStartDate ?? this.subscriptionStartDate,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      autoRenew: autoRenew ?? this.autoRenew,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      subscriptionAmount: subscriptionAmount ?? this.subscriptionAmount,
      subscriptionUpdatedAt: subscriptionUpdatedAt ?? this.subscriptionUpdatedAt,
    );
  }
}

class SchoolStats {
  final int totalSchools;
  final int activeSchools;
  final int newThisMonth;
  final int totalStudents;
  final int totalBuses;
  final double revenue;

  SchoolStats({
    required this.totalSchools,
    required this.activeSchools,
    required this.newThisMonth,
    required this.totalStudents,
    required this.totalBuses,
    required this.revenue,
});

  factory SchoolStats.fromJson(Map<String,dynamic> json) {
    return SchoolStats(
      totalSchools: json['total_schools'] as int,
      activeSchools: json['active_schools'] as int,
      newThisMonth: json['new_this_month'] as int,
      totalStudents: json['total_students'] as int,
      totalBuses: json['total_buses'] as int,
      revenue: (json['revenue'] as num).toDouble(),
    );
  }
}