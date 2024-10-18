class Messages {
  String id; // Identifiant unique du message
  String contenu; // Contenu du message
  DateTime dateEnvoi; // Date et heure de l'envoi du message
  String expediteurId; // Identifiant de l'expéditeur
  String destinataireId; // Identifiant du destinataire

  // Constructeur de la classe Messages
  Messages({
    required this.id,
    required this.contenu,
    required this.dateEnvoi,
    required this.expediteurId,
    required this.destinataireId,
  });

  // Convertir l'objet Messages en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contenu': contenu,
      'date_envoi': dateEnvoi.toIso8601String(),
      'expediteur_id': expediteurId,
      'destinataire_id': destinataireId,
    };
  }

  // Créer un objet Messages à partir d'un JSON
  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      id: json['id'] as String,
      contenu: json['contenu'] as String,
      dateEnvoi: DateTime.parse(json['date_envoi'] as String),
      expediteurId: json['expediteur_id'] as String,
      destinataireId: json['destinataire_id'] as String,
    );
  }
}
