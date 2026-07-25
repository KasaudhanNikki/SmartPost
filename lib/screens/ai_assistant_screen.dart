import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smartpost/utils/gap.dart';

import '../models/chat_message.dart';
import '../services/ai_chatbot_service.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  static const _accentColor = Color(0xFF76C298);

  static const _suggestedPrompts = [
    'Recommend a trending product',
    'Write a caption for me',
    'What products are on sale?',
  ];

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        text: 'How can I help you?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage([String? text]) async {
    final message = (text ?? _messageController.text).trim();
    if (message.isEmpty || _isLoading) return;

    _messageController.clear();
    setState(() {
      _messages.add(
        ChatMessage(text: message, isUser: true, timestamp: DateTime.now()),
      );
      _isLoading = true;
    });
    _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 600));

    final response = await AiChatbotService.getResponse(message, _messages);

    if (!mounted) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: response.text,
          isUser: false,
          timestamp: DateTime.now(),
          products: response.products,
        ),
      );
      _isLoading = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.blur_on, color: Colors.black87, size: 22),
                Positioned(
                  right: -6,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: _accentColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            VerticalGap(10),
            const Text(
              'Your Assistant',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (!AiChatbotService.hasApiKey)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: _accentColor.withValues(alpha: 0.15),
              child: const Text(
                'Using intelligent mock responses · No API key required',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF135A3E),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          if (_messages.length == 1 && !_isLoading) _buildSuggestedPrompts(),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildSuggestedPrompts() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _suggestedPrompts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ActionChip(
            label: Text(
              _suggestedPrompts[index],
              style: const TextStyle(fontSize: 12),
            ),
            backgroundColor: Colors.white,
            side: BorderSide(color: _accentColor.withValues(alpha: 0.5)),
            labelStyle: const TextStyle(color: Color(0xFF135A3E)),
            onPressed: () => _sendMessage(_suggestedPrompts[index]),
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: _accentColor,
              child: const Icon(Icons.blur_on, color: Colors.white, size: 16),
            ),
            VerticalGap(8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? _accentColor : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                if (message.products.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...message.products.map(_buildProductCard),
                ],
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductRecommendation product) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _accentColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: product.imageUrl,
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(width: 52, height: 52, color: Colors.grey.shade200),
            ),
          ),
          VerticalGap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
                HorizontalGap(2),
                Text(
                  product.description,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                ),
                HorizontalGap(4),
                Row(
                  children: [
                    Text(
                      product.price,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Color(0xFF135A3E),
                      ),
                    ),
                    if (product.discount.isNotEmpty) ...[
                      VerticalGap(8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF135A3E),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.discount,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: _accentColor,
            child: const Icon(Icons.blur_on, color: Colors.white, size: 16),
          ),
          VerticalGap(8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.only(right: index < 2 ? 4 : 0),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _accentColor.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        8 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Ask about products, captions, sales...',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          VerticalGap(8),
          GestureDetector(
            onTap: _isLoading ? null : () => _sendMessage(),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isLoading ? Colors.grey.shade300 : _accentColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send_rounded,
                color: _isLoading ? Colors.grey.shade500 : Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
