class Dons {
  String id; // Identifiant unique du don
  String montant; // Montant du don
  String projetId; // Identifiant du projet associé au don
  String donateurId; // Identifiant du donateur
  DateTime dateDon; // Date du don

  // Constructeur de la classe Dons
  Dons({
    required this.id,
    required this.montant,
    required this.projetId,
    required this.donateurId,
    required this.dateDon,
  });

  // Convertir l'objet Dons en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'montant': montant,
      'projet_id': projetId,
      'donateur_id': donateurId,
      'date_don': dateDon.toIso8601String(),
    };
  }

  // Créer un objet Dons à partir d'un JSON
  factory Dons.fromJson(Map<String, dynamic> json) {
    return Dons(
      id: json['id'] as String,
      montant: json['montant'] as String,
      projetId: json['projet_id'] as String,
      donateurId: json['donateur_id'] as String,
      dateDon: DateTime.parse(json['date_don'] as String),
    );
  }
}
