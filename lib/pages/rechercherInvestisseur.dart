import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Messenger.dart';

class RechercheInvestisseurs extends StatefulWidget {
  const RechercheInvestisseurs({super.key});

  @override
  State<RechercheInvestisseurs> createState() => _RechercheInvestisseursState();
}

class _RechercheInvestisseursState extends State<RechercheInvestisseurs> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  String? _selectedSecteur; // Nouveau filtre pour le secteur
  List<String> secteurs = ['Technologie', 'Santé', 'Éducation', 'Agriculture']; // Exemple de secteurs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recherche d'Investisseurs"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Champ de recherche par nom ou prénom
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Rechercher un Investisseur",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchTerm = _searchController.text.trim();
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Dropdown pour sélectionner le secteur d'investissement
            DropdownButtonFormField<String>(
              value: _selectedSecteur,
              hint: const Text("Sélectionner un secteur d'investissement"),
              items: secteurs.map((secteur) {
                return DropdownMenuItem(
                  value: secteur,
                  child: Text(secteur),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSecteur = value;
                });
              },
            ),
            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('utilisateurs')
                    .where('role', isEqualTo: 'investisseur') // Filtrer par rôle
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text("Erreur lors du chargement des investisseurs"));
                  }

                  final investisseurs = snapshot.data!.docs.where((investisseur) {
                    final nom = investisseur['nom'].toString().toLowerCase();
                    final prenom = investisseur['prenom'].toString().toLowerCase();
                    final secteur = investisseur['secteur']?.toString().toLowerCase() ?? '';

                    // Vérifier si le terme de recherche est présent dans le nom ou prénom
                    bool matchesSearchTerm = nom.contains(_searchTerm.toLowerCase()) || prenom.contains(_searchTerm.toLowerCase());

                    // Vérifier si le secteur correspond au filtre sélectionné
                    bool matchesSecteur = _selectedSecteur == null || secteur == _selectedSecteur!.toLowerCase();

                    return matchesSearchTerm && matchesSecteur;
                  }).toList();

                  if (investisseurs.isEmpty) {
                    return const Center(child: Text("Aucun Investisseur trouvé"));
                  }

                  return ListView.builder(
                    itemCount: investisseurs.length,
                    itemBuilder: (context, index) {
                      final investisseur = investisseurs[index];
                      final nom = investisseur['nom'];
                      final prenom = investisseur['prenom'];
                      final email = investisseur['email']; // Ajouter l'email pour contacter

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          title: Text('$nom $prenom'),
                          subtitle: Text(email), // Afficher l'email
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.message),
                                onPressed: () {
                                  // Action pour envoyer un message
                                  _sendMessage(investisseur.id);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.person_add),
                                onPressed: () {
                                  // Action pour envoyer une demande de contact
                                  _sendContactRequest(investisseur.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String investisseurId) {
    // Naviguer vers la page d'envoi de message
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SendMessagePage(investisseurId: investisseurId),
      ),
    );
  }

  void _sendContactRequest(String investisseurId) async {
    // Logique pour envoyer une demande de contact
    await FirebaseFirestore.instance.collection('contactRequests').add({
      'investisseurId': investisseurId,
      'demandeurId': 'currentUserId', // Remplacez par l'ID de l'utilisateur actuel
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Afficher un message de confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Demande de contact envoyée à l'investisseur!")),
    );
  }

}
