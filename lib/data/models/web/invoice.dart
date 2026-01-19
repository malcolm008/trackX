import 'school.dart';
import 'school_subscription.dart';

class Invoice {
  final int? id;
  final String invoiceNumber;
  final int subscriptionId;
  final int schoolId;
  final double amount;
  final double tax;
  final double totalAmount;
  final DateTime issueDate;
  final DateTime dueDate;
  final String status;
  final DateTime? paymentDate;
  final String? paymentMethod;
  final List<InvoiceItem> items;
  final String? notes;
  final DateTime createdAt;

  // Related data
  School? school;
  SchoolSubscription? subscription;

  Invoice({
    this.id,
    required this.invoiceNumber,
    required this.subscriptionId,
    required this.schoolId,
    required this.amount,
    this.tax = 0,
    required this.totalAmount,
    required this.issueDate,
    required this.dueDate,
    this.status = 'pending',
    this.paymentDate,
    this.paymentMethod,
    required this.items,
    this.notes,
    required this.createdAt,
    this.school,
    this.subscription,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      invoiceNumber: json['invoice_number'] ?? '',
      subscriptionId: json['subscription_id'],
      schoolId: json['school_id'],
      amount: (json['amount'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      issueDate: DateTime.parse(json['issue_date']),
      dueDate: DateTime.parse(json['due_date']),
      status: json['status'] ?? 'pending',
      paymentDate: json['payment_date'] != null
          ? DateTime.parse(json['payment_date'])
          : null,
      paymentMethod: json['payment_method'],
      items: json['items'] != null
          ? (json['items'] as List).map((item) => InvoiceItem.fromJson(item)).toList()
          : [],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'invoice_number': invoiceNumber,
      'subscription_id': subscriptionId,
      'school_id': schoolId,
      'amount': amount,
      'tax': tax,
      'total_amount': totalAmount,
      'issue_date': issueDate.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'status': status,
      if (paymentDate != null) 'payment_date': paymentDate!.toIso8601String(),
      if (paymentMethod != null) 'payment_method': paymentMethod,
      'items': items.map((item) => item.toJson()).toList(),
      if (notes != null) 'notes': notes,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class InvoiceItem {
  final String name;
  final int quantity;
  final double price;
  final double amount;

  InvoiceItem({
    required this.name,
    required this.quantity,
    required this.price,
    required this.amount,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'amount': amount,
    };
  }
}