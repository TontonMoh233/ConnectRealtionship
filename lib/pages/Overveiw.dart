import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vue d\'ensemble',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          // Affichage des statistiques
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DashboardCard(
                title: 'Utilisateurs',
                value: '150',
                icon: Icons.people,
                color: Colors.blue,
              ),
              DashboardCard(
                title: 'Projets',
                value: '30',
                icon: Icons.work,
                color: Colors.green,
              ),
              DashboardCard(
                title: 'Demandes',
                value: '10',
                icon: Icons.request_page,
                color: Colors.orange,
              ),
            ],
          ),
          SizedBox(height: 16.0),
          // Ajouter d'autres graphiques ou widgets
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  DashboardCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width / 3 - 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8.0),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
