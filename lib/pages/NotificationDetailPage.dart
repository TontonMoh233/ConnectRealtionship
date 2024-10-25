import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationDetailPage extends StatelessWidget {
  final String notificationId; // ID de la notification

  NotificationDetailPage({required this.notificationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la Notification'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('notification_investisseur')
            .doc(notificationId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Notification non trouvée.'));
          }

          final notificationData = snapshot.data!.data() as Map<String, dynamic>;
          final title = notificationData['titre'] ?? 'Sans titre';
          final message = notificationData['message'] ?? 'Pas de message';
          final timestamp = (notificationData['timestamp'] as Timestamp).toDate();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                  'Date: ${timestamp.day}/${timestamp.month}/${timestamp.year}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Action supplémentaire si nécessaire, comme retourner à la page précédente
                    Navigator.pop(context);
                  },
                  child: Text('Retour'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
