import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'BienvenuePage.dart';

class WelcomPages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: LiquidSwipe(
        pages : pages,
        slideIconWidget: Icon(Icons.arrow_forward_ios_rounded,size: 30,),
        positionSlideIcon: 0.5,
        waveType: WaveType.liquidReveal,
        enableLoop: true,
        fullTransitionValue: 300,
        //enableSideReveal: true,

      ),

    );
  }

  final pages  = [
    // premiere page de bienvenue
    Container(
      color: Color(0xFF141752),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Lottie.asset("assets/animations/Animation.json",width: 300,height: 300),

          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
                "Transformez vos idées en succès. Rejoignez-nous dès aujourd'hui", style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.w400,),textAlign: TextAlign.center,),
          )
        ],
      ),
  ),

  // Deuxueme page de bienvenue
    Container(
      color: Color(0xFFE31C57),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Lottie.asset("assets/animations/investisseur.json",width: 300,height: 300),

          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Soutenez les projets les plus prometteurs et boostez l'innovation", style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.w400,),textAlign: TextAlign.center,),
          )
        ],
      ),
    ),
    
    Container(
      color: Color(0xFFE31C57),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Lottie.asset("assets/animations/2.json",width: 300,height: 300),

          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Soutenez l'impact, changez des vies", style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w400,),textAlign: TextAlign.center,),
          )
        ],
      ),
    ),

  // cinquieme  page de bienvenue

      Container(
     child: Bienvenuepage(),
),



  ];


}
