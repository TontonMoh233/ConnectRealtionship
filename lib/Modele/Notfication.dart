class Notification {
  String id; // Identifiant unique de la notification
  String titre; // Titre de la notification
  String message; // Contenu du message de la notification
  bool lu; // Indicateur si la notification a été lue ou non
  DateTime dateEnvoi; // Date et heure de l'envoi de la notification
  String utilisateurId; // Identifiant de l'utilisateur associé à la notification

  // Constructeur de la classe Notification
  Notification({
    required this.id,
    required this.titre,
    required this.message,
    required this.lu,
    required this.dateEnvoi,
    required this.utilisateurId,
  });

  // Convertir l'objet Notification en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titre': titre,
      'message': message,
      'lu': lu,
      'date_envoi': dateEnvoi.toIso8601String(),
      'utilisateur_id': utilisateurId,
    };
  }

  // Créer un objet Notification à partir d'un JSON
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      titre: json['titre'] as String,
      message: json['message'] as String,
      lu: json['lu'] as bool,
      dateEnvoi: DateTime.parse(json['date_envoi'] as String),
      utilisateurId: json['utilisateur_id'] as String,
    );
  }
}
