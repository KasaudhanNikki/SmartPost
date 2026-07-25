import 'package:flutter/material.dart';

class RocketScreen extends StatelessWidget {
  const RocketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Rocket',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
