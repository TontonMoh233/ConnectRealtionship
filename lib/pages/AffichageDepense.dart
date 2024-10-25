import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProjectExpensesPage extends StatelessWidget {
  final String projectId;
  final String projectName;

  const ProjectExpensesPage({super.key, required this.projectId, required this.projectName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dépenses pour $projectName'),
      ),
      body: _buildExpensesList(),
    );
  }

  // Méthode pour récupérer et afficher la liste des dépenses du projet
  Widget _buildExpensesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('projet')
          .doc(projectId)
          .collection('depenses')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Aucune dépense ajoutée pour ce projet.'));
        }

        final expenses = snapshot.data!.docs;

        return ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            final amount = expense['montant'];
            final description = expense['description'];
            final date = (expense['date'] as Timestamp).toDate();

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(description),
                subtitle: Text('Montant : ${amount.toStringAsFixed(2)} €\nDate : ${DateFormat('yyyy-MM-dd').format(date)}'),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }
}
