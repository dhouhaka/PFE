// ─── DemandeModel ───────────────────────────────────────────────────────────────
// Generic model for backend demandeSchema (inferred: student requests)

class DemandeModel {
  final String id;
  final String titre;
  final String description;
  final String type; // 'absence', 'document', etc.
  final String etudiantId;
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime createdAt;
  final String? enseignantId;
  final String? response;

  const DemandeModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.type,
    required this.etudiantId,
    required this.status,
    required this.createdAt,
    this.enseignantId,
    this.response,
  });

  factory DemandeModel.fromJson(Map<String, dynamic> json) {
    return DemandeModel(
      id: json['_id'] ?? json['id'] ?? '',
      titre: json['titre'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      etudiantId: json['etudiant'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      enseignantId: _parseString(json['enseignant']),
      response: json['response'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'titre': titre,
    'description': description,
    'type': type,
    'etudiant': etudiantId,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    if (enseignantId != null) 'enseignant': enseignantId,
    if (response != null) 'response': response,
  };

  static String? _parseString(dynamic v) => v is String && v.isNotEmpty ? v : null;

  bool get isPending => status == 'pending';

  @override
  String toString() => 'DemandeModel(id: $id, $titre [$status])';
}

