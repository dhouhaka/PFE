class DemandeModel {
  final String id;
  final String titre;
  final String description;
  final String type;
  final String etudiantId;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;
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
    this.updatedAt,
    this.enseignantId,
    this.response,
  });

  factory DemandeModel.fromJson(Map<String, dynamic> json) {
    final dynamic wrapped = json['demande'] ?? json['data'];

    final Map<String, dynamic> source = wrapped is Map
        ? Map<String, dynamic>.from(wrapped)
        : json;

    return DemandeModel(
      id: _parseId(source['_id'] ?? source['id']),
      titre: (source['nom'] ?? source['titre'] ?? '').toString(),
      description: (source['description'] ?? '').toString(),
      type: (source['type'] ?? '').toString(),
      etudiantId: _parseId(
        source['etudiant'] ?? source['etudiantId'],
      ),
      status: (
        source['statut'] ??
        source['status'] ??
        'en_attente'
      ).toString(),
      createdAt: DateTime.tryParse(
            source['createdAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(
        source['updatedAt']?.toString() ?? '',
      ),
      enseignantId: _parseNullableId(
        source['enseignant'] ?? source['enseignantId'],
      ),
      response: (
        source['response'] ??
        source['reponse'] ??
        source['commentaire']
      )?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (id.isNotEmpty) '_id': id,
      'nom': titre,
      'description': description,
      'type': type,
      if (etudiantId.isNotEmpty) 'etudiant': etudiantId,
      'statut': status,
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null)
        'updatedAt': updatedAt!.toIso8601String(),
      if (enseignantId != null)
        'enseignant': enseignantId,
      if (response != null)
        'response': response,
    };
  }

  static String _parseId(dynamic value) {
    if (value == null) return '';

    if (value is String) {
      return value;
    }

    if (value is Map) {
      return (
        value['_id'] ??
        value['id'] ??
        ''
      ).toString();
    }

    return value.toString();
  }

  static String? _parseNullableId(dynamic value) {
    final String id = _parseId(value);
    return id.isEmpty ? null : id;
  }

  static String normalizeStatus(String value) {
    switch (value.trim().toLowerCase()) {
      case 'approved':
      case 'approuvee':
      case 'approuvé':
      case 'approuve':
        return 'approved';

      case 'rejected':
      case 'rejete':
      case 'rejetee':
      case 'rejeté':
      case 'rejetée':
        return 'rejected';

      case 'pending':
      case 'en_attente':
      case 'en attente':
      default:
        return 'pending';
    }
  }

  bool get isPending => normalizeStatus(status) == 'pending';

  @override
  String toString() {
    return 'DemandeModel(id: $id, titre: $titre, status: $status)';
  }
}
