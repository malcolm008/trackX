class SubscriptionPlan {
  final int? id;
  final String planCode;
  final String name;
  final String description;
  final double price;
  final String billingCycle;
  final int? maxStudents;
  final int? maxBuses;
  final Map<String, dynamic>? features;
  final Map<String, dynamic>? limitations;
  final bool isActive;
  final DateTime createdAt;

  SubscriptionPlan({
    this.id,
    required this.planCode,
    required this.name,
    required this.description,
    required this.price,
    this.billingCycle = 'monthly',
    this.maxStudents,
    this.maxBuses,
    this.features,
    this.limitations,
    this.isActive = true,
    required this.createdAt,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'],
      planCode: json['plan_code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      billingCycle: json['billing_cycle'] ?? 'monthly',
      maxStudents: json['max_students'],
      maxBuses: json['max_buses'],
      features: json['features'] != null
          ? Map<String, dynamic>.from(json['features'])
          : null,
      limitations: json['limitations'] != null
          ? Map<String, dynamic>.from(json['limitations'])
          : null,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'plan_code': planCode,
      'name': name,
      'description': description,
      'price': price,
      'billing_cycle': billingCycle,
      if (maxStudents != null) 'max_students': maxStudents,
      if (maxBuses != null) 'max_buses': maxBuses,
      if (features != null) 'features': features,
      if (limitations != null) 'limitations': limitations,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}