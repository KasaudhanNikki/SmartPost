import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartpost/utils/gap.dart';
import '../screens/edit_caption_screen.dart';
import '../screens/ai_loading_screen.dart';
import 'glass_container.dart';
import 'share_loading_overlay.dart';

class PostItem extends StatefulWidget {
  final Map<String, dynamic> postData;

  const PostItem({super.key, required this.postData});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  int _currentImageIndex = 0;
  late String _caption;
  bool _showProductInfo = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _caption = widget.postData['caption'];

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showProductInfo = true);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _editCaption() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCaptionScreen(initialCaption: _caption),
      ),
    );
    if (result != null && result is String) {
      setState(() {
        _caption = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = List<String>.from(widget.postData['images']);

    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: images[index],
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              errorWidget: (context, url, error) =>
                  Container(color: Colors.grey.shade900),
            );
          },
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.7),
                ],
                stops: const [0.5, 0.8, 1.0],
              ),
            ),
          ),
        ),

        Positioned(
          top: 16,
          left: 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: CachedNetworkImageProvider(
                  widget.postData['userAvatar'],
                ),
              ),
              VerticalGap(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE89BD0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                        VerticalGap(4),
                        Text(
                          'Ready to share',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  HorizontalGap(4),
                  Text(
                    widget.postData['communityText'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (images.length > 1)
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Pick ${_currentImageIndex + 1} of ${images.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        if (images.length > 1)
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(images.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == index
                              ? const Color(0xFF76C298)
                              : Colors.white,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

        Positioned(
          bottom: 100,
          left: 16,
          right: 48,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlassContainer(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.music_note, color: Colors.white, size: 16),
                    VerticalGap(8),
                    Flexible(
                      child: Text(
                        widget.postData['musicText'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              HorizontalGap(12),

              AnimatedOpacity(
                opacity: _showProductInfo ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: _showProductInfo
                    ? GestureDetector(
                        onTap: () {},
                        child: GlassContainer(
                          padding: const EdgeInsets.all(8),
                          borderRadius: BorderRadius.circular(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1586495777744-4413f21062fa?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              VerticalGap(12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Giordani Gold Lipstick',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    HorizontalGap(2),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.trending_up,
                                          color: Colors.white70,
                                          size: 12,
                                        ),
                                        VerticalGap(4),
                                        const Text(
                                          'Trending right now and on sale',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10,
                                          ),
                                        ),
                                        VerticalGap(8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF135A3E),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: const Text(
                                            '30% off',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : HorizontalGap(56), // Placeholder to maintain height
              ),
              if (_showProductInfo) const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AILoadingScreen(
                            onComplete: () {
                              setState(() {
                                _caption =
                                    '✨ Check out the ultimate Giordani Gold glow! Perfect for a night out or everyday elegance. #GiordaniGold #Oriflame';
                              });
                            },
                          ),
                        ),
                      );
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.white, size: 16),
                        VerticalGap(4),
                        Text(
                          'CAPTION SUGGESTION',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _editCaption,
                    child: const Row(
                      children: [
                        Icon(Icons.edit, color: Colors.white, size: 16),
                        VerticalGap(4),
                        Text(
                          'Edit Caption',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              HorizontalGap(8),

              GestureDetector(
                onTap: _editCaption,
                child: GlassContainer(
                  borderRadius: BorderRadius.circular(12),
                  child: Text(
                    _caption,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              HorizontalGap(16),

              Row(
                children: [
                  const Text(
                    'Quick share to:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  VerticalGap(12),
                  _buildSocialIcon(FontAwesomeIcons.instagram, [
                    const Color(0xFFf09433),
                    const Color(0xFFe6683c),
                    const Color(0xFFdc2743),
                    const Color(0xFFcc2366),
                    const Color(0xFFbc1888),
                  ]),
                  VerticalGap(8),
                  _buildSocialIcon(FontAwesomeIcons.instagram, [
                    const Color(0xFFf09433),
                    const Color(0xFFe6683c),
                    const Color(0xFFdc2743),
                    const Color(0xFFcc2366),
                    const Color(0xFFbc1888),
                  ], isStory: true),
                  VerticalGap(8),
                  _buildSocialIcon(FontAwesomeIcons.facebookF, [
                    const Color(0xFF1877F2),
                    const Color(0xFF1877F2),
                  ]),
                  VerticalGap(8),
                  _buildSocialIcon(FontAwesomeIcons.facebookMessenger, [
                    const Color(0xFF00B2FF),
                    const Color(0xFF006AFF),
                  ]),
                  VerticalGap(8),
                  _buildSocialIcon(FontAwesomeIcons.tiktok, [
                    Colors.black,
                    Colors.black,
                  ]),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(
    dynamic icon,
    List<Color> gradientColors, {
    bool isStory = false,
  }) {
    return GestureDetector(
      onTap: () => ShareLoadingOverlay.show(context),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          border: isStory ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Center(child: FaIcon(icon, color: Colors.white, size: 18)),
      ),
    );
  }
}
