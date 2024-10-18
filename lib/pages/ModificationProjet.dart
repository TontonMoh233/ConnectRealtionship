import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        Navigator.pop(context); // Retourner à l'écran précédent
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la mise à jour du projet : $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier Projet"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titreController,
                decoration: const InputDecoration(labelText: 'Titre du Projet'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un titre";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description du Projet'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer une description";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: objectifController,
                decoration: const InputDecoration(labelText: 'Objectif Financier'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un objectif financier";
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Secteur'),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateProject,
                child: const Text("Mettre à jour le Projet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
