class Mentors {
  String utilisateurId; // Identifiant de l'utilisateur
  String expertise; // Domaine d'expertise du mentor
  String conseilsFournis; // Conseils fournis par le mentor

  // Constructeur de la classe Mentors
  Mentors({
    required this.utilisateurId,
    required this.expertise,
    required this.conseilsFournis,
  });

  // Convertir l'objet Mentors en JSON
  Map<String, dynamic> toJson() {
    return {
      'utilisateur_id': utilisateurId,
      'expertise': expertise,
      'conseils_fournis': conseilsFournis,
    };
  }
  // Créer un objet Mentors à partir d'un JSON
  factory Mentors.fromJson(Map<String, dynamic> json) {
    return Mentors(
      utilisateurId: json['utilisateur_id'] as String,
      expertise: json['expertise'] as String,
      conseilsFournis: json['conseils_fournis'] as String,
    );
  }
}
