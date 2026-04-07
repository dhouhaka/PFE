// ─── NoteModel ─────────────────────────────────────────────────────────────────
// Matches backend noteSchema (student grades)

class NoteModel {
  final String id;
  final double valeur;
  final String matiere;
  final String? appreciation;
  final String etudiantId;
  final String examenId;
  final String enseignantId;

  const NoteModel({
    required this.id,
    required this.valeur,
    required this.matiere,
    this.appreciation,
    required this.etudiantId,
    required this.examenId,
    required this.enseignantId,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['_id'] ?? json['id'] ?? '',
      valeur: (json['valeur'] ?? 0.0) as double,
      matiere: json['matiere'] as String,
      appreciation: json['appreciation'],
      etudiantId: json['etudiant'] as String,
      examenId: json['examen'] as String,
      enseignantId: json['enseignant'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'valeur': valeur,
    'matiere': matiere,
    if (appreciation != null) 'appreciation': appreciation,
    'etudiant': etudiantId,
    'examen': examenId,
    'enseignant': enseignantId,
  };

  String get gradeLetter {
    if (valeur >= 16) return 'A';
    if (valeur >= 14) return 'B';
    if (valeur >= 12) return 'C';
    if (valeur >= 10) return 'D';
    return 'F';
  }

  @override
  String toString() => 'NoteModel(id: $id, $matiere: ${valeur.toStringAsFixed(2)} ($gradeLetter))';
}

