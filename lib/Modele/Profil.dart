class Profil {
  String id; // Identifiant unique du profil
  String photo; // URL de la photo de profil
  String biographie; // Biographie de l'utilisateur
  String expertise; // Domaine d'expertise de l'utilisateur
  String centreDInteret; // Centre d'intérêt de l'utilisateur
  String utilisateurId; // Identifiant de l'utilisateur associé au profil

  // Constructeur de la classe Profil
  Profil({
    required this.id,
    required this.photo,
    required this.biographie,
    required this.expertise,
    required this.centreDInteret,
    required this.utilisateurId,
  });

  // Convertir l'objet Profil en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'photo': photo,
      'biographie': biographie,
      'expertise': expertise,
      'centre_d_interet': centreDInteret,
      'utilisateur_id': utilisateurId,
    };
  }

  // Créer un objet Profil à partir d'un JSON
  factory Profil.fromJson(Map<String, dynamic> json) {
    return Profil(
      id: json['id'] as String,
      photo: json['photo'] as String,
      biographie: json['biographie'] as String,
      expertise: json['expertise'] as String,
      centreDInteret: json['centre_d_interet'] as String,
      utilisateurId: json['utilisateur_id'] as String,
    );
  }
}
