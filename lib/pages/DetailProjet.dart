import 'package:flutter/material.dart';

class ProjectDetailPage extends StatelessWidget {
  final String titre;
  final String status;

  // Constructeur prenant le titre et le statut comme paramètres
  const ProjectDetailPage({
    Key? key,
    required this.titre,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titre),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titre,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Statut : $status",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Retourne à la page précédente
              },
              child: Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}
