import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizcarl_ikee/login_page.dart';
import 'package:url_launcher/url_launcher.dart';

class Landingpage extends StatefulWidget {
  const Landingpage({super.key});

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
     body:Container(
decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [const Color.fromARGB(255, 26, 58, 42),kGreen],
    ),
  ),
      child: Column(
   
   
         children: [
        Container(
          padding: const EdgeInsets.all(5 ),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:[
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Image.network('assets/BRGHGMC.png', height: 95,width: 95,),
              ), 
              Container(
              
                margin: EdgeInsets.all(12),
                child: Row(
                   
                  children: [
                    SizedBox(height: 30 ),
                    Container(
                      margin: EdgeInsets.all(30),
                      child: Text('GreenCross', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),), 
                    ),   
                     Container(
                      margin: EdgeInsets.all(30),
                      child: Text('Hospital Essentials', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)), 
                     ),
                      Container(
                        margin: EdgeInsets.all(30),
                        child: Text('Midterm Exam', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)), 
                      ),
                       Container(
                        margin: EdgeInsets.all(30),
                        child: Text('Entrance Exam', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)), 
                       ),
                       
                  ],
                ),
              ),

              Container(
                child: Row(
                  children: [
                    Container(
                     // margin: EdgeInsets.all(12),
                      

 child:TextButton(
  onPressed: () {},
  style: TextButton.styleFrom(
    padding: EdgeInsets.all(16.0),
     backgroundColor: kGold, 
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
  ),
  child: const Text('Register', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w600),),
)
                    ), 
                    
                   /* Container(
                      margin: EdgeInsets.all(20),

                      child: TextButton(
  onPressed: () {},
  style: TextButton.styleFrom(
    padding: EdgeInsets.all(16.0),
    
    side: const BorderSide(color: Colors.black, width: 1.0),
    shape: const RoundedRectangleBorder(

      borderRadius: BorderRadius.zero,
    ),
  ),
  child: const Text('Login', style: TextStyle(color: Colors.black)),
)
                    ),*/
                    //for icon
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Icon(Icons.account_circle, size: 43,color: const Color.fromARGB(255, 255, 236, 236),),
                    ),           
                  ],

                ), 
              ), 

            ], 
          ),
        ), 

        Divider(
          color: const Color.fromARGB(255, 0, 0, 0),
          thickness: 1,
          indent: 10,
          endIndent: 10,
),
   Container(
    
    child: Center(
      child: Column(
        children: [
         SizedBox(height: 60),
         Text("BRGHGMC\n Examination Portal", style: GoogleFonts.inter(fontSize: 100, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 244, 243, 234)), textAlign: TextAlign.center,), 
         Text("Professional Education, Training and Research Unit (PETRU)", style: GoogleFonts.inter(fontSize: 20  , fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 244, 243, 234)), textAlign: TextAlign.center,),
        ],

      ),

    ), 
   ),

   Center(
    child: Center(
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Container(
                      margin: EdgeInsets.all(20),
                      child:TextButton(
  onPressed: () {},
  style: TextButton.styleFrom(
    padding: EdgeInsets.all(16.0),
     backgroundColor:kGold , 
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
  ),
  child: const Text("I'm a Examinee", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w600),),
)

                    ), 
                    //u were a good dream ~~

                     Container(
                      margin: EdgeInsets.all(20),
                      child:TextButton(
                         onPressed: () {},
                         style: TextButton.styleFrom(
                           padding: EdgeInsets.all(16.0),
                            backgroundColor:kGold, 
                           shape: const RoundedRectangleBorder(
                             borderRadius: BorderRadius.zero,
                           ),
                         ),
                         child: const Text("I'm a Test Administrator", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w600),),
                       )

                    ), 
        ],
      ),
    ),
    
   ), 
   SizedBox(height: 120),
   /** 
   Divider(
    color: const Color.fromARGB(255, 0, 0, 0),
          thickness: 1,
          indent: 5,
          endIndent: 8,
   ), */
  
   
      ],

      )
      
     
     ), 
    );
  }
}