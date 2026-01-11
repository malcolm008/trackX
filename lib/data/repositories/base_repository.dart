import 'dart:async';
import '../../core/constants/app_constants.dart';

abstract class BaseRepository<T> {
  Future<List<T>> getAll({Map<String, dynamic>? filters});
  Future<T?> getById(String id);
  Future<T> create(T item);
  Future<T> update(String id, T item);
  Future<bool> delete(String id);
  Stream<List<T>> watchAll({Map<String, dynamic>? filters});
  Stream<T?> watchById(String id);
}

class RepositoryFailure implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  RepositoryFailure(this.message, {this.statusCode, this.error});

  @override
  String toString() => 'RepositoryFailure: $message${statusCode != null ? ' ($statusCode)' : ''}';
}

class PaginatedResponse<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNext;
  final bool hasPrevious;

  PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJson,
      ) {
    return PaginatedResponse<T>(
      items: (json['items'] as List<dynamic>)
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList(),
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrevious: json['hasPrevious'] ?? false,
    );
  }

  Map<String, dynamic> toJson(T Function(T) toJson) {
    return {
      'items': items.map(toJson).toList(),
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'hasNext': hasNext,
      'hasPrevious': hasPrevious,
    };
  }
}