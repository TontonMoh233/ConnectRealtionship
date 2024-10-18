import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'ModificationProjet.dart';

class Projetencour extends StatefulWidget {
  const Projetencour({super.key});

  @override
  State<Projetencour> createState() => _ProjetencourState();
}

class _ProjetencourState extends State<Projetencour> {

  // Creation de la methode pour Supprimer un projet
 Future<void>deletprojet(projetId) async{

      try{
        await FirebaseFirestore.instance.collection('projet').doc(projetId).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Projet Supprimer Avec Succés"),),);

      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur lors de la suppression du projeyt $e"),));
      }


  }

  // creation de la methode pour modifier un prpojet


 void editProject(String projectId, String titre, String description, double objectifFinancer, String secteur) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ModifierProjet(
            projectId: projectId,
            titre: titre,
            description: description,
            objectifFinancer: objectifFinancer,
            secteur: secteur,
          ),
        ),
      );
    }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Projets En Cours",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('projet')
            .where('status', isEqualTo: 'en cours')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Erreur lors du chargement des projets"),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Aucun projet en cours"),
            );
          }

          // Récupération des données depuis Firestore
          final projets = snapshot.data!.docs;

          return ListView.builder(
            itemCount: projets.length,
            itemBuilder: (context, index) {
              // Accéder aux données du projet
              final projet = projets[index];
              final titre = projet['titre'];
              final description = projet['description'];
              final objectifFinancer = projet['objectifFinancer'];
              final secteur = projet['secteur'];
              final dateCreation = (projet['dateCreation'] as Timestamp).toDate();
              final projeId = projet.id;// obtenir l'idee du projet

              // Affichage dans une carte
              return Container(
                padding: EdgeInsets.all(10),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(8),
                 ),
                child: Card(
                  elevation:  10,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(titre),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Description : $description"),
                        Text("Secteur : $secteur"),
                        Text("Objectif Financier : $objectifFinancer"),
                        Text("Date de création : ${dateCreation.toLocal()}"),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(

                            onPressed:()=>editProject(projeId,titre,description, objectifFinancer, secteur),
                            tooltip: 'Modifier',


                            icon: Icon(Icons.edit)),



                        IconButton(
                            onPressed:() => deletprojet(projeId),
                            tooltip: 'Supprimer',// methode de suppression du projet
                            icon: Icon(Icons.delete)),


                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

