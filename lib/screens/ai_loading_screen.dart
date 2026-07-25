import 'package:flutter/material.dart';

class AILoadingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const AILoadingScreen({super.key, required this.onComplete});

  @override
  State<AILoadingScreen> createState() => _AILoadingScreenState();
}

class _AILoadingScreenState extends State<AILoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pop(context);
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.5 + (_animation.value * 0.5),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFFE89BD0),
                          Color(0xFFC0A6E5),
                          Colors.white,
                        ],
                        stops: [0.0, 0.4, 1.0],
                        center: Alignment(-0.5, 0.0),
                        radius: 1.5,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Crafting your captions\nand perfect hashtags...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
