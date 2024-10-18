import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Nombre d'onglets
      child: Scaffold(
        appBar: AppBar(
          title: Text("Gestion des Utilisateurs"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Entrepreneurs"),
              Tab(text: "Investisseurs"),
              Tab(text: "Mentors"),
              Tab(text: "Donateurs"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserList(userType: "entrepreneur"),
            UserList(userType: "investisseur"),
            UserList(userType: "mentor"),
            UserList(userType: "donateur"),
          ],
        ),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  final String userType;

  UserList({required this.userType});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('utilisateurs')
          .where('type', isEqualTo: userType) // Assurez-vous que votre champ 'type' existe
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Erreur: ${snapshot.error}"));
        }

        final users = snapshot.data?.docs;

        if (users == null || users.isEmpty) {
          return Center(child: Text("Aucun utilisateur trouvé"));
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            final userData = user.data() as Map<String, dynamic>;

            return Card(
              child: ListTile(
                title: Text(userData['nom'] ?? "Nom inconnu"), // Remplacez 'nom' par votre champ
                subtitle: Text(userData['email'] ?? "Email inconnu"), // Remplacez 'email' par votre champ
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.contact_mail),
                      onPressed: () {
                        // Action pour contacter l'utilisateur
                        // Vous pouvez naviguer vers une page de contact ou ouvrir un e-mail
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // Action pour supprimer l'utilisateur
                        FirebaseFirestore.instance.collection('utilisateurs').doc(user.id).delete();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
