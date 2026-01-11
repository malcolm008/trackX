import 'package:flutter/foundation.dart';
import '../../../core/enums/app_enums.dart';
import '../base_model.dart';

class NotificationModel extends BaseModel {
  final String title;
  final String body;
  final NotificationType type;
  final NotificationPriority priority;
  final String? userId;
  final String? studentId;
  final String? routeId;
  final String? busId;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime? readAt;
  final String? actionUrl;
  final String? imageUrl;
  final List<String>? tags;
  final DateTime? scheduledFor;
  final String? senderId;
  final String? senderName;

  NotificationModel({
    required String id,
    required this.title,
    required this.body,
    required this.type,
    this.priority = NotificationPriority.medium,
    this.userId,
    this.studentId,
    this.routeId,
    this.busId,
    this.data,
    this.isRead = false,
    this.readAt,
    this.actionUrl,
    this.imageUrl,
    this.tags,
    this.scheduledFor,
    this.senderId,
    this.senderName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool isActive = true,
    bool isDeleted = false,
  }) : super(
    id: id,
    createdAt: createdAt ?? DateTime.now(),
    updatedAt: updatedAt,
    isActive: isActive,
    isDeleted: isDeleted,
  );

  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'title': title,
      'body': body,
      'type': type.name,
      'priority': priority.name,
      'userId': userId,
      'studentId': studentId,
      'routeId': routeId,
      'busId': busId,
      'data': data,
      'isRead': isRead,
      'readAt': readAt?.toIso8601String(),
      'actionUrl': actionUrl,
      'imageUrl': imageUrl,
      'tags': tags,
      'scheduledFor': scheduledFor?.toIso8601String(),
      'senderId': senderId,
      'senderName': senderName,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: NotificationType.values.firstWhere(
            (e) => e.name == (json['type'] ?? 'system'),
        orElse: () => NotificationType.system,
      ),
      priority: NotificationPriority.values.firstWhere(
            (e) => e.name == (json['priority'] ?? 'medium'),
        orElse: () => NotificationPriority.medium,
      ),
      userId: json['userId'],
      studentId: json['studentId'],
      routeId: json['routeId'],
      busId: json['busId'],
      data: json['data'],
      isRead: json['isRead'] ?? false,
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
      actionUrl: json['actionUrl'],
      imageUrl: json['imageUrl'],
      tags: List<String>.from(json['tags'] ?? []),
      scheduledFor: json['scheduledFor'] != null ? DateTime.parse(json['scheduledFor']) : null,
      senderId: json['senderId'],
      senderName: json['senderName'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    NotificationPriority? priority,
    String? userId,
    String? studentId,
    String? routeId,
    String? busId,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? readAt,
    String? actionUrl,
    String? imageUrl,
    List<String>? tags,
    DateTime? scheduledFor,
    String? senderId,
    String? senderName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    bool? isDeleted,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      userId: userId ?? this.userId,
      studentId: studentId ?? this.studentId,
      routeId: routeId ?? this.routeId,
      busId: busId ?? this.busId,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      actionUrl: actionUrl ?? this.actionUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          super == other &&
              other is NotificationModel &&
              runtimeType == other.runtimeType &&
              title == other.title &&
              body == other.body &&
              type == other.type &&
              priority == other.priority &&
              userId == other.userId &&
              studentId == other.studentId &&
              routeId == other.routeId &&
              busId == other.busId &&
              mapEquals(data, other.data) &&
              isRead == other.isRead &&
              readAt == other.readAt &&
              actionUrl == other.actionUrl &&
              imageUrl == other.imageUrl &&
              listEquals(tags, other.tags) &&
              scheduledFor == other.scheduledFor &&
              senderId == other.senderId &&
              senderName == other.senderName;

  @override
  int get hashCode =>
      super.hashCode ^
      title.hashCode ^
      body.hashCode ^
      type.hashCode ^
      priority.hashCode ^
      userId.hashCode ^
      studentId.hashCode ^
      routeId.hashCode ^
      busId.hashCode ^
      data.hashCode ^
      isRead.hashCode ^
      readAt.hashCode ^
      actionUrl.hashCode ^
      imageUrl.hashCode ^
      tags.hashCode ^
      scheduledFor.hashCode ^
      senderId.hashCode ^
      senderName.hashCode;

  @override
  String toString() {
    return 'NotificationModel{id: $id, title: $title, type: $type, isRead: $isRead}';
  }
}