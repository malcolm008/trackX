class Subscription {
  final String id;
  final String schoolId;
  final String schoolName;
  final String plan;
  final double amount;
  final String period;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final bool autoRenew;
  final int students;
  final int buses;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Subscription({
    required this.id,
    required this.schoolId,
    required this.schoolName,
    required this.plan,
    required this.amount,
    required this.period,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.autoRenew,
    required this.students,
    required this.buses,
    this.createdAt,
    this.updatedAt,
});

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['subscription_id'] as String,
      schoolId: json['school_id'] as String,
      schoolName: json['name'] as String,
      plan: json['subscription'] as String,
      amount: (json['subscription_amount'] as num).toDouble(),
      period: 'Monthly', // You can calculate this from billing period
      status: json['subscription_status'] as String,
      startDate: DateTime.parse(json['subscription_start_date'] as String),
      endDate: DateTime.parse(json['subscription_end_date'] as String),
      autoRenew: (json['auto_renew'] as int) == 1,
      students: json['students'] as int,
      buses: json['buses'] as int,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscription_id': id,
      'school_id': schoolId,
      'school_name': schoolName,
      'plan': plan,
      'amount': amount,
      'period': period,
      'status': status,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'auto_renew': autoRenew,
      'students': students,
      'buses': buses,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Subscription copyWith({
    String? id,
    String? schoolId,
    String? schoolName,
    String? plan,
    double? amount,
    String? period,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    bool? autoRenew,
    int? students,
    int? buses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Subscription(
      id: id ?? this.id,
      schoolId: schoolId ?? this.schoolId,
      schoolName: schoolName ?? this.schoolName,
      plan: plan ?? this.plan,
      amount: amount ?? this.amount,
      period: period ?? this.period,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      autoRenew: autoRenew ?? this.autoRenew,
      students: students ?? this.students,
      buses: buses ?? this.buses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isExpiringSoon {
    final daysUntilExpiry = endDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 7 && daysUntilExpiry > 0;
  }

  bool get isExpired {
    return endDate.isBefore(DateTime.now());
  }

  int get daysUntilExpiry {
    return endDate.difference(DateTime.now()).inDays;
  }
}

class SubscriptionStats {
  final double totalRevenue;
  final int activeSubscriptions;
  final int trialSubscriptions;
  final double renewalRate;
  final int expiringSoon;
  final int cancelledThisMonth;

  SubscriptionStats({
    required this.totalRevenue,
    required this.activeSubscriptions,
    required this.trialSubscriptions,
    required this.renewalRate,
    required this.expiringSoon,
    required this.cancelledThisMonth,
  });

  factory SubscriptionStats.fromJson(Map<String, dynamic> json) {
    return SubscriptionStats(
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      activeSubscriptions: json['active_subscriptions'] as int,
      trialSubscriptions: json['trial_subscriptions'] as int,
      renewalRate: (json['renewal_rate'] as num).toDouble(),
      expiringSoon: json['expiring_soon'] as int,
      cancelledThisMonth: json['cancelled_this_month'] as int,
    );
  }
}