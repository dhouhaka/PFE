// ─── PresenceModel ──────────────────────────────────────────────────────────────
// Matches backend presenceSchema

class PresenceModel {
  final String id;
  final bool presente;
  final DateTime datePresence;
  final String etudiantId;
  final String seanceId;

  const PresenceModel({
    required this.id,
    required this.presente,
    required this.datePresence,
    required this.etudiantId,
    required this.seanceId,
  });

  factory PresenceModel.fromJson(Map<String, dynamic> json) {
    return PresenceModel(
      id: json['_id'] ?? json['id'] ?? '',
      presente: json['presente'] as bool,
      datePresence: DateTime.parse(json['datePresence'] as String),
      etudiantId: json['etudiant'] as String,
      seanceId: json['seance'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'presente': presente,
    'datePresence': datePresence.toIso8601String(),
    'etudiant': etudiantId,
    'seance': seanceId,
  };

  // IconData get icon => presente ? Icons.check_circle : Icons.cancel;

  @override
  String toString() => 'PresenceModel(id: $id, ${presente ? "Present" : "Absent"} $datePresence)';
}

