import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'ModificationProjet.dart';

class Projetencour extends StatefulWidget {
  const Projetencour({super.key});

  @override
  State<Projetencour> createState() => _ProjetencourState();
}

class _ProjetencourState extends State<Projetencour> {
  // Methode de suppression de projet
  Future<void> confirmDeletion(String projetId) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmer la suppression"),
          content: const Text("Êtes-vous sûr de vouloir supprimer ce projet ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Annuler
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirmer
              child: const Text("Supprimer"),
            ),
          ],
        );
      },
    );

    // Si l'utilisateur confirme, appelez la fonction de suppression
    if (confirm == true) {
      await deletprojet(projetId);
    }
  }

  Future<void> deletprojet(String projetId) async {
    try {
      await FirebaseFirestore.instance.collection('projet').doc(projetId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Projet supprimé avec succès")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la suppression du projet : $e")),
      );
    }
  }


  // Methode de modification de projet
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
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Color(0xFF141752),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('projet')
            .where('status', isEqualTo: 'en_attente')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Erreur lors du chargement des projets"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Aucun projet en cours"));
          }

          final projets = snapshot.data!.docs;
          return ListView.builder(
            itemCount: projets.length,
            itemBuilder: (context, index) {
              final projet = projets[index];
              final titre = projet['titre'];
              final description = projet['description'];
              final objectifFinancer = projet['objectifFinancer'];
              final secteur = projet['secteur'];
              final dateCreation = (projet['dateCreation'] as Timestamp).toDate();
              final projetId = projet.id;

              return Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Color(0xFF141752),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titre,
                          style: TextStyle(
                            color: Color(0xFFE31C57),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Secteur : $secteur",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Description : $description",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Objectif Financier : $objectifFinancer",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Créé le : ${dateCreation.toLocal()}",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => editProject(
                                      projetId, titre, description, objectifFinancer, secteur),
                                  tooltip: 'Modifier',
                                  icon: Icon(Icons.edit, color: Color(0xFFE31C57)),
                                ),
                                IconButton(
                                  onPressed: () => confirmDeletion(projetId),

                                  tooltip: 'Supprimer',
                                  icon: Icon(Icons.delete, color: Color(0xFFE31C57)),
                                ),
                              ],
                            ),
                          ],
                        ),
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
