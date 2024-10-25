import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'NotificationDetailPage.dart';

class InvestorNotificationsPage extends StatelessWidget {
  final String investorId; // L'identifiant de l'investisseur

  InvestorNotificationsPage({required this.investorId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notification_investisseur')
            .where('investisseurId', isEqualTo: investorId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Vérification des erreurs
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          // Vérification si des données sont présentes
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Aucune notification disponible.'),
            );
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final notificationId = notification.id; // Récupération de l'ID de la notification
              final title = notification['titre'] ?? 'Sans titre';
              final message = notification['message'] ?? 'Pas de message';
              final timestamp = notification['timestamp'].toDate();

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.notifications,
                    color: Colors.blueAccent,
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  trailing: Text(
                    '${timestamp.day}/${timestamp.month}/${timestamp.year}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () async{
                    // Marquer la notification comme lue ou afficher plus de détails



                    // Récupération de l'ID de la notification pour mise à jour

                      // Marquer la notification comme lue dans Firestore
                      await FirebaseFirestore.instance
                          .collection('notification_investisseur')
                          .doc(notificationId)
                          .update({'lue': true}); // Ajoutez un champ "lue" dans Firestore

                      // Navigation vers une nouvelle page pour afficher les détails de la notification
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationDetailPage(notificationId: notificationId),
                        ),
                      );


                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
