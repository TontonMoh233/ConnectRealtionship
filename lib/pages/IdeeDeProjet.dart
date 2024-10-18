import 'package:flutter/material.dart';

class Ideedeprojet extends StatefulWidget {
  const Ideedeprojet({super.key});

  @override
  State<Ideedeprojet> createState() => _IdeedeprojetState();
}

class _IdeedeprojetState extends State<Ideedeprojet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: 
        Container(
          child: ListView(
            children:[
              Container(
              margin: EdgeInsets.all(32),
              width: double.infinity,
              height: 200,
              child: Card(
                elevation: 6,
                shadowColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(7))),
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text("Apprentissage personnalisé",style: TextStyle(fontSize: 17,color: Colors.red,fontWeight: FontWeight.w300),textAlign: TextAlign.center,),
                            SizedBox(height: 30,),
                            // une ligne horizontale
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: Text("objectif:",
                                    style: TextStyle(fontSize: 20,color: Colors.black),
                                  ),
                                ),
                                Container(
                                    child: Expanded(child:  Text("Developper une plateforme qui propose des parcours de "
                                      "ces des utilisateurs"),)                             ),



                              ],
                            ),

                            SizedBox(height: 15,),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: Text("Technologies:",
                                    style: TextStyle(fontSize: 20,color: Colors.black),
                                  ),
                                ),
                                Container(
                                    child: Expanded(child:  Text("Angular ou React pour le front-end, Python "),)                             ),



                              ],
                            ),


                          ],
                        )


                ),

              ),
            ),

              // reste des cartes
      ]
          ),
        ),

      floatingActionButton: FloatingActionButton(onPressed:
      (){},
       child: Icon(Icons.add),


      ),

    );
  }
}
