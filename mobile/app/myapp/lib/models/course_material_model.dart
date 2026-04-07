// ─── CourseMaterialModel ───────────────────────────────────────────────────────
// Matches backend courseMaterialSchema

class CourseMaterialModel {
  final String id;
  final String titre;
  final String fichierUrl;
  final String type; // 'pdf', 'doc', 'video'
  final String coursId;
  final DateTime uploadedAt;

  const CourseMaterialModel({
    required this.id,
    required this.titre,
    required this.fichierUrl,
    required this.type,
    required this.coursId,
    required this.uploadedAt,
  });

  factory CourseMaterialModel.fromJson(Map<String, dynamic> json) {
    return CourseMaterialModel(
      id: json['_id'] ?? json['id'] ?? '',
      titre: json['titre'] as String,
      fichierUrl: json['fichierUrl'] as String,
      type: json['type'] as String,
      coursId: json['cours'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'titre': titre,
    'fichierUrl': fichierUrl,
    'type': type,
    'cours': coursId,
    'uploadedAt': uploadedAt.toIso8601String(),
  };

  // IconData get icon {
    // Placeholder - material import needed for real use
    // return type == 'pdf' ? Icons.picture_as_pdf : Icons.insert_drive_file;
  // }

  @override
  String toString() => 'CourseMaterialModel(id: $id, $titre [$type])';
}

