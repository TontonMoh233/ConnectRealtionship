import 'package:flutter/material.dart';

import 'inscription.dart';

class Bienvenuepage extends StatelessWidget {
  const Bienvenuepage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              "assets/images/Bienvenue.png",
              fit: BoxFit.cover,
            ),
          ),


          Center(
            child: Positioned.fill(
           child: Padding(
               padding: EdgeInsets.only(top: 500),
             child: ElevatedButton(
                 onPressed: (){
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => Inscription()),
                   );
                 },
                 style: ElevatedButton.styleFrom(

                   backgroundColor: Color(0xFFD9D9D9),),
                 child: Text("DEMARRER",style: TextStyle(
                   color: Color(0xFFF30606),

                 ),
                 )
             ),
             )
             ),



          ),
        ],

      ),
    );
  }
}
