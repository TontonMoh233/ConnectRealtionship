import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvestorProjectsPage extends StatelessWidget {
  final String investisseurId;

  const InvestorProjectsPage({Key? key, required this.investisseurId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projets et Dépenses'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('investissements')
            .where('investisseursId', isEqualTo: investisseurId) // Assurez-vous que ce champ est correct
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur lors du chargement des investissements.'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aucun investissement trouvé.'));
          }

          // Récupérer les IDs des projets associés à cet investisseur
          var projetIds = snapshot.data!.docs.map((doc) => doc['projetId']).toList();

          // Afficher les projets associés à l'investisseur
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('projet')
                .where(FieldPath.documentId, whereIn: projetIds)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Erreur lors du chargement des projets.'));
              }

              var projets = snapshot.data!.docs;

              if (projets.isEmpty) {
                return Center(child: Text('Aucun projet trouvé pour cet investisseur.'));
              }

              return ListView.builder(
                itemCount: projets.length,
                itemBuilder: (context, index) {
                  var projet = projets[index].data() as Map<String, dynamic>;
                  var projetId = projets[index].id;

                  return ExpansionTile(
                    title: Text(projet['titre'] ?? 'Nom de projet non disponible'),
                    children: [
                      FutureBuilder<QuerySnapshot>(
                        // Changer la requête pour accéder à la sous-collection 'depenses' sous chaque projet
                        future: FirebaseFirestore.instance
                            .collection('projet')
                            .doc(projetId)
                            .collection('depenses')
                            .where('projetId', isEqualTo: projetId) // Filtrer par projet
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(child: Text('Erreur lors du chargement des dépenses.'));
                          }

                          var depenses = snapshot.data!.docs;

                          if (depenses.isEmpty) {
                            return ListTile(title: Text('Aucune dépense trouvée pour ce projet.'));
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: depenses.length,
                            itemBuilder: (context, index) {
                              var depense = depenses[index].data() as Map<String, dynamic>;
                              var montant = depense['montant'] ?? 0;
                              var description = depense['description'] ?? 'Description non disponible';
                              var date = (depense['date'] as Timestamp).toDate();

                              return ListTile(
                                title: Text(description),
                                subtitle: Text('Montant : \$${montant.toString()}'),
                                trailing: Text('${date.day}/${date.month}/${date.year}'),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
