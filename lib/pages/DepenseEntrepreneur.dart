import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'AffichageDepense.dart';
import 'ServiceNotify.dart';

class FinancedProjectsPage extends StatelessWidget {
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

        final investments = snapshot.data!.docs;

        return ListView.builder(
          itemCount: investments.length,
          itemBuilder: (context, index) {
            final investment = investments[index];
            final projectId = investment['projetId'];

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('projet').doc(projectId).get(),
              builder: (context, projectSnapshot) {
                if (projectSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (projectSnapshot.hasError || !projectSnapshot.hasData || !projectSnapshot.data!.exists) {
                  return Center(child: Text('Projet non trouvé ou erreur.'));
                }

                final projectData = projectSnapshot.data!.data() as Map<String, dynamic>;
                final projectName = projectData['titre'];


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

  // Méthode pour ajouter une dépense à Firestore
  Future<void> _addExpense(BuildContext context, String projectId, String amount, String description, DateTime date) async {
    try {
      // Ajouter la dépense à la collection 'depenses' sous le document du projet
      await FirebaseFirestore.instance
          .collection('projet') // Collection principale
          .doc(projectId) // Document du projet
          .collection('depenses') // Sous-collection 'depenses'
          .add({ // Ajouter les données de la dépense
        'montant': double.tryParse(amount) ?? 0, // Conversion du montant en double
        'description': description, // Description de la dépense
        'date': date, // Date de la dépense
      });
      // Récupérer l'investisseur associé au projet (exemple d'implémentation)
      final projectDoc = await FirebaseFirestore.instance.collection('projet').doc(projectId).get();
      final projectData = projectDoc.data() as Map<String, dynamic>;
      final investorId = projectData['investisseurId']; // Assurez-vous que le champ est correct

      // Récupérer le token de notification de l'investisseur
      final investorDoc = await FirebaseFirestore.instance.collection('utilisateurs').doc(investorId).get();
      final investorData = investorDoc.data() as Map<String, dynamic>;
      final investorToken = investorData['fcmToken']; // Assurez-vous que le champ est correct

      if (investorToken != null && investorToken.isNotEmpty) {
        // Envoyer la notification à l'investisseur
        await PushNotificationService.sendNotification(
          title: 'Nouvelle dépense ajoutée',
          body: 'Une nouvelle dépense a été ajoutée au projet ${projectData['titre']}.',
          token: investorToken,
          contextType: 'expense',
          contextData: projectId,
        );

        print('Notification envoyée à l\'investisseur.');
      } else {
        print('Le token de notification de l\'investisseur est vide ou non trouvé.');
      }

      // Si l'ajout est réussi, vous pouvez ajouter d'autres actions ici
      print('Dépense ajoutée avec succès.');
    } catch (e) {
      // Gérer l'erreur en cas d'échec de l'ajout
      print('Erreur lors de l\'ajout de la dépense : $e');
    }



  }
}
