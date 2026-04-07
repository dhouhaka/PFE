// ─── SeanceModel ───────────────────────────────────────────────────────────────
// Matches backend seanceSchema

class SeanceModel {
  final String id;
  final String titre;
  final DateTime dateDebut;
  final DateTime dateFin;
  final String salle;
  final String coursId;
  final String enseignantId;
  final List<String> etudiantsPresents;

  const SeanceModel({
    required this.id,
    required this.titre,
    required this.dateDebut,
    required this.dateFin,
    required this.salle,
    required this.coursId,
    required this.enseignantId,
    this.etudiantsPresents = const [],
  });

  factory SeanceModel.fromJson(Map<String, dynamic> json) {
    return SeanceModel(
      id: json['_id'] ?? json['id'] ?? '',
      titre: json['titre'] as String,
      dateDebut: DateTime.parse(json['dateDebut'] as String),
      dateFin: DateTime.parse(json['dateFin'] as String),
      salle: json['salle'] as String,
      coursId: json['cours'] as String,
      enseignantId: json['enseignant'] as String,
      etudiantsPresents: _parseStringList(json['etudiantsPresents']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'titre': titre,
    'dateDebut': dateDebut.toIso8601String(),
    'dateFin': dateFin.toIso8601String(),
    'salle': salle,
    'cours': coursId,
    'enseignant': enseignantId,
    if (etudiantsPresents.isNotEmpty) 'etudiantsPresents': etudiantsPresents,
  };

  static List<String> _parseStringList(dynamic v) {
    if (v == null) return [];
    if (v is List) return v.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
    return [];
  }

  Duration get duration => dateFin.difference(dateDebut);

  @override
  String toString() => 'SeanceModel(id: $id, $titre ${dateDebut.toString().substring(0,16)})';
}

