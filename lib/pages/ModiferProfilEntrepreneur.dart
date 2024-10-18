import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfil extends StatefulWidget {
  final String userId;

  const EditProfil({super.key, required this.userId});

  @override
  _EditProfilState createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _biographieController = TextEditingController();
  final TextEditingController _secteurController = TextEditingController();
  final TextEditingController _localiteController = TextEditingController();

  String? _photoUrl;

  void _showConfirmationDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.topSlide,
      title: 'Profil Édité',
      desc: 'Votre profil a bien été édité avec succès.',
      btnOkOnPress: () {
        Navigator.pop(context); // Retourner à la page précédente
      },
    ).show();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _photoUrl = image.path; // Utilisez la méthode que vous avez pour télécharger l'image
      });
    }
  }

  Future<void> _saveProfile() async {
    await FirebaseFirestore.instance.collection('utilisateurs').doc(widget.userId).update({
      'nom': _nomController.text,
      'prenom': _prenomController.text,
      'email': _emailController.text,
      'biographie': _biographieController.text,
      'secteur': _secteurController.text,
      'localite': _localiteController.text,
      // Vous devez gérer l'upload de l'image ici si nécessaire
      'photoUrl': _photoUrl ?? '', // Si une nouvelle photo est sélectionnée
    });
    _showConfirmationDialog(); // Afficher le dialogue après la mise à jour
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance.collection('utilisateurs').doc(widget.userId).get();
    if (userData.exists) {
      var data = userData.data() as Map<String, dynamic>;
      _nomController.text = data['nom'] ?? '';
      _prenomController.text = data['prenom'] ?? '';
      _emailController.text = data['email'] ?? '';
      _biographieController.text = data['biographie'] ?? '';
      _secteurController.text = data['secteur'] ?? '';
      _localiteController.text = data['localite'] ?? '';
      _photoUrl = data['photoUrl'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Éditer le profil"),
      ),
      body: SingleChildScrollView( // Ajout de SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo de profil
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _photoUrl != null ? FileImage(File(_photoUrl!)) : NetworkImage('https://via.placeholder.com/150') as ImageProvider<Object>,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Champ pour le nom
            TextField(
              controller: _nomController,
              decoration: InputDecoration(
                labelText: "Nom",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10),

            // Champ pour le prénom
            TextField(
              controller: _prenomController,
              decoration: InputDecoration(
                labelText: "Prénom",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            SizedBox(height: 10),

            // Champ pour l'email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 10),

            // Champ pour la biographie
            TextField(
              controller: _biographieController,
              decoration: InputDecoration(
                labelText: "Biographie",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.info),
              ),
            ),
            SizedBox(height: 10),

            // Champ pour le secteur d'activité
            TextField(
              controller: _secteurController,
              decoration: InputDecoration(
                labelText: "Secteur d'activité",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.business),
              ),
            ),
            SizedBox(height: 10),

            // Champ pour la localité
            TextField(
              controller: _localiteController,
              decoration: InputDecoration(
                labelText: "Localité",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            SizedBox(height: 20),

            // Bouton pour sauvegarder les modifications
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "Sauvegarder",
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
  }
}
