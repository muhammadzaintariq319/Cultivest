import 'package:flutter/material.dart';
import 'package:cultivest_app/core/database/database_helper.dart';
import 'package:cultivest_app/screens/learning/upload_content_screen.dart';
import 'package:cultivest_app/screens/learning/guidance_details_screen.dart';

class LearningToolsScreen extends StatefulWidget {
  const LearningToolsScreen({super.key});

  @override
  State<LearningToolsScreen> createState() => _LearningToolsScreenState();
}

class _LearningToolsScreenState extends State<LearningToolsScreen> {
  Color get primaryGreen => Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGreen,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Section
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
              child: Row(
                children: [
                  Icon(Icons.menu_book_outlined, color: Colors.white, size: 28),
                  SizedBox(width: 10),
                  Text(
                    'Learning Tools',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Main Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // 2. Featured Horizontal List (Videos/Banners)
                    SizedBox(
                      height: 220,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        children: [
                          _buildFeaturedCard(
                            context,
                            'assets/learning_feature1.png',
                            'Advanced Hydroponic System Setup Tutorial',
                            'Step-by-Step masterclass on building your own vertical soil-less farm. This video covers nutrient solution mixtures, water pump configurations, and grow light placement for ultimate success.',
                            category: 'Equipment',
                          ),
                          _buildFeaturedCard(
                            context,
                            'assets/learning_feature2.png',
                            'Maximizing Wheat Production & Harvesting Tips',
                            'Learn the scientific harvesting schedule, grain moisture testing, and post-harvest storage management guidelines from leading agricultural experts to prevent yield loss.',
                            category: 'Wheat',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 3. Articles/Guides Vertical List
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Featured Articles',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildArticleTile(
                            context,
                            'assets/guide1.png',
                            'Step-by-Step Guide to Seasonal Crop Planning',
                            'Learn efficient irrigation methods to save water and boost crop yields. Seasonal planting increases output and improves environmental sustainability.',
                            category: 'Crops',
                            contentType: 'PDF',
                          ),
                          const SizedBox(height: 20),
                          _buildArticleTile(
                            context,
                            'assets/guide2.png',
                            'How to Choose the Right Seeds for Your Region',
                            'Discover how to select the best crop seeds based on your local climate and soil. Seed selection plays a critical role in disease resistance and overall harvest quality.',
                            category: 'Wheat',
                            contentType: 'PDF',
                          ),
                          const SizedBox(height: 20),
                          _buildArticleTile(
                            context,
                            'assets/guide3.png',
                            'Modern Fertilizer Application Methods Explained',
                            'Understand how to apply fertilizer effectively for better plant growth and reduced waste. Over-fertilization can harm crops, so strategic application is highly recommended.',
                            category: 'Fertilizer',
                            contentType: 'PDF',
                          ),
                          const SizedBox(height: 20),
                          
                          // Dynamic Expert Guidance Section
                          FutureBuilder<List<Map<String, dynamic>>>(
                            future: DatabaseHelper().getAllLearningContent(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              final list = snapshot.data!;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Divider(color: Colors.white38, height: 40),
                                  const Text(
                                    'Expert Guidance',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      final item = list[index];
                                      final isVideo = item['contentType'] == 'Video';
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 20.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => GuidanceDetailsScreen(item: item),
                                              ),
                                            );
                                          },
                                          behavior: HitTestBehavior.opaque,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Icon Placeholder or Video Thumbnail Placeholder
                                              Container(
                                                width: 120,
                                                height: 85,
                                                decoration: BoxDecoration(
                                                  color: Colors.black26,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: Colors.white30),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    isVideo ? Icons.play_circle_fill : Icons.picture_as_pdf,
                                                    color: Colors.white70,
                                                    size: 36,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              // Details
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item['title'] ?? 'Title',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                        height: 1.2,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: isVideo ? Colors.red.shade700 : Colors.amber.shade700,
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      child: Text(
                                                        isVideo ? 'Video' : 'PDF Guidance',
                                                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 6),
                                                    Text(
                                                      item['description'] ?? 'Description',
                                                      style: const TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 11,
                                                        height: 1.3,
                                                      ),
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: DatabaseHelper.loggedInRole == 'expert'
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadContentScreen(),
                  ),
                ).then((_) {
                  setState(() {}); // Refresh content when return
                });
              },
              backgroundColor: Colors.white,
              icon: const Icon(Icons.upload_file, color: Colors.black87),
              label: const Text(
                'Upload Content',
                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }

  // --- Modular UI Builders ---

  // For Top Large Horizontal Images
  Widget _buildFeaturedCard(
    BuildContext context, 
    String imagePath, 
    String title, 
    String description, {
    required String category,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuidanceDetailsScreen(
              item: {
                'title': title,
                'category': category,
                'description': description,
                'contentType': 'Video',
              },
            ),
          ),
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade400, // Placeholder color
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover),
              const Center(
                child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 50),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // For Bottom Vertical List Items
  Widget _buildArticleTile(
    BuildContext context, 
    String imagePath, 
    String title, 
    String description, {
    required String category,
    required String contentType,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GuidanceDetailsScreen(
              item: {
                'title': title,
                'category': category,
                'description': description,
                'contentType': contentType,
              },
            ),
          ),
        );
      },
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Image Thumbnail
          Container(
            width: 120,
            height: 85,
            decoration: BoxDecoration(
              color: Colors.grey.shade400, // Placeholder color
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 15),

          // Right Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

