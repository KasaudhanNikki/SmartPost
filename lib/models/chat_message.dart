class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<ProductRecommendation> products;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.products = const [],
  });
}

class ProductRecommendation {
  final String name;
  final String description;
  final String imageUrl;
  final String price;
  final String discount;

  const ProductRecommendation({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.discount = '',
  });
}
