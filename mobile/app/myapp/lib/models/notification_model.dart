// ─── NotificationModel ─────────────────────────────────────────────────────────
// Matches backend notificationSchema

class NotificationModel {
  final String id;
  final String titre;
  final String message;
  final String type; // 'announcement', 'grade', 'presence', etc.
  final String userId;
  final bool lu;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.titre,
    required this.message,
    required this.type,
    required this.userId,
    this.lu = false,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? json['id'] ?? '',
      titre: json['titre'] as String,
      message: json['message'] as String,
      type: json['type'] as String,
      userId: json['user'] as String,
      lu: json['lu'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'titre': titre,
    'message': message,
    'type': type,
    'user': userId,
    'lu': lu,
    'createdAt': createdAt.toIso8601String(),
  };

  @override
  String toString() => 'NotificationModel(id: $id, $titre [${lu ? 'read' : 'unread'}])';
}

