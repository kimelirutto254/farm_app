class NotificationModel {
  final int id;
  final String notification;
  final int farmerId;
  final int inspectorId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.notification,
    required this.farmerId,
    required this.inspectorId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      notification: json['notification'],
      farmerId: json['farmer_id'],
      inspectorId: json['inspector_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'notification': notification,
      'farmer_id': farmerId,
      'inspector_id': inspectorId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
