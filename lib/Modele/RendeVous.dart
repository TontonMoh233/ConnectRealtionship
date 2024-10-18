class RendezVous {
  String id; // Identifiant unique du rendez-vous
  String email; // Adresse e-mail de l'utilisateur
  String nom; // Nom de l'utilisateur
  DateTime dateRendezVous; // Date et heure du rendez-vous
  String mentorId; // Identifiant du mentor
  String entrepreneurId; // Identifiant de l'entrepreneur

  // Constructeur de la classe RendezVous
  RendezVous({
    required this.id,
    required this.email,
    required this.nom,
    required this.dateRendezVous,
    required this.mentorId,
    required this.entrepreneurId,
  });

  // Convertir l'objet RendezVous en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nom': nom,
      'date_rendez_vous': dateRendezVous.toIso8601String(),
      'mentor_id': mentorId,
      'entrepreneur_id': entrepreneurId,
    };
  }

  // Créer un objet RendezVous à partir d'un JSON
  factory RendezVous.fromJson(Map<String, dynamic> json) {
    return RendezVous(
      id: json['id'] as String,
      email: json['email'] as String,
      nom: json['nom'] as String,
      dateRendezVous: DateTime.parse(json['date_rendez_vous'] as String),
      mentorId: json['mentor_id'] as String,
      entrepreneurId: json['entrepreneur_id'] as String,
    );
  }
}
