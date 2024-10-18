import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:relationship/pages/connexion.dart';
import 'profil.dart'; // Assurez-vous d'importer votre fichier Profil.dart ici

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedLanguage = 'Français'; // Langue par défaut
  bool notificationsEnabled = true; // État des notifications

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Connexion())); // Redirection vers la page de connexion
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Langue',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedLanguage,
              items: <String>['Français', 'English', 'Español'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLanguage = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            Text(
              'Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Activer les notifications'),
                Switch(
                  value: notificationsEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Redirection vers la page de profil
                String? userId = FirebaseAuth.instance.currentUser?.uid;
                if (userId != null && userId.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profil(userId: userId)),
                  );
                } else {
                  print('Erreur : Utilisateur non connecté');
                }
              },
              child: Text('Voir le profil'),
            ),
          ],
        ),
      ),
    );
  }
}
