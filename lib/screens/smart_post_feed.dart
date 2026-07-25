import 'package:flutter/material.dart';
import '../widgets/post_item.dart';

class SmartPostFeed extends StatefulWidget {
  const SmartPostFeed({super.key});

  @override
  State<SmartPostFeed> createState() => _SmartPostFeedState();
}

class _SmartPostFeedState extends State<SmartPostFeed> {
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _posts = [
    {
      'id': '1',
      'userAvatar':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
      'userName': 'Amanda',
      'communityText': 'High-converting in Oriflame Community',
      'images': [
        'https://images.unsplash.com/photo-1586495777744-4413f21062fa?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // Lipstick
        'https://images.unsplash.com/photo-1596462502278-27bfdc403348?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // Perfume
        'https://images.unsplash.com/photo-1596462502278-27bfdc403348?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // Perfume another view
      ],
      'musicText': 'Recommended: Bad Habits by Ed Sheeran',
      'caption':
          '💄 Elevate your beauty with the Giordani Gold - Eternal Glow Lipstick SPF 25! This luxurious creamy lipstick doesn\'t just promise rich pigments but brings you the benefits of hyaluronic acid and collagen-boosting peptides too. Pamper your lips with care while enjoying a long-lasting, luminous matte colour.\n💋 ✨ #Oriflame #GiordaniGold #LipCareGoals\n\nYour referral and sales links:\nUse my referral code: UK-AMANDA3012\nUse my referral link: www.oriflame.com/giordani/amada3012',
    },
    {
      'id': '2',
      'userAvatar':
          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
      'userName': 'Sarah',
      'communityText': 'Trending in Beauty Lovers',
      'images': [
        'https://images.unsplash.com/photo-1610461888750-10bfc601b874?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80', // Skin care
      ],
      'musicText': 'Recommended: Unstoppable by Sia',
      'caption':
          '✨ Experience the elegance of Eclat Amour—a fragrance that captures the essence of romance and sophistication. Let every spritz wrap you in timeless charm and effortless allure. 💕\n#EclatAmour #TimelessElegance',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return PostItem(postData: post);
      },
    );
  }
}
