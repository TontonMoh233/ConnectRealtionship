import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class EntrepreneurProfilePage extends StatelessWidget {
  final String entrepreneurId;

  EntrepreneurProfilePage({required this.entrepreneurId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('utilisateurs').doc(entrepreneurId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Entrepreneur non trouvé.'));
          }

          var entrepreneurData = snapshot.data!.data() as Map<String, dynamic>;

          return Scaffold(
            appBar: AppBar(
              title: Text('${entrepreneurData['prenom'] ?? ''} ${entrepreneurData['nom'] ?? ''}'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Photo de profil en haut
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: entrepreneurData['photoUrl'] != null
                          ? NetworkImage(entrepreneurData['photoUrl'])
                          : AssetImage('assets/images/default_avatar.png') as ImageProvider,
                    ),
                    SizedBox(height: 16),
                    // Nom et prénom
                    Text(
                      '${entrepreneurData['prenom'] ?? ''} ${entrepreneurData['nom'] ?? ''}',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    // Email
                    Text(
                      'Email: ${entrepreneurData['email'] ?? 'Non spécifié'}',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    // Localité
                    Text(
                      'Localité: ${entrepreneurData['localite'] ?? 'Non spécifiée'}',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    // Rôle
                    Text(
                      'Rôle: ${entrepreneurData['role'] ?? 'Non spécifié'}',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    // Bouton pour contacter
                    ElevatedButton.icon(
                      onPressed: () {
                        // Action pour contacter l'entrepreneur
                        print("Contacter l'entrepreneur: ${entrepreneurData['email']}");
                        // Ajouter la logique pour ouvrir une page de chat ou envoyer un email
                      },
                      icon: Icon(Icons.mail),
                      label: Text('Contacter'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

