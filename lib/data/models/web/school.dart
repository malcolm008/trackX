class School {
  final int? id;
  final String schoolCode;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? city;
  final String? country;
  final String? contactPerson;
  final int totalStudents;
  final int totalBuses;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  School({
    this.id,
    required this.schoolCode,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.city,
    this.country,
    this.contactPerson,
    this.totalStudents = 0,
    this.totalBuses = 0,
    this.status = 'active',
    required this.createdAt,
    required this.updatedAt,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? 0;
    }

    return School(
      id: parseInt(json['id']),
      schoolCode: json['school_code'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      contactPerson: json['contact_person'],
      totalStudents: parseInt(json['total_students']),
      totalBuses: parseInt(json['total_buses']),
      status: json['status'] ?? 'active',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'school_code': schoolCode,
      'name': name,
      'email': email,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (contactPerson != null) 'contact_person': contactPerson,
      'total_students': totalStudents,
      'total_buses': totalBuses,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}