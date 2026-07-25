import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/initial_loading_screen.dart';

void main() {
  runApp(const SmartPostApp());
}

class SmartPostApp extends StatelessWidget {
  const SmartPostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Post',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF76C298),
          primary: const Color(0xFF76C298),
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      home: const InitialLoadingScreen(),
    );
  }
}
