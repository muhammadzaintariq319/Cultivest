import 'package:flutter/material.dart';
import 'package:cultivest_app/screens/learning/learning_tools_screen.dart';
import 'package:cultivest_app/screens/marketplace/marketplace_screen.dart';
import 'package:cultivest_app/screens/profile/profile_screen.dart';
import 'package:cultivest_app/core/database/database_helper.dart';
import 'package:cultivest_app/screens/community/community_details_screen.dart';
import 'package:cultivest_app/screens/community/all_communities_screen.dart';

class ExpertCommunityScreen extends StatefulWidget {
  const ExpertCommunityScreen({super.key});

  @override
  State<ExpertCommunityScreen> createState() => _ExpertCommunityScreenState();
}

class _ExpertCommunityScreenState extends State<ExpertCommunityScreen> {
  Color get primaryGreen => Theme.of(context).primaryColor;

  // Custom Tab State
  bool isMyFeedSelected = true;

  final TextEditingController _postController = TextEditingController();

  Future<void> _submitPost() async {
    if (_postController.text.trim().isEmpty) return;

    await DatabaseHelper().insertPost({
      'communityName': 'Expert Hub',
      'userName': DatabaseHelper.loggedInUser,
      'location': 'Pakistan',
      'content': _postController.text.trim(),
      'likes': 0,
      'comments': 0,
    });

    if (!mounted) return;
    _postController.clear();
    FocusScope.of(context).unfocus();
    setState(() {}); // Refresh the FutureBuilder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Icon(Icons.groups_outlined, color: Colors.white, size: 28),
            SizedBox(width: 10),
            Text(
              'Communities',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. All Communities Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Communities',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AllCommunitiesScreen()),
                        ).then((_) => setState(() {}));
                      },
                      child: const Text(
                        'View all',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // 2. Horizontal Communities List
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  children: [
                    _buildCommunityAvatar('Cotton community', 'assets/cotton.png'),
                    _buildCommunityAvatar('Sugarcane', 'assets/sugarcane.png'),
                    _buildCommunityAvatar('Corn Community', 'assets/corn.png'),
                    _buildCommunityAvatar('Planting rice', 'assets/rice.png'),
                    _buildCommunityAvatar('Vegetable garden', 'assets/vegetables.png'),
                    _buildCommunityAvatar('Planting Wheat', 'assets/wheat.png'),
                    _buildCommunityAvatar('Expert Hub', 'assets/exporthub.png'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Custom Tabs (My feed & My communities)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: DatabaseHelper().getAllPosts(),
                      builder: (context, snapshot) {
                        int count = snapshot.data?.length ?? 0;
                        return _buildCustomTab('My feed', isMyFeedSelected, count, () {
                          setState(() => isMyFeedSelected = true);
                        });
                      }
                    ),
                    const SizedBox(width: 20),
                    _buildCustomTab('My communities', !isMyFeedSelected, 0, () {
                      setState(() => isMyFeedSelected = false);
                    }),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(color: Colors.white54, thickness: 1, height: 1),
              ),
              const SizedBox(height: 15),

              // 4. Dynamic Content based on Tab
              if (isMyFeedSelected) ...[
                // Create Post Card (Expert sharing knowledge)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildCreatePostCard(),
                ),
                const SizedBox(height: 20),

                // Feed Posts
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: DatabaseHelper().getAllPosts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Colors.white));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'No posts yet. Be the first to post!',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }

                      final posts = snapshot.data!;
                      return Column(
                        children: posts.map((post) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: _buildPostCard(
                              postId: post['id'],
                              communityName: post['communityName'] ?? 'General',
                              userName: post['userName'] ?? 'User',
                              location: post['location'] ?? 'Unknown',
                              content: post['content'] ?? '',
                              likes: post['likes'].toString(),
                              comments: post['comments'].toString(),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ] else ...[
                // Joined Communities
                FutureBuilder<List<String>>(
                  future: DatabaseHelper().getJoinedCommunities(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }
                    final joined = snapshot.data ?? [];
                    if (joined.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "You haven't joined any communities yet.",
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                DatabaseHelper().joinCommunity('Expert Hub').then((_) {
                                  setState(() {});
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('Join Expert Hub Demo'),
                            )
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      itemCount: joined.length,
                      itemBuilder: (context, index) {
                        final title = joined[index];
                         String imgPath = 'assets/cotton.png';
                         if (title.toLowerCase().contains('veg')) imgPath = 'assets/vegetables.png';
                         if (title.toLowerCase().contains('rice')) imgPath = 'assets/rice.png';
                         if (title.toLowerCase().contains('sugar')) imgPath = 'assets/sugarcane.png';
                         if (title.toLowerCase().contains('corn')) imgPath = 'assets/corn.png';
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: _buildCommunityCard(
                            title,
                            'Joined Community',
                            imgPath,
                            isJoined: true,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar (Assuming standard navigation for expert)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: primaryGreen,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 3, // Community is selected
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Learning tools',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Market Place',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LearningToolsScreen()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MarketplaceScreen()));
          } else if (index == 4) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
          }
        },
      ),
    );
  }

  // --- Modular UI Builders ---


  Widget _buildCommunityAvatar(String name, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommunityDetailsScreen(communityName: name),
          ),
        ).then((_) => setState(() {}));
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipOval(
                child: Transform.scale(
                  scale: (imagePath.contains('cotton') || imagePath.contains('corn')) 
                      ? 1.2 
                      : ((imagePath.contains('vegetable') || imagePath.contains('rice') || imagePath.contains('sugar')) ? 1.1 : 1.0),
                  alignment: Alignment.center,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityCard(String title, String members, String imagePath, {bool isJoined = false}) {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade600, // Placeholder background
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white, width: 1), // White outline
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            Positioned.fill(
              child: Transform.scale(
                scale: (imagePath.contains('cotton') || imagePath.contains('corn')) 
                    ? 1.2 
                    : ((imagePath.contains('vegetable') || imagePath.contains('rice') || imagePath.contains('sugar')) ? 1.1 : 1.0),
                alignment: Alignment.center,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.black87, Colors.transparent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        members,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      if (!isJoined)
                        ElevatedButton(
                          onPressed: () async {
                            await DatabaseHelper().joinCommunity(title);
                            if (!mounted) return;
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('You joined $title!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Join', style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      else
                        ElevatedButton(
                          onPressed: () async {
                            await DatabaseHelper().leaveCommunity(title);
                            if (!mounted) return;
                            setState(() {});
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('You left $title!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Leave', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommunityDetailsScreen(communityName: title),
                            ),
                          ).then((_) => setState(() {}));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('View', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTab(String title, bool isSelected, int count, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 5),
              if (isSelected)
                Container(width: 40, height: 3, color: Colors.white)
              else
                const SizedBox(height: 3), // Maintain height when not selected
            ],
          ),
          if (count > 0 && title == 'My feed') ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white54,
                shape: BoxShape.circle,
              ),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCreatePostCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _postController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Share your advice or question here...',
                    hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.public, color: Colors.white, size: 16),
                  SizedBox(width: 5),
                  Text(
                    'Add your post in ',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Black button as in image
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  'Publish Post',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard({
    required int postId,
    required String communityName,
    required String userName,
    required String location,
    required String content,
    required String likes,
    required String comments,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF2C6330), // Slightly darker green for post card
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Posted in $communityName',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunityDetailsScreen(communityName: communityName),
                    ),
                  );
                },
                child: const Text(
                  'view community',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white54, thickness: 1),
          const SizedBox(height: 10),

          // User Info
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        userName.replaceAll(' (Expert)', ''),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (userName.contains('(Expert)'))
                        Container(
                          margin: const EdgeInsets.only(left: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Expert',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    location,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Content
          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 15),
          const Divider(color: Colors.white54, thickness: 1),
          const SizedBox(height: 10),

          // Footer (Likes, Comments, Share)
          Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 20),
              const SizedBox(width: 5),
              Text(
                likes,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(width: 20),

              GestureDetector(
                onTap: () {
                  _showCommentsBottomSheet(context, postId);
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      comments,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const Spacer(),
              const Icon(Icons.ios_share, color: Colors.white, size: 20),
              const SizedBox(width: 5),
              const Text(
                'Share',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, int postId) {
    final TextEditingController commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF2C6330), // Match post background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Comments',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(color: Colors.white54, thickness: 1),
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: DatabaseHelper().getCommentsForPost(postId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: Colors.white));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text(
                              'No comments yet. Be the first to reply!',
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }
                        final commentsList = snapshot.data!;
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          itemCount: commentsList.length,
                          itemBuilder: (context, index) {
                            final comment = commentsList[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.grey,
                                    child: Icon(Icons.person, color: Colors.white, size: 20),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                (comment['userName'] ?? 'User').toString().replaceAll(' (Expert)', ''),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              if ((comment['userName'] ?? '').toString().contains('(Expert)'))
                                                Container(
                                                  margin: const EdgeInsets.only(left: 5),
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: const Text(
                                                    'Expert',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 8,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            comment['content'] ?? '',
                                            style: const TextStyle(color: Colors.white, fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const Divider(color: Colors.white54, thickness: 1, height: 1),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextField(
                              controller: commentController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Write a reply...',
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                            icon: const Icon(Icons.send, color: Color(0xFF2C6330)),
                            onPressed: () async {
                              if (commentController.text.trim().isEmpty) return;
                              await DatabaseHelper().insertComment({
                                'postId': postId,
                                'userName': DatabaseHelper.loggedInUser,
                                'content': commentController.text.trim(),
                              });
                              commentController.clear();
                              setStateBottomSheet(() {}); // Refresh comments in bottom sheet
                              setState(() {}); // Refresh post card comment count in background
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

