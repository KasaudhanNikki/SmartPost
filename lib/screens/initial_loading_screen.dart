import 'package:flutter/material.dart';
import 'package:smartpost/utils/gap.dart';
import 'main_navigation_screen.dart';

class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({super.key});

  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  List<int> stepStates = [0, 0, 0, 0];

  final List<String> steps = [
    'Preparing popular content for you',
    'Crafting a caption to boost engagement',
    'Adding your personal referral link and code',
    'Finding trending songs on other social media',
  ];

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    for (int i = 0; i < steps.length; i++) {
      setState(() {
        stepStates[i] = 1;
      });
      await Future.delayed(const Duration(milliseconds: 1200));
      setState(() {
        stepStates[i] = 2;
      });
    }
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    }
  }

  Widget _buildStep(int index) {
    int state = stepStates[index];
    Widget leadingIcon;

    if (state == 0) {
      leadingIcon = const Icon(
        Icons.circle_outlined,
        color: Colors.white54,
        size: 20,
      );
    } else if (state == 1) {
      leadingIcon = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Color(0xFF81C7A5),
          ), // Greenish
        ),
      );
    } else {
      leadingIcon = const Icon(
        Icons.check_circle,
        color: Color(0xFF81C7A5),
        size: 20,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          leadingIcon,
          VerticalGap(16),
          Expanded(
            child: Text(
              steps[index],
              style: TextStyle(
                color: state == 0 ? Colors.white54 : Colors.white,
                fontSize: 14,
                fontWeight: state == 2 ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Building personalised\nSmart Posts for you!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              HorizontalGap(48),
              for (int i = 0; i < steps.length; i++) _buildStep(i),
            ],
          ),
        ),
      ),
    );
  }
}
