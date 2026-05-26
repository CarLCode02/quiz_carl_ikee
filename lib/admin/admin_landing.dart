import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPage();
}

class _LandingPage extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    child: Text("Admin Dashboard"),
                  ), 
                  Container(
                    child: Text("Manage Quizzes"),
                  ), 
                  Container(
                    child: Text("Manage Users"),
                  ), 
                ],
              ),

            ), 
            Container(

            ), 

          ],
        ), 
      ), 
    ); 
      
          }
}