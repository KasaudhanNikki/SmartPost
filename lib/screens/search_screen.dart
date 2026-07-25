import 'package:flutter/material.dart';
import 'package:smartpost/utils/gap.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          autofocus: false,
          style: const TextStyle(color: Colors.black87, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Search posts, people, communities...',
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey.shade700),
            HorizontalGap(16),
            Text(
              'Search',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            HorizontalGap(8),
            Text(
              'Find posts, people, and communities',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
