import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cultivest_app/core/database/database_helper.dart';

class UploadContentScreen extends StatefulWidget {
  const UploadContentScreen({super.key});

  @override
  State<UploadContentScreen> createState() => _UploadContentScreenState();
}

class _UploadContentScreenState extends State<UploadContentScreen> {
  Color get primaryGreen => Theme.of(context).primaryColor;

  // State variables selections ke liye
  String _selectedCategory = 'Wheat';
  String _selectedContentType = 'Video';

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _filePathController = TextEditingController();
  final TextEditingController _progressController = TextEditingController();

  final List<String> _categories = [
    'Wheat',
    'Cotton',
    'Fertilizer',
    'Livestock',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _filePathController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final ImagePicker picker = ImagePicker();
    XFile? file;
    if (_selectedContentType == 'Video') {
      file = await picker.pickVideo(source: ImageSource.gallery);
    } else {
      file = await picker.pickImage(source: ImageSource.gallery);
    }

    if (file != null) {
      setState(() {
        _filePathController.text = file!.path.split(RegExp(r'[/\\]')).last;
        _progressController.text = '0% - Initializing...';
      });

      // Micro-animation mockup upload progress for high fidelity!
      for (int i = 20; i <= 100; i += 20) {
        await Future.delayed(const Duration(milliseconds: 250));
        if (!mounted) return;
        setState(() {
          if (i == 100) {
            _progressController.text = '100% - Upload Complete!';
          } else {
            _progressController.text = '$i% - Uploading...';
          }
        });
      }
    }
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
        title: const Text(
          'Upload Content',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Video Title
              _buildLabel('Video Title'),
              _buildTextField('Enter the title of the video', controller: _titleController),
              const SizedBox(height: 20),

              // 2. Category Selection (Chips)
              _buildLabel('Category'),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: _categories.map((category) {
                  return _buildCategoryChip(category);
                }).toList(),
              ),
              const SizedBox(height: 20),

              // 3. Short Description
              _buildLabel('Short Description'),
              _buildTextField('', maxLines: 2, controller: _descriptionController),
              const SizedBox(height: 20),

              // 4. Content Type Selection
              _buildLabel('Content Type'),
              Row(
                children: [
                  Expanded(
                    child: _buildContentTypeCard(
                      'Video',
                      Icons.video_camera_back,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildContentTypeCard('PDF', Icons.picture_as_pdf),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 5. Upload Video Field
              _buildLabel(_selectedContentType == 'Video' ? 'Upload Video' : 'Upload PDF/Image'),
              _buildTextField(
                'Select a ${_selectedContentType.toLowerCase()} to upload', 
                readOnly: true,
                controller: _filePathController,
              ),
              const SizedBox(height: 15),

              // 6. Select Video Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _pickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _selectedContentType == 'Video' ? 'Select Video' : 'Select PDF/Image',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 7. Video Preview Field
              _buildLabel('Preview'),
              _buildTextField('Thumbnail/Preview will appear here', readOnly: true),
              const SizedBox(height: 20),

              // 8. Upload Progress
              _buildLabel('Upload Progress'),
              _buildTextField(
                '0% - Uploading...', 
                readOnly: true,
                controller: _progressController,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 5.0, left: 5.0),
                child: Text(
                  'Upload progress will be displayed here',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ),
              const SizedBox(height: 30),

              // 9. Submit Guidance Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_titleController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a title')),
                      );
                      return;
                    }
                    if (_descriptionController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a description')),
                      );
                      return;
                    }

                    final messenger = ScaffoldMessenger.of(context);
                    final navigator = Navigator.of(context);

                    await DatabaseHelper().insertLearningContent({
                      'title': _titleController.text.trim(),
                      'category': _selectedCategory,
                      'description': _descriptionController.text.trim(),
                      'contentType': _selectedContentType,
                    });

                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Content Submitted Successfully!'),
                      ),
                    );
                    navigator.pop(); // Wapas pichli screen par le jaye
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Submit Guidance',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // --- Modular UI Builders ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    int maxLines = 1,
    bool readOnly = false,
    TextEditingController? controller,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white70, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String title) {
    bool isSelected = _selectedCategory == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 1),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? primaryGreen : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildContentTypeCard(String title, IconData icon) {
    bool isSelected = _selectedContentType == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedContentType = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white24 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white70,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

