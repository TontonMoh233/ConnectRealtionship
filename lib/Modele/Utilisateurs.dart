
class Utilisateur {
  String? id;
  String? email;
  String? nom;
  DateTime dateInscription;
  String? motDePasse;


  Utilisateur({
    required this.id,
    required this.email,
    this.nom,
    DateTime? dateInscription,
    this.motDePasse,
  }) : this.dateInscription = dateInscription ?? DateTime.now();

  // Convertir l'objet Utilisateur en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nom': nom,
      'date_inscription': dateInscription.toIso8601String(),
      'mot_de_passe': motDePasse,
    };
  }

  // Créer un objet Utilisateur à partir d'un JSON
  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'] as String,
      email: json['email'] as String,
      nom: json['nom'] as String,
      dateInscription: DateTime.parse(json['date_inscription'] as String),
      motDePasse: json['mot_de_passe'] as String,
    );
  }
}
