import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactEntrepriseService {
  // Méthode publique pour contacter un entrepreneur
  void contactEntrepreneur(String email, BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Contact&body=Bonjour, je suis intéressé par votre profil.',
    );

    try {
      final bool launched = await launch(emailLaunchUri.toString());
      if (!launched) {
        throw 'Could not launch $emailLaunchUri';
      }
    } catch (e) {
      // Affichage du message d'erreur avec un contexte valide
      showDialog(
        context: context, // Utilisez le contexte de l'état
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erreur"),
            content: Text("Aucune application de messagerie n'est installée ou une erreur est survenue."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer le dialogue
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}


void openEmailApp(String emailAddress, String subject, String body) async {
  // Formater l'URL pour l'e-mail
  final String url = 'mailto:$emailAddress?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}