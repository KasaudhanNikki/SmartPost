import 'package:flutter/material.dart';

class EditCaptionScreen extends StatefulWidget {
  final String initialCaption;

  const EditCaptionScreen({super.key, required this.initialCaption});

  @override
  State<EditCaptionScreen> createState() => _EditCaptionScreenState();
}

class _EditCaptionScreenState extends State<EditCaptionScreen> {
  late TextEditingController _controller;
  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialCaption);
    _controller.addListener(() {
      setState(() {
        _isChanged = _controller.text != widget.initialCaption;
      });
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
        title: const Text(
          'Edit Caption',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 12, bottom: 12),
            child: ElevatedButton(
              onPressed: _isChanged
                  ? () => Navigator.pop(context, _controller.text)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isChanged
                    ? const Color(0xFFC4E4D1)
                    : Colors.grey.shade200,
                foregroundColor: _isChanged
                    ? const Color(0xFF4FA775)
                    : Colors.grey.shade400,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                disabledBackgroundColor: Colors.grey.shade200,
                disabledForegroundColor: Colors.grey.shade400,
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          maxLines: null,
          autofocus: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Write your caption here...',
          ),
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
