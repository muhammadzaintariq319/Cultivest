import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cultivest_app/core/database/database_helper.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Color get primaryGreen => Theme.of(context).primaryColor;

  // Controllers mein pehle se data assign kar diya hai taake pre-filled form banay
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _dobController;
  late TextEditingController _countryController;

  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    String pureName = DatabaseHelper.loggedInUser.replaceAll(' (Expert)', '');
    _nameController = TextEditingController(text: pureName);
    _emailController = TextEditingController(text: DatabaseHelper.loggedInEmail);
    _passwordController = TextEditingController(text: '********');
    _dobController = TextEditingController(text: DatabaseHelper.loggedInDob.isNotEmpty ? DatabaseHelper.loggedInDob : '23/05/2001');
    _countryController = TextEditingController(
      text: DatabaseHelper.loggedInCountry.isNotEmpty ? DatabaseHelper.loggedInCountry : 'Multan, Punjab, Pakistan',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    _countryController.dispose();
    super.dispose();
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
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Profile Picture with Camera Icon Badge
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade400,
                        image: _imageFile != null
                            ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                            : (DatabaseHelper.loggedInProfilePicture.isNotEmpty
                                ? DecorationImage(
                                    image: FileImage(File(DatabaseHelper.loggedInProfilePicture)),
                                    fit: BoxFit.cover,
                                  )
                                : null),
                      ),
                      child: _imageFile == null && DatabaseHelper.loggedInProfilePicture.isEmpty
                          ? ClipOval(
                              child: const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white70,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF2B5B2E,
                            ), // Darker green for camera badge
                            shape: BoxShape.circle,
                            border: Border.all(color: primaryGreen, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 2. Form Fields
              _buildLabel('Name'),
              _buildTextField(controller: _nameController),
              const SizedBox(height: 15),

              _buildLabel('Email'),
              _buildTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),

              _buildLabel('Password'),
              _buildTextField(
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 15),

              // Date of Birth (Mocked as Dropdown with suffix icon)
              _buildLabel('Date of Birth'),
              _buildTextField(
                controller: _dobController,
                readOnly: true,
                suffixIcon: Icons.keyboard_arrow_down,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dobController.text = "\${pickedDate.day}/\${pickedDate.month}/\${pickedDate.year}";
                    });
                  }
                },
              ),
              const SizedBox(height: 15),

              // Country/Region (Mocked as Dropdown with suffix icon)
              _buildLabel('Country/Region'),
              _buildTextField(
                controller: _countryController,
                readOnly: true,
                suffixIcon: Icons.keyboard_arrow_down,
                onTap: () {
                  // TODO: Yahan Location Picker ya Dropdown list open hogi
                  print("Country Picker Clicked");
                },
              ),
              const SizedBox(height: 40),

              // 3. Save Changes Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    String finalImagePath = _imageFile?.path ?? DatabaseHelper.loggedInProfilePicture;
                    
                    String updatedName = _nameController.text.trim();
                    if (DatabaseHelper.loggedInRole == 'expert') {
                      DatabaseHelper.loggedInUser = '$updatedName (Expert)';
                    } else {
                      DatabaseHelper.loggedInUser = updatedName;
                    }
                    DatabaseHelper.loggedInEmail = _emailController.text.trim();
                    DatabaseHelper.loggedInProfilePicture = finalImagePath;
                    DatabaseHelper.loggedInDob = _dobController.text.trim();
                    DatabaseHelper.loggedInCountry = _countryController.text.trim();

                    await DatabaseHelper().updateUser({
                      'name': updatedName,
                      'email': DatabaseHelper.loggedInEmail,
                      'profile_picture': finalImagePath,
                      'dob': DatabaseHelper.loggedInDob,
                      'country': DatabaseHelper.loggedInCountry,
                      // Note: Intentionally not changing password if it's full of asterisks
                    }, DatabaseHelper.loggedInEmail, DatabaseHelper.loggedInRole);

                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                      ),
                    );
                    Navigator.pop(
                      context,
                    ); // Wapas profile screen par le jaye ga
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- Modular UI Builders ---

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
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

  Widget _buildTextField({
    required TextEditingController controller,
    bool obscureText = false,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    IconData? suffixIcon,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.white70, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: Colors.white)
            : null,
      ),
    );
  }
}

