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