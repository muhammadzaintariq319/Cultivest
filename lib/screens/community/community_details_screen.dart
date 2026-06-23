import 'package:flutter/material.dart';
import 'package:cultivest_app/core/database/database_helper.dart';

class CommunityDetailsScreen extends StatefulWidget {
  final String communityName;

  const CommunityDetailsScreen({Key? key, required this.communityName})
    : super(key: key);

  @override
  State<CommunityDetailsScreen> createState() => _CommunityDetailsScreenState();
}

class _CommunityDetailsScreenState extends State<CommunityDetailsScreen> {
  Color get primaryGreen => Theme.of(context).primaryColor;
  final TextEditingController _postController = TextEditingController();

  Future<void> _submitPost() async {
    if (_postController.text.trim().isEmpty) return;

    await DatabaseHelper().insertPost({
      'communityName': widget.communityName,
      'userName': DatabaseHelper.loggedInUser,
      'location': 'Pakistan',
      'content': _postController.text.trim(),
      'likes': 0,
      'comments': 0,
    });

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            const Icon(Icons.groups_outlined, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            Text(
              widget.communityName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<String>>(
          future: DatabaseHelper().getJoinedCommunities(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }
            final isJoined = (snapshot.data ?? []).contains(widget.communityName);

            return Column(
              children: [
                if (!isJoined)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    color: Colors.black26,
                    child: Column(
                      children: [
                        const Icon(Icons.group_add, color: Colors.white, size: 40),
                        const SizedBox(height: 10),
                        const Text(
                          'You haven\'t joined this community yet.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () async {
                            await DatabaseHelper().joinCommunity(widget.communityName);
                            setState(() {}); // Re-render to show post creation and feed
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('You joined ${widget.communityName}!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('Join Community', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  )
                else ...[
                  // Create Post Field specific to this community
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: _buildCreatePostCard(),
                  ),
                  const Divider(color: Colors.white54, thickness: 1, height: 1),
                ],
                // Community Posts Feed
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: DatabaseHelper().getPostsForCommunity(
                      widget.communityName,
                    ),
                    builder: (context, postSnapshot) {
                      if (postSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      if (!postSnapshot.hasData || postSnapshot.data!.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'No messages here yet. Be the first to post!',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          ),
                        );
                      }

                      final posts = postSnapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: _buildPostCard(
                              postId: post['id'],
                              communityName:
                                  post['communityName'] ?? widget.communityName,
                              userName: post['userName'] ?? 'User',
                              location: post['location'] ?? 'Unknown',
                              content: post['content'] ?? '',
                              likes: post['likes'].toString(),
                              comments: post['comments'].toString(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
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
                  decoration: InputDecoration(
                    hintText: 'Post a message in ${widget.communityName}...',
                    hintStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
                  'Post Message',
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
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
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                      size: 20,
                                    ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
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
                            icon: const Icon(
                              Icons.send,
                              color: Color(0xFF2C6330),
                            ),
                            onPressed: () async {
                              if (commentController.text.trim().isEmpty) return;
                              await DatabaseHelper().insertComment({
                                'postId': postId,
                                'userName': DatabaseHelper.loggedInUser,
                                'content': commentController.text.trim(),
                              });
                              commentController.clear();
                              setStateBottomSheet(
                                () {},
                              ); // Refresh comments in bottom sheet
                              setState(
                                () {},
                              ); // Refresh post card comment count in background
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

