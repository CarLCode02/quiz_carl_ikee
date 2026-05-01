import 'package:flutter/material.dart';
import 'login_page.dart';
import 'homepage/user_settings.dart'; 


void main() {
  runApp(const MyApp());
}

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kGreen),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
