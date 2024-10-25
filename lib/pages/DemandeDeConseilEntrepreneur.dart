import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'ServiceNotify.dart'; // Ajoutez cette ligne pour FCM

class Mentor {
  final String id;
  final String nom;
  final String token; // Token FCM pour le mentor

  Mentor({required this.id, required this.nom, required this.token});

  factory Mentor.fromDocument(DocumentSnapshot doc) {
    return Mentor(
      id: doc.id,
      nom: doc['nom'] ?? 'Nom Inconnu',
      token: doc['fcmToken'] ?? '', // Assurez-vous que le token est bien stocké dans Firestore
    );
  }
}

class DemandeConseilsPage extends StatefulWidget {
  @override
  DemandeConseilsPageState createState() => DemandeConseilsPageState();
}

class DemandeConseilsPageState extends State<DemandeConseilsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _descriptionController = TextEditingController();
  String? selectedMentorId;
  List<Mentor> mentors = [];
  bool isLoadingMentors = true;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchMentors();
  }

  Future<void> _fetchMentors() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('utilisateurs')
          .where('role', isEqualTo: 'mentor')
          .get();
      setState(() {
        mentors = querySnapshot.docs.map((doc) => Mentor.fromDocument(doc)).toList();
        isLoadingMentors = false;
      });
    } catch (e) {
      setState(() {
        isLoadingMentors = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des mentors.')),
      );
    }
  }

  Future<void> _submitDemande() async {
    if (_descriptionController.text.isNotEmpty && selectedMentorId != null) {
      setState(() {
        isSubmitting = true;
      });

      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          String entrepreneurId = user.uid;
          Mentor selectedMentor = mentors.firstWhere((mentor) => mentor.id == selectedMentorId);

          DocumentReference demandeRef = await _firestore.collection('demandesConseils').add({
            'entrepreneurId': entrepreneurId,
            'mentorId': selectedMentorId,
            'description': _descriptionController.text,
            'date': FieldValue.serverTimestamp(),
            'statut': 'en attente',
          });

          DocumentSnapshot mentorSnapshot = await _firestore.collection('utilisateurs').doc(selectedMentorId).get();
          String mentorToken = mentorSnapshot['fcmToken'];

          await PushNotificationService.sendNotification(
              title: "Nouvelle demande",
              body: "Vous venez de recevoir une demande de conseil par un mentor",
              token: mentorToken,
              contextType: 'expense',
              contextData: entrepreneurId
          );

          await _firestore.collection('notification_mentor').add({
            'mentorId': selectedMentorId,
            'demandeId': demandeRef.id,
            'message': 'Un entrepreneur a soumis une nouvelle demande de conseils.',
            'date': FieldValue.serverTimestamp(),
            'lu': false,
          });

          _descriptionController.clear();
          setState(() {
            selectedMentorId = null;
            isSubmitting = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Demande de conseils soumise avec succès.')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Aucun utilisateur connecté.')),
          );
        }
      } catch (e) {
        setState(() {
          isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la soumission de la demande.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer une description et sélectionner un mentor.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demande de Conseils'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoadingMentors
            ? Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // Champ de texte avec un style moderne
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Décrivez votre demande',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
                hintText: 'Entrez votre description ici...',
                hintStyle: TextStyle(color: Colors.grey[500]),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20),
            // Menu déroulant pour sélectionner un mentor
            DropdownButtonFormField<String>(
              value: selectedMentorId,
              hint: Text('Sélectionner un mentor'),
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  selectedMentorId = value;
                });
              },
              items: mentors.map((mentor) {
                return DropdownMenuItem<String>(
                  value: mentor.id,
                  child: Text(mentor.nom),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
                filled: true,
                fillColor: Colors.blue[50],
              ),
            ),
            SizedBox(height: 20),
            // Bouton d'envoi avec un style attrayant
            ElevatedButton(
              onPressed: isSubmitting ? null : _submitDemande,
              child: isSubmitting
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : Text('Soumettre la Demande',style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
