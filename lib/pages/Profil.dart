import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

          return SingleChildScrollView(
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

                  // Bouton pour changer la photo de profil
                  Center(
                    child: ElevatedButton(
                      onPressed: () => _changeProfilePicture(context, userId),
                      child: Text("Changer la photo de profil"),
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
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: Icon(Icons.person),
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
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: Icon(Icons.person_outline),
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
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                  ),

                  // Bouton pour éditer le profil
                  Center(
                    child: SizedBox(
                      width: double.infinity,
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
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Éditer le profil",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
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

  // Méthode pour changer la photo de profil
  Future<void> _changeProfilePicture(BuildContext context, String userId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      Reference ref = FirebaseStorage.instance.ref().child('profile_images/$userId/${pickedFile.name}');

      try {
        UploadTask uploadTask = ref.putFile(file);
        TaskSnapshot snapshot = await uploadTask;

        // Récupérer l'URL de l'image
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Mettre à jour l'URL de la photo de profil dans Firestore
        await FirebaseFirestore.instance.collection('utilisateurs').doc(userId).update({
          'photoUrl': downloadUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Photo de profil mise à jour avec succès !")));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur lors du téléchargement de l'image : $e")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Aucune image sélectionnée")));
    }
  }
}
