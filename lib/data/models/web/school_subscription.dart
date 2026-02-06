import 'package:flutter/material.dart';
import 'school.dart';
import 'subscription_plan.dart';
import 'dart:convert';

class SchoolSubscription {
  final int? id;
  final String subscriptionCode;

  final String schoolCode;
  final String schoolName;
  final String? schoolEmail;
  final String? schoolPhone;
  final String? schoolAddress;
  final int totalStudents;
  final int totalBuses;

  final int planId;
  final double amount;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final bool autoRenew;
  final String? paymentMethod;
  final String? transactionId;
  final DateTime createdAt;


  SubscriptionPlan? plan;

  SchoolSubscription({
    this.id,
    required this.subscriptionCode,
    required this.schoolCode,
    required this.schoolName,
    this.schoolEmail,
    this.schoolPhone,
    this.schoolAddress,
    this.totalStudents = 0,
    this.totalBuses = 0,
    required this.planId,
    required this.amount,
    this.status = 'active',
    required this.startDate,
    required this.endDate,
    this.autoRenew = true,
    this.paymentMethod,
    this.transactionId,
    required this.createdAt,
    this.plan,
  });

  static DateTime calculateRenewalDate(DateTime startDate, String billingCycle) {
    switch (billingCycle.toLowerCase()) {
      case 'monthly':
        return DateTime(startDate.year, startDate.month + 1, startDate.day);
      case 'quarterly':
        return DateTime(startDate.year, startDate.month + 3, startDate.day);
      case 'annual':
        return DateTime(startDate.year + 1, startDate.month, startDate.day);
      default:
        return startDate.add(const Duration(days: 30));
    }
  }

  factory SchoolSubscription.fromJson(Map<String, dynamic> json) {
    print('DEBUG: Parsing subscription JSON keys: ${json.keys.toList()}');

    DateTime? safeParseDate(dynamic dateValue) {
      if (dateValue == null) return null;
      try {
        return DateTime.parse(dateValue.toString());
      } catch(e) {
        print('Warning: Could not parse date: $dateValue');
        return null;
      }
    }
    // Parse the features string if it exists
    Map<String, dynamic> features = {};
    if (json['features'] != null && json['features'] is String) {
      try {
        features = jsonDecode(json['features'] as String);
      } catch (e) {
        print('Error parsing features JSON: $e');
      }
    }

    final startDate = DateTime.parse(json['start_date'].toString());
    final billingCycle = (json['billing_cycle']?.toString().toLowerCase() ?? 'monthly');

    DateTime endDate;
    final parsedEndDate = safeParseDate(json['end_date']);
    if(parsedEndDate != null) {
      endDate = parsedEndDate;
    } else {
      endDate = SchoolSubscription.calculateRenewalDate(startDate, billingCycle);
    }

    int? parsedId;
    if (json['id'] != null) {
      if (json['id'] is int) {
        parsedId = json['id'] as int;
      } else if (json['id'] is String) {
        parsedId = int.tryParse(json['id'] as String);
      }
    }

    return SchoolSubscription(
      id: parsedId,
      subscriptionCode: json['subscription_code'] ?? '',
      schoolCode: json['school_code']?.toString() ?? '',
      schoolName: json['school_name']?.toString() ?? '',
      schoolEmail: json['school_email']?.toString(),
      schoolPhone: json['school_phone']?.toString(),
      schoolAddress: json['school_address']?.toString(),
      totalStudents: json['total_students'] is int
          ? json['total_students'] as int
          : (json['total_students'] is String
          ? int.tryParse(json['total_students'] as String) ?? 0
          : 0),
      totalBuses: json['total_buses'] is int
          ? json['total_buses'] as int
          : (json['total_buses'] is String
          ? int.tryParse(json['total_buses'] as String) ?? 0
          : 0),
      planId: json['plan_id'] is int
          ? json['plan_id'] as int
          : (json['plan_id'] is String
          ? int.tryParse(json['plan_id'] as String) ?? 0
          : 0),
      amount: (json['amount'] is num
          ? (json['amount'] as num).toDouble()
          : (json['amount'] is String
          ? double.tryParse(json['amount'] as String) ?? 0.0
          : 0.0)),
      status: (json['status']?.toString().toLowerCase() ?? 'active'),
      startDate: startDate,
      endDate: endDate,
      autoRenew: json['auto_renew'] is int
          ? json['auto_renew'] == 1
          : (json['auto_renew'] is String
          ? json['auto_renew'] == '1'
          : (json['auto_renew'] is bool
          ? json['auto_renew'] as bool
          : false)),
      paymentMethod: json['payment_method']?.toString(),
      transactionId: json['transaction_id']?.toString(),
      createdAt: safeParseDate(json['created_at']) ?? DateTime.now(),
      plan: json['plan_id'] != null
          ? SubscriptionPlan(
        id: json['plan_id'] is int
            ? json['plan_id'] as int
            : (json['plan_id'] is String
            ? int.tryParse(json['plan_id'] as String) ?? 0
            : 0),
        planCode: json['plan_code']?.toString() ?? '',
        name: json['plan_name']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        price: (json['amount'] is num
            ? (json['amount'] as num).toDouble()
            : (json['amount'] is String
            ? double.tryParse(json['amount'] as String) ?? 0.0
            : 0.0)),
        billingCycle: json['billing_cycle']?.toString().toLowerCase() ?? 'monthly',
        features: features,
        limitations: {},
        isActive: true,
        createdAt: safeParseDate(json['created_at']) ?? DateTime.now(),
      )
          : null,
    );
  }

  SchoolSubscription copyWith({
    int? id,
    String? subscriptionCode,
    String? schoolCode,
    String? schoolName,
    String? schoolEmail,
    String? schoolPhone,
    String? schoolAddress,
    int? totalStudents,
    int? totalBuses,
    int? planId,
    double? amount,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    bool? autoRenew,
    String? paymentMethod,
    String? transactionId,
    DateTime? createdAt,
    SubscriptionPlan? plan,
  }) {
    return SchoolSubscription(
      id: id ?? this.id,
      subscriptionCode: subscriptionCode ?? this.subscriptionCode,
      schoolCode: schoolCode ?? this.schoolCode,
      schoolName: schoolName ?? this.schoolName,
      schoolEmail: schoolEmail ?? this.schoolEmail,
      schoolPhone: schoolPhone ?? this.schoolPhone,
      schoolAddress: schoolAddress ?? this.schoolAddress,
      totalStudents: totalStudents ?? this.totalStudents,
      totalBuses: totalBuses ?? this.totalBuses,
      planId: planId ?? this.planId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      autoRenew: autoRenew ?? this.autoRenew,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      createdAt: createdAt ?? this.createdAt,
      plan: plan ?? this.plan,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id!.toString(),
      'subscription_code': subscriptionCode,
      'school_code': schoolCode,
      'school_name': schoolName,
      'school_email': schoolEmail,
      'school_phone': schoolPhone,
      'school_address': schoolAddress,
      'total_students': totalStudents,
      'total_buses': totalBuses,
      'plan_id': planId,
      'amount': amount,
      'status': status,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate.toIso8601String().split('T')[0],
      'auto_renew': autoRenew,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (transactionId != null) 'transaction_id': transactionId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}