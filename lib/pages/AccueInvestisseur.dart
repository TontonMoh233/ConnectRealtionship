import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importez ce package
import 'package:relationship/pages/Profil.dart';
import 'package:relationship/pages/rechercherInvestisseur.dart';
import 'Accueil.dart';
import 'AjouterUnProjet.dart';
import 'DepenseInvestisseur.dart';
import 'IdeeDeProjet.dart';
import 'InvestisseurProjet.dart';
import 'NotificationInvesstisseur.dart';
import 'ProjetEnCour.dart';
import 'SettingsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PageAccyeilInvesstisseur extends StatefulWidget {
  const PageAccyeilInvesstisseur({super.key});

  @override
  State<PageAccyeilInvesstisseur> createState() => _PageAccyeilInvesstisseurState();
}

class _PageAccyeilInvesstisseurState extends State<PageAccyeilInvesstisseur> {
  String? investorId = FirebaseAuth.instance.currentUser?.uid;
  String? photoUrl; // Variable pour stocker l'URL de la photo de profil

  @override
  void initState() {
    super.initState();
    _fetchUserProfile(); // Récupérer les données de l'utilisateur lors de l'initialisation
  }

  Future<void> _fetchUserProfile() async {
    if (investorId!= null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('utilisateurs')
          .doc(investorId)
          .get();

      if (userData.exists) {
        setState(() {
          photoUrl = userData['photoUrl']; // Assurez-vous que le champ 'photoUrl' existe dans votre Firestore
        });
      }
    }
  }

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
          IconButton(
            icon: Icon(
              Icons.notification_important_rounded,
              color: Colors.orange,
              size: 25,
            ),
            onPressed: () {
              // Navigation vers la page des notifications
              // Récupération de l'ID


              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvestorNotificationsPage(
                    investorId: investorId!,// Remplacez par l'ID de l'investisseur réel
                  ),
                ),
              );
            },
          ),

          Icon(
            Icons.more_vert,
            color: Colors.orange.withOpacity(.7),
            size: 25,
          ),
        ],
      ),

      body: InvestorDashboard(),

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
              onTap: () {
                _navigateWithFadeTransition(context, InvestorDashboard());
              },
              child: ListTile(
                leading: Icon(Icons.add, color: Colors.redAccent),
                title: Text(
                  "Rechercher un projet",
                  style: TextStyle(color: Colors.blue),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            InkWell(
              onTap: () {
                if (investorId!= null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvestorProjectsPage(investisseurId: investorId!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('L\'identifiant de l\'investisseur est introuvable.')),
                  );
                }
              },
              child: ListTile(
                leading: Icon(Icons.attach_money_outlined, color: Colors.redAccent),
                title: Text(
                  "Voir depenses",
                  style: TextStyle(color: Colors.blue),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),

            InkWell(
                onTap: () {
                  if (investorId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InvestorNotificationsPage(
                          investorId: investorId!,
                        ),
                      ),
                    );
                  } else {
                    // Gérer le cas où investorId est null, par exemple :
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('ID d\'investisseur introuvable.')),
                    );
                  }
                },

                child: ListTile(
                leading: Icon(Icons.notification_important_rounded, color: Colors.redAccent),
                title: Text(
                  "Notification",
                  style: TextStyle(color: Colors.blue),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
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
                        String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                        if (userId.isNotEmpty) {
                          _navigateWithFadeTransition(context, Profil(userId: userId));
                        } else {
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
    );
  }

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
