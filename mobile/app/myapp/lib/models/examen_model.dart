// ─── ExamenModel ───────────────────────────────────────────────────────────────
// Matches backend examenSchema (inferred from routes)

class ExamenModel {
  final String id;
  final String titre;
  final String? description;
  final String type; // 'final', 'midterm', 'quiz'
  final double noteTotale;
  final DateTime dateExamen;
  final String classeId;
  final String coursId;
  final String enseignantId;
  final List<String> etudiantsInscrits;

  const ExamenModel({
    required this.id,
    required this.titre,
    this.description,
    required this.type,
    required this.noteTotale,
    required this.dateExamen,
    required this.classeId,
    required this.coursId,
    required this.enseignantId,
    this.etudiantsInscrits = const [],
  });

  factory ExamenModel.fromJson(Map<String, dynamic> json) {
    return ExamenModel(
      id: json['_id'] ?? json['id'] ?? '',
      titre: json['titre'] as String,
      description: json['description'],
      type: json['type'] as String,
      noteTotale: (json['noteTotale'] ?? 20.0) as double,
      dateExamen: DateTime.parse(json['dateExamen'] as String),
      classeId: json['classe'] as String,
      coursId: json['cours'] as String,
      enseignantId: json['enseignant'] as String,
      etudiantsInscrits: _parseStringList(json['etudiantsInscrits']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'titre': titre,
    if (description != null) 'description': description,
    'type': type,
    'noteTotale': noteTotale,
    'dateExamen': dateExamen.toIso8601String(),
    'classe': classeId,
    'cours': coursId,
    'enseignant': enseignantId,
    if (etudiantsInscrits.isNotEmpty) 'etudiantsInscrits': etudiantsInscrits,
  };

  static List<String> _parseStringList(dynamic v) {
    if (v == null) return [];
    if (v is List) return v.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
    return [];
  }

  @override
  String toString() => 'ExamenModel(id: $id, $titre [$type] $noteTotale pts)';
}

