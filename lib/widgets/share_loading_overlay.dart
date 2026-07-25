import 'package:flutter/material.dart';
import 'package:smartpost/utils/gap.dart';

class ShareLoadingOverlay extends StatefulWidget {
  const ShareLoadingOverlay({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      barrierDismissible: false,
      builder: (context) => const ShareLoadingOverlay(),
    );
  }

  @override
  State<ShareLoadingOverlay> createState() => _ShareLoadingOverlayState();
}

class _ShareLoadingOverlayState extends State<ShareLoadingOverlay> {
  int _currentStep = 0;

  final List<String> _steps = [
    'Generating your sales link..',
    'Copying the caption to clipboard',
    'Saving the content to your profile',
    'Preparing the content for social media',
  ];

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  void _startSequence() async {
    for (int i = 0; i < _steps.length; i++) {
      setState(() {
        _currentStep = i;
      });
      await Future.delayed(const Duration(milliseconds: 1500));
    }
    if (mounted) {
      Navigator.pop(context); // Close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ready to share!'),
          backgroundColor: Color(0xFF76C298),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 280,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF81C7A5)),
                ),
              ),
              HorizontalGap(24),
              Text(
                _steps[_currentStep],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              HorizontalGap(16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentStep + 1) / _steps.length,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF81C7A5),
                  ),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
