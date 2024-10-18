import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'InvestissementServices.dart';
import 'ServiceNotify.dart';

class InvestorDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Recherche De Nouveaux Projets'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Projets'),
              Tab(text: 'Messages'),
              Tab(text: 'Utilisation des Fonds'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProjectsTab(),
            //MessagesTab(),
            //FundsUsageTab(),
          ],
        ),
      ),
    );
  }
}

class ProjectsTab extends StatefulWidget {
  @override
  _ProjectsTabState createState() => _ProjectsTabState();
}

class _ProjectsTabState extends State<ProjectsTab> {
  final TextEditingController searchController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String selectedSecteur = 'Tous';
  final List<String> secteurs = ['Tous', 'Technologie', 'Santé', 'Éducation', 'Agriculture', 'Élevage'];

  // Affiche la boîte de dialogue pour investir
  void _showInvestmentDialog(BuildContext context, String projectId) {
    final TextEditingController montantController = TextEditingController();
    final String? investorId = auth.currentUser?.uid;

    if (investorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vous devez être connecté pour investir.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Investir dans le projet'),
          content: TextField(
            controller: montantController,
            decoration: InputDecoration(labelText: 'Montant à investir'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                if (montantController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Veuillez entrer un montant.')),
                  );
                  return;
                }

                try {
                  int montantInvesti = int.parse(montantController.text);
                  investirDansProjet(montantInvesti, projectId, investorId);
                  Navigator.of(context).pop(); // Ferme le dialogue
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Veuillez entrer un montant valide.')),
                  );
                }
              },
              child: Text('Investir'),
            ),
          ],
        );
      },
    );
  }

  // Logique pour investir dans un projet
  void investirDansProjet(int montant, String projetId, String investisseursId) {
    final investmentService = ServiceInvestissement();
    const int benefice = 0; // Logique pour le calcul du bénéfice

    FirebaseFirestore.instance
        .collection('projet')
        .doc(projetId)
        .get()
        .then((DocumentSnapshot projectSnapshot) {
      if (projectSnapshot.exists) {
        String entrepreneurId = projectSnapshot['entrepreneurId'];

        FirebaseFirestore.instance
            .collection('utilisateurs')
            .doc(entrepreneurId)
            .get()
            .then((DocumentSnapshot userSnapshot) {
          if (userSnapshot.exists) {
            String entrepreneurToken = userSnapshot['fcmToken'];

            PushNotificationService.sendNotification(
              title: "Nouvelle Investissement",
              body: "Vous avez reçu un investissement de $montant.",
              token: entrepreneurToken,
              contextType: "Investissement",
              contextData: projetId,
            );

            investmentService.ajouterInvestissement(
              montantInvesti: montant,
              dateInvestissement: DateTime.now(),
              projetId: projetId,
              investisseursId: investisseursId,
              benefice: benefice,
            ).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Investissement effectué avec succès!')),
              );
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erreur lors de l\'investissement: $error')),
              );
            });
          }
        });
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération du projet: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        _buildSectorFilter(),
        Expanded(child: _buildProjectsList()),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher un projet',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onSubmitted: (_) => setState(() {}),
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => setState(() {}),
            child: Icon(Icons.search),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectorFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: secteurs.map((secteur) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: FilterChip(
                label: Text(secteur),
                selected: selectedSecteur == secteur,
                onSelected: (selected) {
                  setState(() {
                    selectedSecteur = selected ? secteur : 'Tous';
                  });
                },
                backgroundColor: Colors.grey[200],
                selectedColor: Colors.blue[200],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildProjectsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('projet').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Aucun projet trouvé.'));
        }

        final projects = snapshot.data!.docs.where((project) {
          bool matchesSecteur = selectedSecteur == 'Tous' || project['secteur'] == selectedSecteur;
          bool matchesSearch = searchController.text.isEmpty ||
              project['titre'].toString().toLowerCase().contains(searchController.text.toLowerCase());
          return matchesSecteur && matchesSearch;
        }).toList();

        if (projects.isEmpty) {
          return Center(child: Text('Aucun projet trouvé pour cette catégorie.'));
        }

        return ListView.builder(
          itemCount: projects.length,
          itemBuilder: (context, index) {
            var project = projects[index];
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project['titre'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Objectif Financer: ${project['objectifFinancer']}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Description: ${project['description']}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _showInvestmentDialog(context, project.id);
                          },
                          icon: Icon(Icons.monetization_on),
                          label: Text('Investir'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Logique pour contacter l'entrepreneur
                          },
                          icon: Icon(Icons.message),
                          label: Text('Contacter'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
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
}
