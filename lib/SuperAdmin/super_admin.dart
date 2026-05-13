import 'package:flutter/material.dart';

class SuperAdmin extends StatefulWidget {
  const SuperAdmin({super.key});

  @override
  State<SuperAdmin> createState() => _SuperAdmin();
}

class _SuperAdmin extends State<SuperAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Admin'), 
      ), 

      body: Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.pink,
      ), 
      child:Row(
        
      ), 
      ),
      
    );  
  }
}