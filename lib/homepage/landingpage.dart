import 'package:flutter/material.dart';

class Landingpage extends StatefulWidget {
  const Landingpage({super.key});

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Container(
                child: Image.network('assets/BRGHGMC.png', height: 100,width: 100,),
              ), 
              Container(
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('Text1'),
                    Text('Text2'), 
                    Text('Text3'), 
                    Text('Text4'),  
                  ],
                ),
              ),

              Container(
                child: Row(
                  children: [
                    IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.account_circle)),
                  ],
                ), 
              ), 


            ], 
          ),
        ), 
      ],
     ), 
    );
  }
}