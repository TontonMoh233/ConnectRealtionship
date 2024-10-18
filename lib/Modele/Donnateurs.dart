class Donateurs {
  String idUser; // Identifiant de l'utilisateur
  String montantDonneTotal; // Montant total donné par le donateur

  // Constructeur de la classe Donateurs
  Donateurs({
    required this.idUser,
    required this.montantDonneTotal,
  });

  // Convertir l'objet Donateurs en JSON
  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'montant_donne_total': montantDonneTotal,
    };
  }

  // Créer un objet Donateurs à partir d'un JSON
  factory Donateurs.fromJson(Map<String, dynamic> json) {
    return Donateurs(
      idUser: json['id_user'] as String,
      montantDonneTotal: json['montant_donne_total'] as String,
    );
  }
}
