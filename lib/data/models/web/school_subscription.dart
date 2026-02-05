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

  factory SchoolSubscription.fromJson(Map<String, dynamic> json) {
    // Parse the features string if it exists
    Map<String, dynamic> features = {};
    if (json['features'] != null && json['features'] is String) {
      try {
        features = jsonDecode(json['features'] as String);
      } catch (e) {
        print('Error parsing features JSON: $e');
      }
    }

    return SchoolSubscription(
      id: json['id'],
      subscriptionCode: json['subscription_code'] ?? '',
      schoolCode: json['school_code'] ?? '',
      schoolName: json['school_name'] ?? '',
      schoolEmail: json['school_email'],
      schoolPhone: json['school_phone'],
      schoolAddress: json['school_address'],
      totalStudents: json['total_students'] ?? 0,
      totalBuses: json['total_buses'] ?? 0,
      planId: json['plan_id'],
      amount: (json['amount'] != null ?
      double.parse(json['amount'].toString()) : 0), // FIX: Parse amount properly
      status: (json['status'] ?? 'active').toString().toLowerCase(),
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      autoRenew: (json['auto_renew'] == 1) ? true : false,
      paymentMethod: json['payment_method'],
      transactionId: json['transaction_id'],
      createdAt: DateTime.parse(json['created_at']),
      plan: json['plan_id'] != null
          ? SubscriptionPlan.fromJson({
        'id': json['plan_id'],
        'plan_code': '', // This might be missing in your API
        'name': json['plan_name'] ?? '',
        'description': '', // Add if available
        'price': json['amount'] != null ?
        double.parse(json['amount'].toString()) : 0,
        'billing_cycle': json['billing_cycle'] ?? 'monthly',
        'features': features, // Use parsed features map
        'limitations': {}, // Add if available
        'is_active': true,
        'created_at': json['created_at'],
      })
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
      if (id != null) 'id': id,
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
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'auto_renew': autoRenew,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (transactionId != null) 'transaction_id': transactionId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}