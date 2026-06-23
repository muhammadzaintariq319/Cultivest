import 'package:flutter/material.dart';
import 'package:cultivest_app/core/database/database_helper.dart';
import 'package:cultivest_app/screens/community/community_details_screen.dart';

class AllCommunitiesScreen extends StatefulWidget {
  const AllCommunitiesScreen({super.key});

  @override
  State<AllCommunitiesScreen> createState() => _AllCommunitiesScreenState();
}

class _AllCommunitiesScreenState extends State<AllCommunitiesScreen> {
  Color get primaryGreen => Theme.of(context).primaryColor;

  // Hardcoded list of all available communities for the app
  final List<Map<String, String>> allCommunities = [
    {
      'title': 'Cotton Community',
      'members': '4.3 (10K+ members)',
      'image': 'assets/cotton.png',
    },
    {
      'title': 'Vegetable garden',
      'members': '4.3 (10K+ members)',
      'image': 'assets/vegetables.png',
    },
    {
      'title': 'Planting rice',
      'members': '4.8 (12K+ members)',
      'image': 'assets/rice.png',
    },
    {
      'title': 'Sugarcane',
      'members': '4.5 (8K+ members)',
      'image': 'assets/sugarcane.png',
    },
    {
      'title': 'Corn Community',
      'members': '4.6 (9K+ members)',
      'image': 'assets/corn.png',
    },
    {
      'title': 'Planting Wheat',
      'members': '4.7 (11K+ members)',
      'image': 'assets/wheat.png',
    },
    {
      'title': 'Expert Hub',
      'members': '5.0 (2K+ experts)',
      'image': 'assets/exporthub.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'All Communities',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<String>>(
          future: DatabaseHelper().getJoinedCommunities(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            final joinedList = snapshot.data ?? [];

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              itemCount: allCommunities.length,
              itemBuilder: (context, index) {
                final comm = allCommunities[index];
                final isJoined = joinedList.contains(comm['title']);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: _buildCommunityCard(
                    comm['title']!,
                    comm['members']!,
                    comm['image']!,
                    isJoined: isJoined,
                  ),
                );
              },
            );
          },
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
}

