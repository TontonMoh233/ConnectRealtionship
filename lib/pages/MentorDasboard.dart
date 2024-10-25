import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relationship/pages/Profil.dart';

import 'ListeDemandePourMentor.dart';
import 'NotificationMentorPAge.dart';

class MentorHomePage extends StatelessWidget {
  final String username; // Nom de l'utilisateur connecté

  MentorHomePage({required this.username}); // Constructeur pour recevoir le nom d'utilisateur

  @override
  Widget build(BuildContext context) {
    // Récupérer l'utilisateur connecté
    User? user = FirebaseAuth.instance.currentUser;

    // Vérifiez si l'utilisateur est connecté
    if (user == null) {
      return Center(child: Text("Utilisateur non connecté"));
    }

    String username = user.displayName ?? user.email ?? 'Utilisateur';
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil du Mentor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Message de bienvenue
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Bienvenue, $username !',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2, // Deux colonnes pour la disposition des cartes
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: <Widget>[
                  HomeCard(
                    title: 'Voir les Demandes',
                    icon: Icons.list,
                    onTap: () {
                      // Naviguer vers la liste des demandes de conseils
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListeDemandesPage(),
                        ),
                      );

                    },
                  ),
                  HomeCard(
                    title: 'Mes Conseils',
                    icon: Icons.book,
                    onTap: () {
                      // Naviguer vers la liste des conseils donnés
                      Navigator.pushNamed(context, '/mesConseils');
                    },
                  ),
                  HomeCard(
                    title: 'Gérer les Notifications',
                    icon: Icons.notifications,
                    onTap: () {
                      // Naviguer vers la page des notifications
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationsMentorPage (),
                        ),
                      );
                    },
                  ),
                  HomeCard(
                    title: 'Mon Profil',
                    icon: Icons.person,
                    onTap: () {
                      // Naviguer vers la page de profil du mentor
                      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profil(userId: userId),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const HomeCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 50.0,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 10.0),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
