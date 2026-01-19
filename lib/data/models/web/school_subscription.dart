import 'package:flutter/material.dart';
import 'school.dart';
import 'subscription_plan.dart';

class SchoolSubscription {
  final int? id;
  final String subscriptionCode;
  final int schoolId;
  final int planId;
  final double amount;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final bool autoRenew;
  final String? paymentMethod;
  final String? transactionId;
  final DateTime createdAt;

  // Related data (can be loaded separately)
  School? school;
  SubscriptionPlan? plan;

  SchoolSubscription({
    this.id,
    required this.subscriptionCode,
    required this.schoolId,
    required this.planId,
    required this.amount,
    this.status = 'active',
    required this.startDate,
    required this.endDate,
    this.autoRenew = true,
    this.paymentMethod,
    this.transactionId,
    required this.createdAt,
    this.school,
    this.plan,
  });

  factory SchoolSubscription.fromJson(Map<String, dynamic> json) {
    return SchoolSubscription(
      id: json['id'],
      subscriptionCode: json['subscription_code'] ?? '',
      schoolId: json['school_id'],
      planId: json['plan_id'],
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] ?? 'active',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      autoRenew: json['auto_renew'] ?? true,
      paymentMethod: json['payment_method'],
      transactionId: json['transaction_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'subscription_code': subscriptionCode,
      'school_id': schoolId,
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