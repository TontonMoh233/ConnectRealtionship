import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Autentification {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> inscriptionUser(
      String email,
      String password,
      String nom,
      String prenom,
      String role, {
        String? secteur,
        String? montantInvestissement,
        String? domaineExpertise,
        String? projet,
        String? montantDon,
        String? description,
      }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user?.uid ?? '';
      await _firestore.collection('utilisateurs').doc(uid).set({
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'password': password,
        'role': role,
        'secteur': secteur,
        'montantInvestissement': montantInvestissement,
        'domaineExpertise': domaineExpertise,
        'projet': projet,
        'montantDon': montantDon,
        'description': description, // Ajout du champ description
      });
      print("Inscription réussie avec succès");
    } on FirebaseAuthException catch (e) {
      print("Erreur lors de l'inscription ${e.message}");
    } catch (e) {
      print("Erreur $e");
    }
  }

  // Connexion avec adresse email et mot de passe
  Future<void> connection(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Déconnexion
  Future<void> deconnection() async {
    await _firebaseAuth.signOut();
  }

  // Récupération de l'utilisateur connecté
  Future<User?> getuserconnecter() async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('utilisateurs').doc(user.uid).get();
    }

    return user;
  }
}
