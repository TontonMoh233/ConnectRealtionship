import 'package:date_field/date_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relationship/Modele/Utilisateurs.dart';
import 'package:relationship/pages/ProjetServices.dart';
import 'package:relationship/pages/Services_authentication.dart';

class AjouterProjet extends StatefulWidget {
  const AjouterProjet({super.key});

  @override
  State<AjouterProjet> createState() => _AjouterProjetState();
}

class _AjouterProjetState extends State<AjouterProjet> {
  // Déclaration de global key pour récupérer les données de chaque champ
  final _formkey = GlobalKey<FormState>();
  ProjetMethods methods = ProjetMethods();
  Utilisateur? curentuser;
  final Autentification autentificationService = Autentification();
  final projetcontroller = TextEditingController();
  final descontroller = TextEditingController();

  String selectsecteur = "santé";
  String selectstatut = "en_attente";
  double selectobjectfinacer = 500000;
  DateTime selectedDate = DateTime.now();
  // methodes pour nettoyer le formulaire apres l'ajout dans firestore
   void resetform(){
      projetcontroller.clear();
      descontroller.clear();
      setState(() {
        selectsecteur ="santé";
        selectstatut = "en_attente";
        selectobjectfinacer = 500000;
      });




   }

  // Méthode pour récupérer l'utilisateur connecté
  void fetchcurrentuser() async {
    try {
      User? user = await autentificationService.getuserconnecter();
      if (user != null) {
        setState(() {
          curentuser = Utilisateur(
            id: user.uid,
            email: user.email,
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la récupération de l'utilisateur.")),
      );
    }
  }

  // Méthode pour la création d'un nouveau projet
  Future<void> CreerMonNouveauProjet() async {
    if (curentuser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur : Utilisateur non connecté")),
      );
      return;
    }

    try {
      await methods.creerProjet(
        entrepreneurId: curentuser!.id,
        titre: projetcontroller.text,
        description: descontroller.text,
        objectifFinancer: selectobjectfinacer,
        status: selectstatut,
        dateCreation: selectedDate,
        secteur: selectsecteur,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Projet créé avec succès !")),
      );
      methods.showConfirmationDialog(context);
       resetform();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la création du projet : $e")),
      );
    }
  }

  @override
  void dispose() {
    projetcontroller.dispose();
    descontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchcurrentuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter Un Projet"),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              // Champ Titre du Projet
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  controller: projetcontroller,
                  decoration: InputDecoration(
                    labelText: "Titre du Projet",
                    hintText: "Entrez le titre du projet",
                    hintStyle: const TextStyle(fontSize: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Tu dois compléter ce champ";
                    }
                    return null;
                  },
                ),
              ),
              // Dropdown pour le secteur d'activité
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Secteur d'activité",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'agriculture', child: Text("AGRICULTURE")),
                    DropdownMenuItem(value: 'santé', child: Text("SANTÉ")),
                    DropdownMenuItem(value: 'education', child: Text("ÉDUCATION")),
                    DropdownMenuItem(value: 'technologie', child: Text("TECHNOLOGIE")),
                    DropdownMenuItem(value: 'elevage', child: Text("ÉLEVAGE")),
                  ],
                  value: selectsecteur,
                  onChanged: (value) {
                    setState(() {
                      selectsecteur = value!;
                    });
                  },
                ),
              ),
              // Dropdown pour l'objectif financier
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: DropdownButtonFormField<double>(
                  decoration: InputDecoration(
                    labelText: "Objectif Financier",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 500000.0, child: Text("500 000")),
                    DropdownMenuItem(value: 1000000.0, child: Text("1 000 000")),
                    DropdownMenuItem(value: 4000000.0, child: Text("4 000 000")),
                    DropdownMenuItem(value: 10000000.0, child: Text("10 000 000")),
                    DropdownMenuItem(value: 20000000.0, child: Text("20 000 000")),
                  ],
                  value: selectobjectfinacer,
                  onChanged: (value) {
                    setState(() {
                      selectobjectfinacer = value!;
                    });
                  },
                ),
              ),
              // Dropdown pour le statut
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Statut",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'en_attente', child: Text("ATTENTE")),
                    DropdownMenuItem(value: 'financé', child: Text("FINANCÉ")),
                    DropdownMenuItem(value: 'en attente', child: Text("EN ATTENTE")),
                  ],
                  value: selectstatut,
                  onChanged: (value) {
                    setState(() {
                      selectstatut = value!;
                    });
                  },
                ),
              ),
              // Sélection de la date
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: DateTimeFormField(
                  decoration: const InputDecoration(
                    labelText: 'Choisir une date',
                  ),
                  firstDate: DateTime.now(),
                  initialValue: selectedDate,
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  onChanged: (DateTime? value) {
                    setState(() {
                      if (value != null) selectedDate = value;
                    });
                  },
                ),
              ),
              // Champ de description
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  maxLines: 3,
                  controller: descontroller,
                  decoration: InputDecoration(
                    labelText: "Description du projet",
                    hintText: "Décrivez le projet en quelques mots",
                    hintStyle: const TextStyle(fontSize: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Tu dois compléter ce champ";
                    }
                    return null;
                  },
                ),
              ),
              // Bouton pour publier
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      await CreerMonNouveauProjet();
                    }
                  },
                  child: const Text("Publier"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
