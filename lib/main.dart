import 'package:flutter/material.dart';
import 'package:quizcarl_ikee/homepage/landingpage.dart';
import 'login_page.dart';
import 'homepage/user_settings.dart'; 



void main() {
  runApp(const MyApp());
}

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);

// Global theme notifier — any page can toggle dark mode
final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, mode, __) => MaterialApp(
        title: 'Quiz App',
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: kGreen),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: kGreen,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const Landingpage(),
      ),
    );
  }
}
