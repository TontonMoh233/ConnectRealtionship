class Depenses {
  String id; // Identifiant unique de la dépense
  String description; // Description de la dépense
  String montant; // Montant de la dépense
  DateTime dateDepense; // Date de la dépense
  String projetId; // Identifiant du projet associé à la dépense
  String entrepreneurId; // Identifiant de l'entrepreneur associé à la dépense

  // Constructeur de la classe Depenses
  Depenses({
    required this.id,
    required this.description,
    required this.montant,
    required this.dateDepense,
    required this.projetId,
    required this.entrepreneurId,
  });

  // Convertir l'objet Depenses en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'montant': montant,
      'date_depense': dateDepense.toIso8601String(),
      'projet_id': projetId,
      'entrepreneur_id': entrepreneurId,
    };
  }

  // Créer un objet Depenses à partir d'un JSON
  factory Depenses.fromJson(Map<String, dynamic> json) {
    return Depenses(
      id: json['id'] as String,
      description: json['description'] as String,
      montant: json['montant'] as String,
      dateDepense: DateTime.parse(json['date_depense'] as String),
      projetId: json['projet_id'] as String,
      entrepreneurId: json['entrepreneur_id'] as String,
    );
  }
}
