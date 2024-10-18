class Conseils {
  String id; // Identifiant unique du conseil
  String conseil; // Contenu du conseil
  DateTime dateConseil; // Date et heure du conseil
  String utilisateurMentorId; // Identifiant de l'utilisateur mentor
  String utilisateurEntrepreneurId; // Identifiant de l'utilisateur entrepreneur

  // Constructeur de la classe Conseils
  Conseils({
    required this.id,
    required this.conseil,
    required this.dateConseil,
    required this.utilisateurMentorId,
    required this.utilisateurEntrepreneurId,
  });

  // Convertir l'objet Conseils en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conseil': conseil,
      'date_conseil': dateConseil.toIso8601String(),
      'utilisateur_mentor_id': utilisateurMentorId,
      'utilisateur_entrepreneur_id': utilisateurEntrepreneurId,
    };
  }

  // Créer un objet Conseils à partir d'un JSON
  factory Conseils.fromJson(Map<String, dynamic> json) {
    return Conseils(
      id: json['id'] as String,
      conseil: json['conseil'] as String,
      dateConseil: DateTime.parse(json['date_conseil'] as String),
      utilisateurMentorId: json['utilisateur_mentor_id'] as String,
      utilisateurEntrepreneurId: json['utilisateur_entrepreneur_id'] as String,
    );
  }
}
