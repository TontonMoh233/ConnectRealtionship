import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relationship/pages/Profil.dart';
import 'package:relationship/pages/rechercherInvestisseur.dart';
import 'Accueil.dart';
import 'AjouterDepense.dart';
import 'AjouterUnProjet.dart';
import 'DemandeDeConseilEntrepreneur.dart';
import 'IdeeDeProjet.dart';
import 'ProjetEnCour.dart';
import 'SettingsPage.dart';

class Accueilentrepreneur extends StatefulWidget {
  const Accueilentrepreneur({super.key});

  @override
  State<Accueilentrepreneur> createState() => _AccueilentrepreneurState();
}

class _AccueilentrepreneurState extends State<Accueilentrepreneur> {
  String? photoUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        title: const Text(
          "Bienvenue",
          style: TextStyle(
              color: Colors.orange, fontSize: 30, fontWeight: FontWeight.w300),
          textAlign: TextAlign.center,
        ),
        actions: [
          Icon(
            Icons.notification_important_rounded,
            color: Colors.orange,
            size: 25,
          ),
          Icon(
            Icons.more_vert,
            color: Colors.orange.withOpacity(.7),
            size: 25,
          ),
        ],
      ),
      body: Projetencour(),

      drawer: Drawer(
        shadowColor: Colors.deepOrange,
        child: ListView(
          children: [
            DrawerHeader(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/images/img.png",
                    height: 60,
                  ),
                  CircleAvatar(
                    backgroundImage: photoUrl != null
                        ? NetworkImage(photoUrl!) // Affiche l'image de profil si disponible
                        : AssetImage("assets/images/avatar.jpg") as ImageProvider, // Image par défaut
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
              },
              child: ListTile(
                leading: Icon(
                  Icons.home,
                  color: Colors.redAccent,
                ),
                title: Text(
                  "Accueil",
                  style: TextStyle(color: Colors.blue),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            InkWell(
              onTap: () {
                _navigateWithFadeTransition(context, AjouterProjet());
              },
              child: ListTile(
                leading: Icon(Icons.add, color: Colors.redAccent),
                title: Text(
                  "Ajouter Un Projet",
                  style: TextStyle(color: Colors.blue),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            InkWell(
              onTap: () {
                _navigateWithFadeTransition(context, RechercheInvestisseurs());
              },
              child: ListTile(
                leading: Icon(Icons.attach_money_outlined, color: Colors.redAccent),
                title: Text(
                  "Investisseur",
                  style: TextStyle(color: Colors.blue),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            InkWell(
              onTap: () {
                _navigateWithFadeTransition(context, Projetencour());
              },
              child: ListTile(
                leading: Icon(Icons.auto_graph, color: Colors.redAccent),
                title: Text(
                  "Projet En Cour",
                  style: TextStyle(color: Colors.blue),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            InkWell(
              onTap: () {
                _navigateWithFadeTransition(context, FinanceProjet());
              },
              child: ListTile(
                leading: Icon(Icons.auto_graph, color: Colors.redAccent),
                title: Text(
                  "Ajouter Depenses",
                  style: TextStyle(color: Colors.blue),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            InkWell(
              onTap: () {
                _navigateWithFadeTransition(context, DemandeConseilsPage());
              },
              child: ListTile(
                leading: Icon(Icons.question_mark, color: Colors.redAccent),
                title: Text(
                  "Demande conseils",
                  style: TextStyle(color: Colors.blue),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message, color: Colors.redAccent),
              title: Text(
                "Messages",
                style: TextStyle(color: Colors.blue),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsPage()));
              },
              child: Container(
                margin: EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.settings, color: Colors.redAccent),
                      title: const Text(
                        "Parametres",
                        style: TextStyle(color: Colors.blue),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios_outlined),
                    ),
                    InkWell(
                      onTap: () {
                        // Remplacez par l'ID de l'utilisateur connecté
                        String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

                        if (userId.isNotEmpty) {
                          _navigateWithFadeTransition(context, Profil(userId: userId));
                        } else {
                          // Gérez le cas où l'utilisateur n'est pas connecté ou l'ID n'est pas disponible
                          print('Erreur : Utilisateur non connecté');
                        }
                      },
                      child: ListTile(
                        leading: Icon(Icons.account_circle, color: Colors.redAccent),
                        title: const Text(
                          "Profil",
                          style: TextStyle(color: Colors.blue),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AjouterProjet()));

        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
      ),
    );
  }

  // Méthode pour ajouter une animation de transition
  void _navigateWithFadeTransition(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = 0.0;
          var end = 1.0;
          var curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var opacityAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: opacityAnimation,
            child: child,
          );
        },
      ),
    );
  }
}
