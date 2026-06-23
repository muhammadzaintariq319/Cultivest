import 'package:flutter/material.dart';

class GuidanceDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const GuidanceDetailsScreen({super.key, required this.item});

  @override
  State<GuidanceDetailsScreen> createState() => _GuidanceDetailsScreenState();
}

class _GuidanceDetailsScreenState extends State<GuidanceDetailsScreen> {
  Color get primaryGreen => Theme.of(context).primaryColor;
  bool _isPlaying = false;
  double _videoProgress = 0.3;
  double _zoomLevel = 1.0;
  int _pdfPage = 1;

  @override
  Widget build(BuildContext context) {
    final title = widget.item['title'] ?? 'Guidance Title';
    final category = widget.item['category'] ?? 'General';
    final description = widget.item['description'] ?? 'No description provided.';
    final contentType = widget.item['contentType'] ?? 'Video';
    final isVideo = contentType == 'Video';

    return Scaffold(
      backgroundColor: primaryGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isVideo ? 'Video Guidance' : 'Document Guidance',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Media Preview Area (Video Player or PDF Viewer Mock)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: isVideo ? _buildVideoPlayerMock() : _buildPdfReaderMock(),
                  ),
                ),
              ),

              // 2. Info Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category and Type Chips
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isVideo ? Colors.red.shade700 : Colors.amber.shade700,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isVideo ? 'Video' : 'PDF Document',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Divider
                    const Divider(color: Colors.white38),
                    const SizedBox(height: 15),

                    // Description Label
                    const Text(
                      'Overview & Description',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Description Content
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Beautiful interactive mock Video Player
  Widget _buildVideoPlayerMock() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Simulated video background
        Image.network(
          'https://images.unsplash.com/photo-1592982537447-7440770cbfc9?auto=format&fit=crop&w=800&q=80',
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black45,
        ),
        // Play Center Button
        Center(
          child: IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: Colors.white,
              size: 70,
            ),
            onPressed: () {
              setState(() {
                _isPlaying = !_isPlaying;
              });
            },
          ),
        ),
        // Video Controls Bottom Bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                // Small Play/Pause Toggle
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                ),
                // Time Duration
                const Text(
                  '01:12',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                // Progress Slider
                Expanded(
                  child: Slider(
                    value: _videoProgress,
                    activeColor: Colors.red.shade700,
                    inactiveColor: Colors.white24,
                    onChanged: (val) {
                      setState(() {
                        _videoProgress = val;
                      });
                    },
                  ),
                ),
                const Text(
                  '03:45',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.fullscreen, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Beautiful interactive mock PDF Reader
  Widget _buildPdfReaderMock() {
    return Container(
      color: Colors.grey.shade100,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Simulated page rendering
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Transform.scale(
                  scale: _zoomLevel,
                  child: Column(
                    children: [
                      Icon(Icons.description, color: primaryGreen, size: 48),
                      const SizedBox(height: 10),
                      Text(
                        'Page $_pdfPage of 5',
                        style: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'This document contains expert guidelines regarding cultivation, optimal water usage, and crop protection strategies to maximize yield.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Zoom & Page controls overlay
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Zoom controls
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.zoom_out, color: Colors.white, size: 18),
                        onPressed: () {
                          if (_zoomLevel > 0.8) {
                            setState(() {
                              _zoomLevel -= 0.1;
                            });
                          }
                        },
                      ),
                      Text(
                        '${(_zoomLevel * 100).toInt()}%',
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                      IconButton(
                        icon: const Icon(Icons.zoom_in, color: Colors.white, size: 18),
                        onPressed: () {
                          if (_zoomLevel < 1.5) {
                            setState(() {
                              _zoomLevel += 0.1;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                // Page Navigation
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 14),
                        onPressed: () {
                          if (_pdfPage > 1) {
                            setState(() {
                              _pdfPage--;
                            });
                          }
                        },
                      ),
                      Text(
                        'Page $_pdfPage/5',
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
                        onPressed: () {
                          if (_pdfPage < 5) {
                            setState(() {
                              _pdfPage++;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

