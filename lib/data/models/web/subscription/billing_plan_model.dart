class BillingPlan {
  final int? id;
  final String planId;
  final String name;
  final String description;
  final double price;
  final String billingPeriod;
  final int maxStudents;
  final int maxBuses;
  final List<String> features;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  BillingPlan({
    this.id,
    required this.planId,
    required this.name,
    required this.description,
    required this.price,
    required this.billingPeriod,
    required this.maxStudents,
    required this.maxBuses,
    required this.features,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
});

  factory BillingPlan.fromJson(Map<String, dynamic> json) {
    return BillingPlan(
      id: json['id'] as int?,
      planId: json['plan_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      billingPeriod: json['billing_period'] as String,
      maxStudents: json['max_students'] as int,
      maxBuses: json['max_buses'] as int,
      features: List<String>.from(json['features'] ?? []),
      isActive: (json['is_active'] as int) == 1,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_id': planId,
      'name': name,
      'description': description,
      'price': price,
      'billing_period': billingPeriod,
      'max_students': maxStudents,
      'max_buses': maxBuses,
      'features': features,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  BillingPlan copyWith({
    int? id,
    String? planId,
    String? name,
    String? description,
    double? price,
    String? billingPeriod,
    int? maxStudents,
    int? maxBuses,
    List<String>? features,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
}) {
    return BillingPlan(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      billingPeriod: billingPeriod ?? this.billingPeriod,
      maxStudents: maxStudents ?? this.maxStudents,
      maxBuses: maxBuses ?? this.maxBuses,
      features: features ?? this.features,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}