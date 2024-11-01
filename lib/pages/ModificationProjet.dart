import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Définir votre palette de couleurs
const Color primaryColor = Color(0xFF3F51B5); // Couleur principale (exemple)
const Color accentColor = Color(0xFFFFC107); // Couleur d'accent (exemple)

class ModifierProjet extends StatefulWidget {
  final String projectId;
  final String titre;
  final String description;
  final double objectifFinancer;
  final String secteur;

  const ModifierProjet({
    required this.projectId,
    required this.titre,
    required this.description,
    required this.objectifFinancer,
    required this.secteur,
    Key? key,
  }) : super(key: key);

  @override
  _ModifierProjetState createState() => _ModifierProjetState();
}

class _ModifierProjetState extends State<ModifierProjet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titreController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController objectifController = TextEditingController();
  String? selectedSecteur;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    titreController.text = widget.titre;
    descriptionController.text = widget.description;
    objectifController.text = widget.objectifFinancer.toString();
    selectedSecteur = widget.secteur;
  }

  Future<void> updateProject() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isUpdating = true);
      try {
        await FirebaseFirestore.instance.collection('projet').doc(widget.projectId).update({
          'titre': titreController.text,
          'description': descriptionController.text,
          'objectifFinancer': double.tryParse(objectifController.text) ?? 0,
          'secteur': selectedSecteur,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Projet mis à jour avec succès")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la mise à jour du projet : $e")),
        );
      } finally {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier Projet"),
        backgroundColor: primaryColor,
      ),
      body: _isUpdating
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(  // Ajout de Center pour centrer les éléments
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centre verticalement
              crossAxisAlignment: CrossAxisAlignment.center, // Centre horizontalement
              children: [
                TextFormField(
                  controller: titreController,
                  decoration: InputDecoration(
                    labelText: 'Titre du Projet',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: accentColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer un titre";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description du Projet',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: accentColor),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer une description";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: objectifController,
                  decoration: InputDecoration(
                    labelText: 'Objectif Financier',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: accentColor),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer un objectif financier";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Secteur',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: accentColor),
                    ),
                  ),
                  value: selectedSecteur,
                  items: const [
                    DropdownMenuItem(value: 'agriculture', child: Text("AGRICULTURE")),
                    DropdownMenuItem(value: 'santé', child: Text("SANTÉ")),
                    DropdownMenuItem(value: 'education', child: Text("ÉDUCATION")),
                    DropdownMenuItem(value: 'technologie', child: Text("TECHNOLOGIE")),
                    DropdownMenuItem(value: 'elevage', child: Text("ÉLEVAGE")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedSecteur = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "Veuillez sélectionner un secteur";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: updateProject,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: primaryColor, // Couleur du texte
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Coins arrondis
                        ),
                      ),
                      child: const Text("Mettre à jour le Projet"),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor, side: BorderSide(color: primaryColor), // Couleur de la bordure
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Coins arrondis
                        ),
                      ),
                      child: const Text("Annuler"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
