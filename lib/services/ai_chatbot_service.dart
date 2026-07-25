import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/chat_message.dart';

class AiChatbotService {
  AiChatbotService._();

  static const String openAiApiKey = 'YOUR_OPENAI_API_KEY';

  static bool get hasApiKey =>
      openAiApiKey.isNotEmpty && openAiApiKey != 'YOUR_OPENAI_API_KEY';

  static Future<AiChatResponse> getResponse(
    String userMessage,
    List<ChatMessage> history,
  ) async {
    if (hasApiKey) {
      try {
        return await _callOpenAi(userMessage, history);
      } catch (_) {
        return _getMockResponse(userMessage);
      }
    }
    return _getMockResponse(userMessage);
  }

  static Future<AiChatResponse> _callOpenAi(
    String userMessage,
    List<ChatMessage> history,
  ) async {
    final messages = [
      {
        'role': 'system',
        'content':
            'You are a helpful SmartPost AI assistant for Oriflame beauty consultants. '
            'Help users with product recommendations, social media captions, hashtags, '
            'and referral link tips. Keep responses concise and friendly.',
      },
      ...history.map((message) => {
            'role': message.isUser ? 'user' : 'assistant',
            'content': message.text,
          }),
      {'role': 'user', 'content': userMessage},
    ];

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAiApiKey',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': messages,
        'max_tokens': 500,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenAI API error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final content = data['choices'][0]['message']['content'] as String;
    return AiChatResponse(text: content.trim());
  }

  static AiChatResponse _getMockResponse(String userMessage) {
    final query = userMessage.toLowerCase();

    if (_matchesAny(query, ['hello', 'hi', 'hey', 'help'])) {
      return const AiChatResponse(
        text:
            'Hello! I\'m your SmartPost assistant. I can help you discover trending '
            'Oriflame products, write engaging captions, and boost your social sales. '
            'What would you like help with today?',
      );
    }

    if (_matchesAny(query, [
      'recommend',
      'product',
      'trending',
      'best',
      'suggest',
    ])) {
      return AiChatResponse(
        text:
            'Based on what\'s converting well in your community right now, here are '
            'my top product picks for you:',
        products: _featuredProducts,
      );
    }

    if (_matchesAny(query, ['sale', 'discount', 'offer', 'deal', 'off'])) {
      return AiChatResponse(
        text:
            'Great timing! These products are trending and currently on promotion. '
            'Perfect for your next Smart Post:',
        products: _saleProducts,
      );
    }

    if (_matchesAny(query, [
      'caption',
      'post',
      'write',
      'hashtag',
      'content',
    ])) {
      return const AiChatResponse(
        text:
            'Here\'s a high-converting caption you can use:\n\n'
            '💄 Elevate your beauty with Giordani Gold Eternal Glow Lipstick SPF 25! '
            'Luxurious pigments, hyaluronic acid, and a luminous matte finish your '
            'followers will love.\n\n'
            '✨ #Oriflame #GiordaniGold #LipCareGoals #BeautyConsultant\n\n'
            'Tip: Add your referral code and link at the end to drive sales!',
      );
    }

    if (_matchesAny(query, ['lipstick', 'lips', 'giordani'])) {
      return AiChatResponse(
        text:
            'Giordani Gold Eternal Glow Lipstick is one of your best sellers! '
            'It features SPF 25, hyaluronic acid, and collagen-boosting peptides. '
            'It\'s trending in the Oriflame Community with strong engagement.',
        products: [_featuredProducts.first],
      );
    }

    if (_matchesAny(query, ['perfume', 'fragrance', 'eclat', 'scent'])) {
      return AiChatResponse(
        text:
            'Eclat Amour is perfect for romance and sophistication posts. '
            'Fragrance content performs great on social — pair it with elegant visuals '
            'and hashtags like #EclatAmour #TimelessElegance.',
        products: [_featuredProducts[1]],
      );
    }

    if (_matchesAny(query, ['skincare', 'skin', 'care', 'routine'])) {
      return AiChatResponse(
        text:
            'Skincare posts are gaining traction in Beauty Lovers community. '
            'Focus on before/after stories and ingredient benefits for best results.',
        products: [_featuredProducts[2]],
      );
    }

    if (_matchesAny(query, ['referral', 'link', 'code', 'sell', 'sales'])) {
      return const AiChatResponse(
        text:
            'To maximize sales from your Smart Posts:\n\n'
            '1. Always include your referral code (e.g. UK-AMANDA3012)\n'
            '2. Add your personal Oriflame link in every caption\n'
            '3. Post when your community is most active (evenings work best)\n'
            '4. Use trending music recommendations from SmartPost\n\n'
            'Would you like me to recommend a product to promote this week?',
      );
    }

    return AiChatResponse(
      text:
          'I can help you with product recommendations, caption ideas, trending '
          'hashtags, and sales tips for your Oriflame business. Try asking:\n\n'
          '• "Recommend a trending product"\n'
          '• "Write a caption for lipstick"\n'
          '• "What products are on sale?"\n'
          '• "Help with my referral link"',
      products: query.contains('product') ? _featuredProducts : const [],
    );
  }

  static bool _matchesAny(String query, List<String> keywords) {
    return keywords.any(query.contains);
  }

  static const List<ProductRecommendation> _featuredProducts = [
    ProductRecommendation(
      name: 'Giordani Gold Lipstick',
      description: 'SPF 25 · Hyaluronic acid · Trending in Oriflame Community',
      imageUrl:
          'https://images.unsplash.com/photo-1586495777744-4413f21062fa?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
      price: '£18.99',
      discount: '30% off',
    ),
    ProductRecommendation(
      name: 'Eclat Amour Fragrance',
      description: 'Romantic & sophisticated · High engagement on social',
      imageUrl:
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
      price: '£34.99',
      discount: '20% off',
    ),
    ProductRecommendation(
      name: 'Optimals Hydra Radiance',
      description: 'Skincare bestseller · Trending in Beauty Lovers',
      imageUrl:
          'https://images.unsplash.com/photo-1610461888750-10bfc601b874?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
      price: '£24.99',
    ),
  ];

  static final List<ProductRecommendation> _saleProducts = [
    _featuredProducts[0],
    _featuredProducts[1],
  ];
}

class AiChatResponse {
  final String text;
  final List<ProductRecommendation> products;

  const AiChatResponse({
    required this.text,
    this.products = const [],
  });
}
