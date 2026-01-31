import 'dart:convert';

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
  final DateTime? createdAt;

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
    // Parse price - handle both string and numeric formats
    double parsePrice(dynamic priceValue) {
      if (priceValue == null) return 0.0;
      if (priceValue is num) {
        return priceValue.toDouble();
      } else if (priceValue is String) {
        return double.tryParse(priceValue) ?? 0.0;
      }
      return 0.0;
    }

    // Parse is_active - handle both int (1/0) and bool formats
    bool parseIsActive(dynamic isActiveValue) {
      if (isActiveValue == null) return true;
      if (isActiveValue is bool) {
        return isActiveValue;
      } else if (isActiveValue is int) {
        return isActiveValue == 1;
      } else if (isActiveValue is String) {
        return isActiveValue == '1' || isActiveValue.toLowerCase() == 'true';
      }
      return true;
    }

    // Parse features and limitations - handle both Map and JSON string
    Map<String, dynamic>? parseJsonField(dynamic fieldValue) {
      if (fieldValue == null) return null;
      if (fieldValue is Map<String, dynamic>) {
        return fieldValue;
      } else if (fieldValue is String) {
        try {
          final decoded = jsonDecode(fieldValue);
          if (decoded is Map<String, dynamic>) {
            return decoded;
          }
        } catch (e) {
          print('Error parsing JSON field: $e');
        }
      }
      return null;
    }

    // Parse created_at - handle various date formats
    DateTime? parseCreatedAt(dynamic createdAtValue) {
      if (createdAtValue == null) return null;
      try {
        if (createdAtValue is DateTime) {
          return createdAtValue;
        } else if (createdAtValue is String) {
          return DateTime.parse(createdAtValue);
        } else if (createdAtValue is int) {
          return DateTime.fromMillisecondsSinceEpoch(createdAtValue * 1000);
        }
      } catch (e) {
        print('Error parsing date: $e');
      }
      return null;
    }

    return SubscriptionPlan(
      id: json['id'],
      planCode: json['plan_code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: parsePrice(json['price']),
      billingCycle: json['billing_cycle']?.toString() ?? 'monthly',
      maxStudents: json['max_students'] != null ?
      (json['max_students'] is int ?
      json['max_students'] as int :
      int.tryParse(json['max_students'].toString())) :
      null,
      maxBuses: json['max_buses'] != null ?
      (json['max_buses'] is int ?
      json['max_buses'] as int :
      int.tryParse(json['max_buses'].toString())) :
      null,
      features: parseJsonField(json['features']),
      limitations: parseJsonField(json['limitations']),
      isActive: parseIsActive(json['is_active']),
      createdAt: parseCreatedAt(json['created_at']),
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
      if (features != null) 'features': jsonEncode(features),
      if (limitations != null) 'limitations': jsonEncode(limitations),
      'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  SubscriptionPlan copyWith({
    int? id,
    String? planCode,
    String? name,
    String? description,
    double? price,
    String? billingCycle,
    int? maxStudents,
    int? maxBuses,
    Map<String, dynamic>? features,
    Map<String, dynamic>? limitations,
    bool? isActive,
    DateTime? createdAt,
}) {
    return SubscriptionPlan(
      id: id ?? this.id,
      planCode: planCode ?? this.planCode,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      billingCycle: billingCycle ?? this.billingCycle,
      maxStudents: maxStudents ?? this.maxStudents,
      maxBuses: maxBuses ?? this.maxBuses,
      features: features ?? this.features,
      limitations: limitations ?? this.limitations,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class Subscription {
  final int id;
  final int schoolId;
  final String schoolName;
  final int planId;
  final String planName;
  final double price;
  final String billingCycle;
  final String status;
  final DateTime startDate;
  final DateTime renewalDate;
  final DateTime? endDate;
  final Map<String, dynamic>? features;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Subscription({
    required this.id,
    required this.schoolId,
    required this.schoolName,
    required this.planId,
    required this.planName,
    required this.price,
    required this.billingCycle,
    required this.status,
    required this.startDate,
    required this.renewalDate,
    this.endDate,
    this.features,
    required this.createdAt,
    this.updatedAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as int,
      schoolId: json['school_id'] as int,
      schoolName: json['school_name'] as String,
      planId: json['plan_id'] as int,
      planName: json['plan_name'] as String,
      price: (json['price'] as num).toDouble(),
      billingCycle: json['billing_cycle'] as String,
      status: json['status'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      renewalDate: DateTime.parse(json['renewal_date'] as String),
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date'] as String) : null,
      features: json['features'] != null
          ? Map<String, dynamic>.from(json['features'] as Map)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_id': schoolId,
      'school_name': schoolName,
      'plan_id': planId,
      'plan_name': planName,
      'price': price,
      'billing_cycle': billingCycle,
      'status': status,
      'start_date': startDate.toIso8601String(),
      'renewal_date': renewalDate.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'features': features,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class Invoice {
  final String id;
  final String invoiceNumber;
  final int subscriptionId;
  final String schoolName;
  final double amount;
  final double tax;
  final double totalAmount;
  final DateTime invoiceDate;
  final DateTime dueDate;
  final String  status;
  final String? paymentMethod;
  final DateTime? paidAt;
  final String? transactionId;
  final List<InvoiceItem> items;
  final DateTime createdAt;

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.subscriptionId,
    required this.schoolName,
    required this.amount,
    required this.tax,
    required this.totalAmount,
    required this.invoiceDate,
    required this.dueDate,
    required this.status,
    this.paymentMethod,
    this.paidAt,
    this.transactionId,
    required this.items,
    required this.createdAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] as String,
      invoiceNumber: json['invoice_number'] as String,
      subscriptionId: json['subscription_id'] as int,
      schoolName: json['school_name'] as String,
      amount: (json['amount'] as num).toDouble(),
      tax: (json['tax'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['total_amount'] as num).toDouble(),
      invoiceDate: DateTime.parse(json['invoice_date'] as String),
      dueDate: DateTime.parse(json['due_date'] as String),
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String?,
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at'] as String) : null,
      transactionId: json['transaction_id'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => InvoiceItem.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'subscription_id': subscriptionId,
      'school_name': schoolName,
      'amount': amount,
      'tax': tax,
      'total_amount': totalAmount,
      'invoice_date': invoiceDate.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'status': status,
      'payment_method': paymentMethod,
      'paid_at': paidAt?.toIso8601String(),
      'transaction_id': transactionId,
      'items': items.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class InvoiceItem{
  final String description;
  final int quantity;
  final double unitPrice;
  final double total;

  InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      description: json['description'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unit_price'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total': total,
    };
  }
}

class BillingStats {
  final double totalRevenue;
  final int activeSubscriptions;
  final int upcomingRenewals;
  final double annualRevenue;
  final int overdueInvoices;

  BillingStats({
    required this.totalRevenue,
    required this.activeSubscriptions,
    required this.upcomingRenewals,
    required this.annualRevenue,
    required this.overdueInvoices,
  });

  factory BillingStats.fromJson(Map<String, dynamic> json) {
    return BillingStats(
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      activeSubscriptions: json['active_subscriptions'] as int,
      upcomingRenewals: json['upcoming_renewals'] as int,
      annualRevenue: (json['annual_revenue'] as num).toDouble(),
      overdueInvoices: json['overdue_invoices'] as int,
    );
  }
}