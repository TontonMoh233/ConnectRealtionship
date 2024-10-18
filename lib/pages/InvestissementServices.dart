import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceInvestissement{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // methodes pour ajouter un Investissement Dans un Projet

  Future<void> ajouterInvestissement({
    required int montantInvesti,
    required DateTime dateInvestissement,
    required String projetId,
    required String investisseursId,
    required int benefice,
  }) async {
    try {
      await _firestore.collection('investissements').add({
        'montantInvesti': montantInvesti,
        'dateInvestissement': dateInvestissement,
        'projetId': projetId,
        'investisseursId': investisseursId,
        'benefice': benefice,
      });
      print('Investissement ajouté avec succès.');
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'investissement: $e');
    }
  }
}
