import 'package:flutter/material.dart';

class DetailProjet extends StatefulWidget {
  const DetailProjet({super.key});

  @override
  State<DetailProjet> createState() => _DetailProjetState();
}

class _DetailProjetState extends State<DetailProjet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
            child: Text( " Detail du Projet", style: TextStyle(fontSize: 30,color: Colors.black),)),
        
        Card(
          margin: EdgeInsets.all(10),
          elevation: 8,
          child: Container(
            child: ListTile(

              title:  Text("Titre donné Par Entrepreneur"),

            ),
          ),
        ),

        Card(
          margin: EdgeInsets.all(10),
          elevation: 8,
          child: Container(
            child: ListTile(
              title:  Text("Statut d’avancement du projet"),

            ),
          ),
        ),

        Card(
          margin: EdgeInsets.all(10),
          elevation: 8,
          child: Container(
            child: ListTile(
              title:  Text("Secteur D'activité"),

            ),
          ),
        ),


        Card(
          margin: EdgeInsets.all(10),
          elevation: 8,
          child: Container(
            child: ListTile(
              title:  Text("Description du Projet"),

            ),
          ),
        ),

        Card(
          margin: EdgeInsets.all(10),
          elevation: 8,
          child: Container(
            child: ListTile(
              title:  Text("objectif Financer"),

            ),
          ),
        ),

        Card(
          margin: EdgeInsets.all(10),
          elevation: 8,
          child: Container(
            child: ListTile(
              title:  Text("Date de Creation"),

            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // premier Container
            Container(
              margin: EdgeInsets.only(bottom: 15),
              alignment: Alignment.center,
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),

              ),
              
              child: Text("Modifier",style: TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,),


            ),

            Container(
              margin: EdgeInsets.only(bottom: 15),
              alignment: Alignment.center,
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),

              ),

              child: Text("Supprimer",style: TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,),


            ),
          ],
        )

      ],
    );
  }
}
