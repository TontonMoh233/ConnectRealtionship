class Projets {
  String id; // Identifiant unique du projet
  String titre; // Titre du projet
  String description; // Description du projet
  String statut; // Statut du projet (en cours, terminé, etc.)
  String objectifFinancement; // Objectif de financement
  DateTime dateCreation; // Date de création du projet
  String montantLeve;
   String secteur;// Montant déjà levé pour le projet
  String entrepreneurId;
  // Identifiant de l'entrepreneur associé au projet

  // Constructeur de la classe Projets
  Projets({
    required this.id,
    required this.titre,
    required this.description,
    required this.statut,
    required this.objectifFinancement,
    required this.dateCreation,
    required this.montantLeve,
    required this.secteur,
    required this.entrepreneurId,
  });

  // Convertir l'objet Projets en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'statut': statut,
      'objectif_financement': objectifFinancement,
      'date_creation': dateCreation.toIso8601String(),
      'montant_leve': montantLeve,
      'secteur':secteur,
      'entrepreneur_id': entrepreneurId,
    };
  }

  // Créer un objet Projets à partir d'un JSON
  factory Projets.fromJson(Map<String, dynamic> json) {
    return Projets(
      id: json['id'] as String,
      titre: json['titre'] as String,
      description: json['description'] as String,
      statut: json['statut'] as String,
      secteur: json['secteur'] as String,
      objectifFinancement: json['objectif_financement'] as String,
      dateCreation: DateTime.parse(json['date_creation'] as String),
      montantLeve: json['montant_leve'] as String,
      entrepreneurId: json['entrepreneur_id'] as String,
    );
  }
}
