// ─── EmploiDuTempsModel ────────────────────────────────────────────────────────
// Matches backend emploiDuTempsSchema

class EmploiDuTempsModel {
  final String id;
  final String jour; // 'Lundi', 'Mardi' etc.
  final String heureDebut;
  final String heureFin;
  final String salle;
  final String coursId;
  final String enseignantId;
  final String classeId;

  const EmploiDuTempsModel({
    required this.id,
    required this.jour,
    required this.heureDebut,
    required this.heureFin,
    required this.salle,
    required this.coursId,
    required this.enseignantId,
    required this.classeId,
  });

  factory EmploiDuTempsModel.fromJson(Map<String, dynamic> json) {
    return EmploiDuTempsModel(
      id: json['_id'] ?? json['id'] ?? '',
      jour: json['jour'] as String,
      heureDebut: json['heureDebut'] as String,
      heureFin: json['heureFin'] as String,
      salle: json['salle'] as String,
      coursId: json['cours'] as String,
      enseignantId: json['enseignant'] as String,
      classeId: json['classe'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'jour': jour,
    'heureDebut': heureDebut,
    'heureFin': heureFin,
    'salle': salle,
    'cours': coursId,
    'enseignant': enseignantId,
    'classe': classeId,
  };

  String get timeSlot => '$heureDebut - $heureFin';

  @override
  String toString() => 'EmploiDuTempsModel(id: $id, $jour $timeSlot $salle)';
}

