// ─── ClasseModel ───────────────────────────────────────────────────────────────
// Matches backend classeSchema.js

class ClasseModel {
  final String id;
  final String nom;
  final int annee;
  final String specialisation;
  final String anneeAcademique;

  const ClasseModel({
    required this.id,
    required this.nom,
    required this.annee,
    required this.specialisation,
    required this.anneeAcademique,
  });

  factory ClasseModel.fromJson(Map<String, dynamic> json) {
    return ClasseModel(
      id: json['_id'] ?? json['id'] ?? '',
      nom: json['nom'] as String,
      annee: json['annee'] as int,
      specialisation: json['specialisation'] as String,
      anneeAcademique: json['anneeAcademique'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'nom': nom,
    'annee': annee,
    'specialisation': specialisation,
    'anneeAcademique': anneeAcademique,
  };

  String get label => '$nom · $annee · $specialisation';
  String get shortLabel => nom;

  @override
  String toString() => 'ClasseModel(id: $id, $label)';
}

