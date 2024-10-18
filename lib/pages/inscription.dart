import 'package:flutter/material.dart';
import 'package:relationship/pages/Services_authentication.dart';
import 'connexion.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  String selectRole = "entrepreneur";
  final emailController = TextEditingController();
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final passwordController = TextEditingController();
  final secteurController = TextEditingController();
  final montantInvestissementController = TextEditingController();
  String? selectedDomaineExpertise; // Pour le domaine d'expertise du mentor
  final projetController = TextEditingController();
  final montantDonController = TextEditingController();

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _loading = false;

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Veuillez renseigner ce champ";
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return "Veuillez entrer une adresse e-mail valide";
    }
    return null;
  }

  Future<void> createUser() async {
    try {
      await Autentification().inscriptionUser(
        emailController.text.trim(),
        passwordController.text,
        nomController.text,
        prenomController.text,
        selectRole,
        
        secteur: selectRole == "investisseur" ? secteurController.text : null,
        montantInvestissement: selectRole == "investisseur" ? montantInvestissementController.text : null,
        domaineExpertise: selectRole == "mentor" ? selectedDomaineExpertise : null,
        projet: selectRole == "donateur" ? projetController.text : null,
        montantDon: selectRole == "donateur" ? montantDonController.text : null,
      );

      // Affichage d'une boîte de dialogue de succès
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Inscription réussie"),
          content: Text("Vous vous êtes inscrit avec succès !"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
                Navigator.push(context, MaterialPageRoute(builder: (context) => Connexion()));
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      print("Erreur lors de l'inscription : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'inscription : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(30),
            child: Form(
              key: _globalKey,
              child: Column(
                children: [
                  SizedBox(
                    width: 80,
                    child: Image.asset("assets/images/img.png"),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Bienvenue",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300, color: Colors.black),
                  ),
                  Text(
                    "Vous Pouvez Vous Inscrire",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                  SizedBox(height: 20),

                  // Champ Nom
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez renseigner ce champ";
                      }
                      return null;
                    },
                    controller: nomController,
                    decoration: InputDecoration(
                      labelText: "Nom",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF30606), width: 1.0),
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.redAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),

                  // Champ Prénom
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez renseigner ce champ";
                      }
                      return null;
                    },
                    controller: prenomController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF30606), width: 1.0),
                      ),
                      labelText: "Prénom",
                      prefixIcon: Icon(Icons.person, color: Colors.redAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),

                  // Champ E-mail
                  TextFormField(
                    validator: emailValidator,
                    controller: emailController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF30606), width: 1.0),
                      ),
                      labelText: "E-mail",
                      prefixIcon: Icon(Icons.mail, color: Colors.redAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),

                  // Champ Mot de passe
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Veuillez renseigner ce champ";
                      }
                      return null;
                    },
                    controller: passwordController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF30606), width: 1.0),
                      ),
                      labelText: "Mot de passe",
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.redAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),

                  // Champ de sélection du rôle avec bords arrondis
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFFF30606), width: 1),
                    ),
                    child: DropdownButtonFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez renseigner ce champ";
                        }
                        return null;
                      },
                      items: [
                        DropdownMenuItem(value: 'entrepreneur', child: Text("Entrepreneur")),
                        DropdownMenuItem(value: 'investisseur', child: Text("Investisseur")),
                        DropdownMenuItem(value: 'mentor', child: Text("Mentor")),
                        DropdownMenuItem(value: 'donateur', child: Text("Donateur")),
                      ],
                      value: selectRole,
                      onChanged: (value) {
                        setState(() {
                          selectRole = value!;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        border: InputBorder.none, // Remove default border
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Champs spécifiques selon le rôle avec marge
                  if (selectRole == "investisseur") ...[
                    SizedBox(height: 10), // Marge
                    TextFormField(
                      controller: secteurController,
                      decoration: InputDecoration(
                        labelText: "Secteur d'investissement",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Marge
                    TextFormField(
                      controller: montantInvestissementController,
                      decoration: InputDecoration(
                        labelText: "Montant d'investissement",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)
                        ),
                      ),
                    ),
                  ] else if (selectRole == "mentor") ...[
                    SizedBox(height: 10), // Marge
                    DropdownButtonFormField<String>(
                      value: selectedDomaineExpertise,
                      hint: Text("Sélectionnez un domaine d'expertise"),
                      items: [
                        DropdownMenuItem(value: 'Marketing', child: Text("Marketing")),
                        DropdownMenuItem(value: 'Finance', child: Text("Finance")),
                        DropdownMenuItem(value: 'Développement', child: Text("Développement")),
                        DropdownMenuItem(value: 'Design', child: Text("Design")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedDomaineExpertise = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ] else if (selectRole == "donateur") ...[
                    SizedBox(height: 10), // Marge
                    TextFormField(
                      controller: projetController,
                      decoration: InputDecoration(
                        labelText: "Nom du projet",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10), // Marge
                    TextFormField(
                      controller: montantDonController,
                      decoration: InputDecoration(
                        labelText: "Montant du don",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],

                  SizedBox(height: 30),

                  // Bouton d'inscription
                  ElevatedButton(
                    onPressed: () {
                      if (_globalKey.currentState!.validate()) {
                        setState(() {
                          _loading = true;
                        });
                        createUser();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _loading ? CircularProgressIndicator() : Text("S'inscrire"),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Lien vers la page de connexion
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Connexion()));
                    },
                    child: Text("Vous avez déjà un compte? Connectez-vous ici"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
