import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Utilisateurs'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('utilisateurs').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return ListTile(
                title: Text(user['name'] ?? 'Sans Nom'),
                subtitle: Text(user['email'] ?? 'Sans Email'),
                trailing: Text(user['role'] ?? 'Rôle Inconnu'),
                onTap: () {
                  // Afficher les détails de l'utilisateur
                },
              );
            },
          );
        },
      ),
    );
  }
}
