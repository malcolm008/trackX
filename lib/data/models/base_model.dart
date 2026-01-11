import 'package:flutter/material.dart';

class BaseModel {
  final String id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final bool isDeleted;

  BaseModel({
    required this.id,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.isDeleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
      'isDeleted': isDeleted,
    };
  }

  factory BaseModel.fromJson(Map<String, dynamic> json) {
    return BaseModel(
      id: json['id'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is BaseModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'BaseModel{id: $id, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, isDeleted: $isDeleted}';
  }
}