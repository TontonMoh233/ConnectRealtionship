class Entrepreneur {
  String utilisateurId; // Identifiant de l'utilisateur
  String biographie; // Biographie de l'entrepreneur
  String nom; // Nom de l'entrepreneur

  // Constructeur de la classe Entrepreneur
  Entrepreneur({
    required this.utilisateurId,
    required this.biographie,
    required this.nom,
  });

  // Convertir l'objet Entrepreneur en JSON
  Map<String, dynamic> toJson() {
    return {
      'utilisateur_id': utilisateurId,
      'biographie': biographie,
      'nom': nom,
    };
  }

  // Créer un objet Entrepreneur à partir d'un JSON
  factory Entrepreneur.fromJson(Map<String, dynamic> json) {
    return Entrepreneur(
      utilisateurId: json['utilisateur_id'] as String,
      biographie: json['biographie'] as String,
      nom: json['nom'] as String,
    );
  }
}
