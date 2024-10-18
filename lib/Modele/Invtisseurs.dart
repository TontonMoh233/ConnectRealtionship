class Investisseurs {
  String id; // Identifiant unique de l'investisseur
  String fondDisponible; // Fonds disponibles de l'investisseur
  String secteurDInteret; // Secteur d'intérêt de l'investisseur

  // Constructeur de la classe Investisseurs
  Investisseurs({
    required this.id,
    required this.fondDisponible,
    required this.secteurDInteret,
  });

  // Convertir l'objet Investisseurs en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fond_disponible': fondDisponible,
      'secteur_d_interet': secteurDInteret,
    };
  }

  // Créer un objet Investisseurs à partir d'un JSON
  factory Investisseurs.fromJson(Map<String, dynamic> json) {
    return Investisseurs(
      id: json['id'] as String,
      fondDisponible: json['fond_disponible'] as String,
      secteurDInteret: json['secteur_d_interet'] as String,
    );
  }
}
