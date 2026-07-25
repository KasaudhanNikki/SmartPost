import 'package:flutter/material.dart';
import 'package:smartpost/utils/camera_helper.dart';
import 'package:smartpost/utils/gap.dart';
import 'ai_assistant_screen.dart';
import 'smart_post_feed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onCameraTap() async {
    await CameraHelper.openCamera(context);
  }

  void _onAssistantTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AiAssistantScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        leadingWidth: 100,
        leading: GestureDetector(
          onTap: _onAssistantTap,
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.blur_on, color: Colors.black, size: 24),
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF76C298),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              HorizontalGap(2),
              const Text(
                'Your Assistant',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        title: SizedBox(
          height: 50,
          child: Image.asset("assets/logo/logo.png", fit: BoxFit.contain),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: _onCameraTap,
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF76C298),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  HorizontalGap(2),
                  const Text(
                    'Camera',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF76C298),
                unselectedLabelColor: Colors.grey.shade600,
                indicatorColor: const Color(0xFF76C298),
                indicatorWeight: 3,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                tabs: const [
                  Tab(text: 'Smart Post'),
                  Tab(text: 'Library'),
                  Tab(text: 'Communities'),
                  Tab(text: 'Share&Win'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SmartPostFeed(),
          const Center(
            child: Text('Library', style: TextStyle(color: Colors.white)),
          ),
          const Center(
            child: Text('Communities', style: TextStyle(color: Colors.white)),
          ),
          const Center(
            child: Text('Share&Win', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
