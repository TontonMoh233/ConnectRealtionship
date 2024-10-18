class Investir {
  String id; // Identifiant unique de l'investissement
  String montantInvesti; // Montant investi
  DateTime dateInvestissement; // Date de l'investissement
  String projetId; // Identifiant du projet
  String investisseurId; // Identifiant de l'investisseur
  String benefice; // Bénéfice généré par l'investissement

  // Constructeur de la classe Investir
  Investir({
    required this.id,
    required this.montantInvesti,
    required this.dateInvestissement,
    required this.projetId,
    required this.investisseurId,
    required this.benefice,
  });

  // Convertir l'objet Investir en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'montant_investi': montantInvesti,
      'date_investissement': dateInvestissement.toIso8601String(),
      'projet_id': projetId,
      'investisseur_id': investisseurId,
      'benefice': benefice,
    };
  }

  // Créer un objet Investir à partir d'un JSON
  factory Investir.fromJson(Map<String, dynamic> json) {
    return Investir(
      id: json['id'] as String,
      montantInvesti: json['montant_investi'] as String,
      dateInvestissement: DateTime.parse(json['date_investissement'] as String),
      projetId: json['projet_id'] as String,
      investisseurId: json['investisseur_id'] as String,
      benefice: json['benefice'] as String,
    );
  }
}
