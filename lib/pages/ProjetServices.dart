import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjetMethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Méthode pour créer un projet
  Future<void> creerProjet({
    required String? entrepreneurId,
    required String titre,
    required String description,
    required double objectifFinancer,
    required String status,
    required String secteur,
    required DateTime dateCreation,
  }) async {
    try {
      // Ajout d'un nouveau document dans la collection 'projet'
      DocumentReference projetRef = await firestore.collection('projet').add({
        'entrepreneurId': entrepreneurId,
        'titre': titre,
        'description': description,
        'objectifFinancer': objectifFinancer,
        'status': status,
        'secteur': secteur,
        'dateCreation': Timestamp.fromDate(dateCreation), // Conversion en Timestamp pour Firestore
      });

      // Confirmation de l'insertion
      print('Projet ajouté avec succès, ID du document : ${projetRef.id}');
    } catch (e) {
      print('Erreur lors de la création du projet : $e');
    }
  }

  // Boîte de dialogue pour afficher que le projet a bien été enregistré
  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Projet Ajouté"),
          content: const Text("Votre projet a été ajouté avec succès !"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
