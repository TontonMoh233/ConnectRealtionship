import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ModiferProfilEntrepreneur.dart';

class Profil extends StatelessWidget {
  final String userId;

  const Profil({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil de l'utilisateur"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('utilisateurs').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erreur lors du chargement du profil : ${snapshot.error}"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("Utilisateur non trouvé ou aucune donnée disponible"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView( // Ajout du SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo de profil
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(userData['photoUrl'] ?? 'https://via.placeholder.com/150'), // URL par défaut si pas d'image
                    ),
                  ),
                  SizedBox(height: 20),

                  // Champ pour le nom
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: TextEditingController(text: userData['nom'] ?? 'Non disponible'),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Nom",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Arrondi
                        ),
                        prefixIcon: Icon(Icons.person), // Icône pour le nom
                      ),
                    ),
                  ),

                  // Champ pour le prénom
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: TextEditingController(text: userData['prenom'] ?? 'Non disponible'),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Prénom",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Arrondi
                        ),
                        prefixIcon: Icon(Icons.person_outline), // Icône pour le prénom
                      ),
                    ),
                  ),

                  // Champ pour l'email
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: TextEditingController(text: userData['email'] ?? 'Non disponible'),
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Arrondi
                        ),
                        prefixIcon: Icon(Icons.email), // Icône pour l'email
                      ),
                    ),
                  ),

                  // Bouton pour éditer le profil
                  Center(
                    child: SizedBox(
                      width: double.infinity, // Prend toute la largeur disponible
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfil(userId: userId),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15), // Augmente la hauteur du bouton
                          child: Text(
                            "Éditer le profil",
                            style: TextStyle(fontSize: 18), // Augmente la taille du texte
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange, // Couleur de fond
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Arrondi du bouton
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
