// ─── AnnouncementModel ─────────────────────────────────────────────────────────
// Generic model for backend announcementSchema (inferred fields)

class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final DateTime createdAt;
  final bool pinned;
  final List<String> viewedBy;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.createdAt,
    this.pinned = false,
    this.viewedBy = const [],
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['author'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      pinned: json['pinned'] as bool? ?? false,
      viewedBy: _parseStringList(json['viewedBy']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'content': content,
    'author': authorId,
    'createdAt': createdAt.toIso8601String(),
    'pinned': pinned,
    if (viewedBy.isNotEmpty) 'viewedBy': viewedBy,
  };

  static List<String> _parseStringList(dynamic v) {
    if (v == null) return [];
    if (v is List) return v.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
    return [];
  }

  @override
  String toString() => 'AnnouncementModel(id: $id, $title)';
}

