import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'AffichageDepense.dart';
import 'ServiceNotify.dart';

class FinanceProjet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projets financés'),
      ),
      body: _buildFinancedProjectsList(),
    );
  }

  // Méthode pour récupérer et afficher les projets financés
  Widget _buildFinancedProjectsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('investissements').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Aucun investissement trouvé.'));
        }

        final investments = snapshot.data!.docs;

        return ListView.builder(
          itemCount: investments.length,
          itemBuilder: (context, index) {
            final investment = investments[index];
            final projectId = investment['projetId'];

            // Vérifiez si le champ projectId est bien renseigné
            if (projectId == null) {
              return Center(child: Text('ID de projet non disponible.'));
            }

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('projet').doc(projectId).get(),
              builder: (context, projectSnapshot) {
                if (projectSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (projectSnapshot.hasError) {
                  return Center(child: Text('Erreur lors du chargement du projet : ${projectSnapshot.error}'));
                }

                if (!projectSnapshot.hasData || !projectSnapshot.data!.exists) {
                  return Center(child: Text('Projet non trouvé.'));
                }

                final projectData = projectSnapshot.data!.data() as Map<String, dynamic>;
                final projectName = projectData['titre'] ?? 'Nom du projet non disponible';

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(projectName),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _showAddExpenseDialog(context, projectId);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectExpensesPage(projectId: projectId, projectName: projectName),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // Méthode pour afficher le dialogue d'ajout de dépense
  void _showAddExpenseDialog(BuildContext context, String projectId) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter une dépense'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Montant'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                ListTile(
                  title: Text('Date : ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      selectedDate = pickedDate;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _addExpense(context, projectId, amountController.text, descriptionController.text, selectedDate);
                Navigator.of(context).pop();
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }


  // Méthode pour ajouter une dépense à Firestore et notifier l'investisseur
  Future<void> _addExpense(
      BuildContext context,
      String projectId,
      String amount,
      String description,
      DateTime date,
      ) async {
    try {
      // Ajouter la dépense dans Firestore
      await FirebaseFirestore.instance.collection('projet').doc(projectId).collection('depenses').add({
        'montant': double.tryParse(amount) ?? 0,
        'description': description,
        'date': date,
        'projetId': projectId, // Ajout du projetId ici
      });

      // Rechercher les investisseurs associés au projet
      final investmentSnapshot = await FirebaseFirestore.instance
          .collection('investissements')
          .where('projetId', isEqualTo: projectId)
          .get();

      if (investmentSnapshot.docs.isNotEmpty) {
        for (var investmentDoc in investmentSnapshot.docs) {
          final investmentData = investmentDoc.data();
          final investorId = investmentData['investisseursId'];

          // Vérification de la présence de l'investisseurId
          if (investorId == null) {
            print('investisseurId non disponible pour l\'investissement : ${investmentDoc.id}');
            continue;
          }

          // Récupérer le document de l'investisseur
          final investorDoc = await FirebaseFirestore.instance.collection('utilisateurs').doc(investorId).get();
          if (!investorDoc.exists) {
            print('Investisseur non trouvé : $investorId');
            continue;
          }

          // Récupérer le token de notification
          final investorData = investorDoc.data() as Map<String, dynamic>?;
          final investorToken = investorData?['fcmToken'];

          if (investorToken != null && investorToken.isNotEmpty) {
            // Envoyer la notification à l'investisseur
            await PushNotificationService.sendNotification(
              title: 'Nouvelle dépense ajoutée',
              body: 'Une nouvelle dépense a été ajoutée au projet ${investmentData['titre'] ?? 'Inconnu'}.',
              token: investorToken,
              contextType: 'expense',
              contextData: projectId,
            );
            print('Notification envoyée à l\'investisseur : $investorId');

            // Ajouter la notification dans la collection 'notification_investisseur'
            await FirebaseFirestore.instance.collection('notification_investisseur').add({
              'investisseurId': investorId,
              'titre': 'Nouvelle dépense ajoutée',
              'message': 'Une nouvelle dépense a été ajoutée au projet ${investmentData['titre'] ?? 'Inconnu'}.',
              'timestamp': DateTime.now(),
              'projetId': projectId,
              'read': false, // Marquer la notification comme non lue par défaut
            });
            print('Notification ajoutée à Firestore pour l\'investisseur : $investorId');
          } else {
            print('Le token de notification de l\'investisseur est vide ou non trouvé : $investorId');
          }
        }
      } else {
        print('Aucun investisseur associé trouvé pour ce projet : $projectId');
      }

      // Ajouter une notification pour l'entrepreneur (si besoin)
      // Récupérer l'ID de l'entrepreneur du projet
      final projectDoc = await FirebaseFirestore.instance.collection('projet').doc(projectId).get();
      final entrepreneurId = projectDoc.data()?['entrepreneurId'];

      if (entrepreneurId != null) {
        // Ajouter la notification dans la collection 'notification_entrepreneur'
        await FirebaseFirestore.instance.collection('notification_entrepreneur').add({
          'entrepreneurId': entrepreneurId,
          'titre': 'Nouvelle dépense ajoutée à votre projet',
          'message': 'Une dépense a été ajoutée à votre projet ${projectDoc.data()?['titre'] ?? 'Inconnu'}.',
          'timestamp': DateTime.now(),
          'projetId': projectId,
          'read': false, // Marquer la notification comme non lue par défaut
        });
        print('Notification ajoutée à Firestore pour l\'entrepreneur : $entrepreneurId');
      } else {
        print('L\'entrepreneur pour ce projet n\'a pas été trouvé : $projectId');
      }
    } catch (e) {
      print('Erreur lors de l\'ajout de la dépense ou de l\'envoi de la notification : $e');
    }
  }



}
