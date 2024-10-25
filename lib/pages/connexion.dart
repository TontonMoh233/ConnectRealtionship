import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'AccueInvestisseur.dart';
import 'AccueilEntrepreneur.dart';
import 'AccueilMentorat.dart';
import 'inscription.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  // Contrôleurs pour les champs de texte
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Initialisation des instances Firebase
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Méthode pour récupérer le rôle de l'utilisateur
  Future<String?> getUserRole(String email, String password) async {
    try {
      // Connexion de l'utilisateur avec email et mot de passe
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Récupération du document utilisateur depuis Firestore
      DocumentSnapshot userDoc = await firestore
          .collection('utilisateurs')
          .doc(userCredential.user?.uid)
          .get();

      // Vérification de l'existence du document et retour du rôle
      if (userDoc.exists) {
        return userDoc['role'];
      } else {
        print('Document utilisateur non trouvé.');
        return null;
      }
    } catch (e) {
      print('Erreur lors de la récupération du rôle : $e');
      return null;
    }
  }

  // Méthode pour récupérer et enregistrer le token FCM
  Future<void> saveUserToken() async {
    try {
      String? token = await messaging.getToken();
      String? userId = auth.currentUser?.uid;

      if (token != null && userId != null) {
        // Enregistrement du token FCM dans le document utilisateur de Firestore
        await firestore.collection('utilisateurs').doc(userId).update({
          'fcmToken': token,
        });
        print('Token FCM enregistré avec succès.');
      } else {
        print('Impossible de récupérer le token ou l\'ID utilisateur.');
      }
    } catch (e) {
      print('Erreur lors de l\'enregistrement du token FCM : $e');
    }
  }

  // Méthode de connexion et redirection selon le rôle
  Future<void> connectionUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      print('Veuillez remplir tous les champs.');
      return;
    }

    String? userRole = await getUserRole(email, password);

    if (userRole != null) {
      // Sauvegarde du token FCM après connexion réussie
      await saveUserToken();

      // Redirection selon le rôle de l'utilisateur
      if (userRole == "entrepreneur") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Accueilentrepreneur()),
        );
      } else if (userRole == "investisseur") {
        // Ajouter la redirection pour investisseur ici
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PageAccyeilInvesstisseur()),
        );
      } else if (userRole == "donateur") {
        // Ajouter la redirection pour donateur ici
      } else if (userRole == "mentor") {
        // Ajouter la redirection pour mentor ici
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AccueilMentor()),
        );
      } else {
        print('Rôle utilisateur inconnu.');
      }
    } else {
      print('Erreur lors de la connexion ou rôle non trouvé.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(30),
            padding: EdgeInsets.only(top: 40),
            child: Form(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: SizedBox(
                      width: 80,
                      child: Image.asset("assets/images/img.png"),
                    ),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    height: 181,
                    width: 284,
                    child: Image.asset("assets/images/Computer.png"),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Bienvenue",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300, color: Colors.black),
                  ),
                  Text(
                    "Vous pouvez vous connecter",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF30606), width: 1.0),
                      ),
                      labelText: "E-mail",
                      prefixIcon: Icon(Icons.mail, color: Colors.redAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF30606), width: 1.0),
                      ),
                      labelText: "Mot de passe",
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.redAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      connectionUser();
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      alignment: Alignment.center,
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.orangeAccent,
                      ),
                      child: Text(
                        "Connecter",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Inscription(),
                        ),
                      );
                    },
                    child: Text(
                      "Vous n'avez pas de compte ? Inscrivez-vous ici",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
