import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RechercheEntrepreneur extends StatefulWidget {
  @override
  _RechercheEntrepreneurState createState() => _RechercheEntrepreneurState();
}

class _RechercheEntrepreneurState extends State<RechercheEntrepreneur> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variables pour les critères de recherche
  String searchQuery = '';
  String selectedLocation = '';

  // Variables pour stocker les résultats de recherche
  List<Map<String, dynamic>> entrepreneurs = [];
  List<Map<String, dynamic>> filteredEntrepreneurs = [];

  @override
  void initState() {
    super.initState();
    _fetchEntrepreneurs();
  }


  String encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  // Récupérer tous les entrepreneurs avec le rôle spécifique depuis Firestore
  void _fetchEntrepreneurs() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('utilisateurs')
        .where('role', isEqualTo: 'entrepreneur') // Filtrer par rôle
        .get();

    setState(() {
      entrepreneurs = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Ajouter l'ID du document
        return data;
      }).toList();
      filteredEntrepreneurs = entrepreneurs; // Initialiser avec tous les entrepreneurs
    });
  }

  // Filtrer les entrepreneurs en fonction de la recherche et des filtres
  void _filterEntrepreneurs() {
    setState(() {
      filteredEntrepreneurs = entrepreneurs.where((entrepreneur) {
        final nom = entrepreneur['nom']?.toLowerCase() ?? '';
        final localisation = entrepreneur['localite']?.toLowerCase() ?? '';

        final matchesSearch = nom.contains(searchQuery.toLowerCase());
        final matchesLocation = selectedLocation.isEmpty || localisation == selectedLocation.toLowerCase();

        return matchesSearch && matchesLocation;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rechercher des Entrepreneurs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ de recherche
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
                _filterEntrepreneurs();
              },
              decoration: InputDecoration(
                labelText: 'Rechercher par nom',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16),
            // Dropdown pour localisation
            DropdownButton<String>(
              value: selectedLocation.isEmpty ? null : selectedLocation,
              hint: Text('Sélectionner une localisation'),
              onChanged: (value) {
                setState(() {
                  selectedLocation = value ?? '';
                });
                _filterEntrepreneurs();
              },
              items: ['bamako', 'segou', 'France']
                  .map((location) => DropdownMenuItem<String>(
                value: location,
                child: Text(location),
              ))
                  .toList(),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredEntrepreneurs.length,
                itemBuilder: (context, index) {
                  final entrepreneur = filteredEntrepreneurs[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(entrepreneur['nom'] ?? 'Nom non disponible'),
                      subtitle: Text('Localité : ${entrepreneur['localite'] ?? 'Non spécifiée'}'),
                      trailing: ElevatedButton(
                        onPressed: () {
                          // Naviguer vers le profil de l'entrepreneur
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EntrepreneurProfilePage(
                                entrepreneurId: entrepreneur['id'],
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.pink, // Texte en blanc
                        ),
                        child: Text('Consulter le profil'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Exemple de page de profil d'entrepreneur



class EntrepreneurProfilePage extends StatelessWidget {
  final String entrepreneurId;

  EntrepreneurProfilePage({required this.entrepreneurId});
  // Fonction pour contacter l'entrepreneur



// Encode les paramètres de la requête
  String encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('utilisateurs').doc(entrepreneurId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Entrepreneur non trouvé.'));

          }

          void _contactEntrepreneur(String email) async {
            final Uri emailLaunchUri = Uri(
              scheme: 'mailto',
              path: email,
              query: 'subject=Contact&body=Bonjour, je suis intéressé par votre profil.',
            );

            try {
              final bool launched = await launch(emailLaunchUri.toString());
              if (!launched) {
                throw 'Could not launch $emailLaunchUri';
              }
            } catch (e) {
              // Affichage du message d'erreur avec un contexte valide
              showDialog(
                context: context, // Assurez-vous que ce contexte est valide
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Erreur"),
                    content: Text("Aucune application de messagerie n'est installée ou une erreur est survenue."),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Fermer le dialogue
                        },
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
            }
          }

          var entrepreneurData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Section pour la photo de profil
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.blueAccent],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 120,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(
                          entrepreneurData['photoUrl'] ?? 'https://via.placeholder.com/150',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 80),
                // Section pour les détails de l'entrepreneur
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          '${entrepreneurData['prenom'] ?? ''} ${entrepreneurData['nom'] ?? ''}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Text(
                          entrepreneurData['role'] ?? 'Rôle non spécifié',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      SizedBox(height: 16),
                      // Email
                      Row(
                        children: [
                          Icon(Icons.email, color: Colors.blue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entrepreneurData['email'] ?? 'Email non disponible',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Localité
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.blue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entrepreneurData['localite'] ?? 'Localité non spécifiée',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      // Bouton pour contacter l'entrepreneur
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Action pour contacter l'entrepreneur
                            _contactEntrepreneur(entrepreneurData['email'] ?? 'email@exemple.com');

                          },
                          icon: Icon(Icons.contact_mail, color: Colors.white), // Couleur de l'icône
                          label: Text(
                            'Contacter',
                            style: TextStyle(color: Colors.white), // Texte en blanc
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFE31C57), // Couleur du bouton
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}