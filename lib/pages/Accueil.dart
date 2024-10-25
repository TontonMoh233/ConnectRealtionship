import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'DetailInvesstisseur.dart';
import 'DetailProjet.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projets et Investisseurs'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Projets'),
            Tab(text: 'Investisseurs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProjectsTab(collectionName: 'projet'), // Tab pour les projets
          InvestorsTab(collectionName: 'utilisateurs'), // Tab pour les investisseurs
        ],
      ),
    );
  }
}

class ProjectsTab extends StatelessWidget {
  final String collectionName;

  ProjectsTab({required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Séparer les projets en deux listes : 'en_attente' et 'approuvé'
        var enAttenteProjects = snapshot.data!.docs.where((doc) =>
        (doc.data() as Map<String, dynamic>)['status'] == 'en_attente').toList();
        var approuveProjects = snapshot.data!.docs.where((doc) =>
        (doc.data() as Map<String, dynamic>)['status'] == 'approuvé').toList();

        return ListView(
          children: [
            // Section pour les projets 'en_attente'
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Projets en attente',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...enAttenteProjects.map((doc) => ProjectCard(projectData: doc.data() as Map<String, dynamic>)).toList(),

            // Section pour les projets 'approuvé'
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Projets approuvés',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...approuveProjects.map((doc) => ProjectCard(projectData: doc.data() as Map<String, dynamic>)).toList(),
          ],
        );
      },
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Map<String, dynamic> projectData;

  ProjectCard({required this.projectData});

  @override
  Widget build(BuildContext context) {
    String titre = projectData["titre"] ?? "Titre non disponible";
    String status = projectData["status"] ?? "Statut non disponible";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectDetailPage(
              titre: titre,
              status: status,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titre,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 8),
              Text(
                status,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InvestorsTab extends StatelessWidget {
  final String collectionName;

  InvestorsTab({required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Grouper les investisseurs par secteur
        var investorsBySector = <String, List<DocumentSnapshot>>{};
        for (var doc in snapshot.data!.docs) {
          var investorData = doc.data() as Map<String, dynamic>;
          var secteur = investorData['secteur'] ?? 'Secteur inconnu';
          if (!investorsBySector.containsKey(secteur)) {
            investorsBySector[secteur] = [];
          }
          investorsBySector[secteur]!.add(doc);
        }

        return ListView(
          children: investorsBySector.entries.map((entry) {
            var secteur = entry.key;
            var investors = entry.value;

            return ExpansionTile(
              title: Text(
                secteur,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: investors.map((doc) {
                var investorData = doc.data() as Map<String, dynamic>;
                return InvestorCard(investorData: investorData);
              }).toList(),
            );
          }).toList(),
        );
      },
    );
  }
}

class InvestorCard extends StatelessWidget {
  final Map<String, dynamic> investorData;

  InvestorCard({required this.investorData});

  @override
  Widget build(BuildContext context) {
    String nom = investorData["nom"] ?? "Nom non disponible";
    String email = investorData["email"] ?? "Email non disponible";
    String secteur = investorData.containsKey("secteur") ? investorData["secteur"] : "Secteur non disponible";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvestorDetailPage(
              nom: nom,
              email: email,
              secteur: secteur, // Ajout de l'argument secteur

            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nom,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 8),
              Text(
                email,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
