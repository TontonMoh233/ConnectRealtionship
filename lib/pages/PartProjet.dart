import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminProjectsDashboard extends StatefulWidget {
  @override
  _AdminProjectsDashboardState createState() => _AdminProjectsDashboardState();
}

class _AdminProjectsDashboardState extends State<AdminProjectsDashboard> {
  final int _tabCount = 3;
  String _selectedStatus = 'en_attente';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabCount,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gestion des Projets'),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedStatus = index == 0
                    ? 'en_attente'
                    : index == 1
                    ? 'approuvé'
                    : 'refusé';
              });
            },
            tabs: [
              Tab(text: 'En attente'),
              Tab(text: 'Approuvés'),
              Tab(text: 'Refusés'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProjectList('en_attente'),
            _buildProjectList('approuvé'),
            _buildProjectList('refusé'),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('projet')
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var projets = snapshot.data!.docs;

        if (projets.isEmpty) {
          return Center(child: Text('Aucun projet $status.'));
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: projets.length,
          itemBuilder: (context, index) {
            var projet = projets[index];
            return Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      projet['titre'],
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      projet['description'],
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    // Ajouter les boutons d'approbation et de refus pour les projets en attente
                    if (status == 'en_attente')
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              // Approuver le projet
                              approuverProjet(projet.id);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              // Refuser le projet
                              refuserProjet(projet.id);
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void approuverProjet(String projetId) {
    FirebaseFirestore.instance
        .collection('projet')
        .doc(projetId)
        .update({'status': 'approuvé'}).then((_) {
      // Logique pour publier le projet
      publierProjet(projetId);
    });
  }

  void refuserProjet(String projetId) {
    FirebaseFirestore.instance
        .collection('projet')
        .doc(projetId)
        .update({'status': 'refusé'});
  }

  void publierProjet(String projetId) {
    // Logique pour publier le projet sur la plateforme
    // Cela pourrait impliquer l'ajout d'un projet dans une autre collection ou l'activation d'une visibilité
    FirebaseFirestore.instance
        .collection('publications')
        .add({
      'projetId': projetId,
      'publishedAt': Timestamp.now(),
    }).then((_) {
      print('Projet publié avec succès');
    }).catchError((error) {
      print('Erreur lors de la publication du projet: $error');
    });
  }
}
