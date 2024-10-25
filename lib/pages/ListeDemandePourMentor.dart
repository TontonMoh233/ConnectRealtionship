import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ServiceNotify.dart'; // Assurez-vous que ce fichier est importé pour gérer les notifications

class ListeDemandesPage extends StatefulWidget {
  @override
  _ListeDemandesPageState createState() => _ListeDemandesPageState();
}

class _ListeDemandesPageState extends State<ListeDemandesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Demande> demandes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDemandes();
  }

  Future<void> _fetchDemandes() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('demandesConseils')
            .where('mentorId', isEqualTo: user.uid)
            .get();

        setState(() {
          demandes = querySnapshot.docs.map((doc) => Demande.fromDocument(doc)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des demandes.')),
      );
    }
  }

  Future<void> _acceptDemande(String demandeId, String entrepreneurId) async {
    String message = await _showMessageDialog();

    if (message.isNotEmpty) {
      try {
        await _firestore.collection('demandesConseils').doc(demandeId).update({'statut': 'acceptée'});
        // Récupérer le token FCM de l'entrepreneur
        DocumentSnapshot entrepreneurDoc = await _firestore.collection('utilisateurs').doc(entrepreneurId).get();
        String token = entrepreneurDoc['fcmToken']; // Assurez-vous que 'fcmToken' existe dans le document


        // Envoi de notification à l'entrepreneur
        await PushNotificationService.sendNotification(
          title: "Demande acceptée",
          body: "Votre demande de conseil a ete accepté bravo , a present vous vous pouvez echanger avec le mentor",
          token: token , // Remplacez par le token FCM de l'entrepreneur
          contextType: 'accepted_request',
          contextData: entrepreneurId,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Demande acceptée avec succès.')),
        );
        _fetchDemandes(); // Recharger la liste
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'acceptation de la demande.')),
        );
      }
    }
  }

  Future<void> _refuseDemande(String demandeId, String entrepreneurId) async {
    try {
      await _firestore.collection('demandesConseils').doc(demandeId).update({'statut': 'refusée'});
      // Récupérer le token FCM de l'entrepreneur
      DocumentSnapshot entrepreneurDoc = await _firestore.collection('utilisateurs').doc(entrepreneurId).get();
      String token = entrepreneurDoc['fcmToken']; // Assurez-vous que 'fcmToken' existe dans le document


      await PushNotificationService.sendNotification(
        title: "Demande refusée",
        body: "Votre demande de conseils a été refusée.",
        token: token, // Remplacez par le token FCM de l'entrepreneur
        contextType: 'refused_request',
        contextData: entrepreneurId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Demande refusée avec succès.')),
      );
      _fetchDemandes(); // Recharger la liste
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du refus de la demande.')),
      );
    }
  }

  Future<String> _showMessageDialog() async {
    String message = '';

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text('Écrire un message', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Votre message', border: OutlineInputBorder()),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                message = controller.text;
                Navigator.of(context).pop(message);
              },
              child: Text('Envoyer'),
            ),
          ],
        );
      },
    );

    return message;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demandes de Conseils', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: demandes.length,
        itemBuilder: (context, index) {
          Demande demande = demandes[index];
          return Card(
            elevation: 4, // Ombre pour donner un effet de relief
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Coins arrondis
            ),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        demande.description,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Statut: ${demande.statut}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Divider(), // Ligne de séparation
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => _acceptDemande(demande.id, demande.entrepreneurId),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.green, // Couleur du texte
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Coins arrondis
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Espacement intérieur
                          elevation: 4, // Ombre
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check, color: Colors.white),
                            SizedBox(width: 5),
                            Text('Accepter'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _refuseDemande(demande.id, demande.entrepreneurId),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.red, // Couleur du texte
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Coins arrondis
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Espacement intérieur
                          elevation: 4, // Ombre
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.close, color: Colors.white),
                            SizedBox(width: 5),
                            Text('Refuser'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Demande {
  final String id;
  final String entrepreneurId;
  final String description;
  final String statut;

  Demande({required this.id, required this.entrepreneurId, required this.description, required this.statut});

  factory Demande.fromDocument(DocumentSnapshot doc) {
    return Demande(
      id: doc.id,
      entrepreneurId: doc['entrepreneurId'],
      description: doc['description'],
      statut: doc['statut'],
    );
  }
}
