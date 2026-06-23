import 'package:flutter/material.dart';
import 'package:cultivest_app/screens/auth/seller_login_screen.dart';
import 'dart:io';
// import 'package:image_picker/image_picker.dart';

import 'package:provider/provider.dart';
import 'package:cultivest_app/providers/auth_provider.dart';

class SellerRegistrationScreen extends StatefulWidget {
  const SellerRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<SellerRegistrationScreen> createState() => _SellerRegistrationScreenState();
}

class _SellerRegistrationScreenState extends State<SellerRegistrationScreen> {
  // Form ki state aur validation ko control karne ke liye GlobalKey
  final _formKey = GlobalKey<FormState>();

  // Controllers to get user input (Mandatory for Data Handling)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Password hide/show state
  bool _isObscure = true;
  bool _isObscureConfirm = true;

  File? _imageFile;

  // Future<void> _pickImage() async {
  //   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = File(pickedFile.path);
  //     });
  //   }
  // }

  @override
  void dispose() {
    // Memory leak se bachne ke liye controllers ko dispose karna zaroori hai
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    // Form Validation check
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final email = _emailController.text.trim();
      
      // Check if email already exists
      bool emailExists = await authProvider.checkEmailExists(email, 'seller');
      if (emailExists) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This email is already registered! Please use a different email or login.')),
        );
        return;
      }

      bool success = await authProvider.register({
        'name': _nameController.text.trim(),
        'email': email,
        'phone': _phoneController.text.trim(),
        'password': _passwordController.text,
        'profile_picture': _imageFile?.path ?? '',
      }, 'seller');
      
      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Seller Account Created Successfully!')),
        );
        
        // SnackBar show hone ke baad foran Login screen par navigate karein
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SellerLoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: primaryGreen,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // 1. Screen Title
                const Center(
                  child: Text(
                    'Create Seller Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),



                // Name Field
                _buildLabel('Full Name'),
                _buildTextField(
                  controller: _nameController,
                  hintText: 'Enter your name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // 3. Email Field
                _buildLabel('Email'),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // 3. Phone Number Field
                _buildLabel('Phone Number'),
                _buildTextField(
                  controller: _phoneController,
                  hintText: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) {
                      return 'Phone number must be exactly 11 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // 4. Password Field
                _buildLabel('Enter Password'),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Enter a strong password',
                  isPassword: true,
                  showVisibilityToggle: true,
                  currentObscureState: _isObscure,
                  onVisibilityToggle: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (!value.contains(RegExp(r'[A-Z]'))) {
                      return 'Password must contain at least one uppercase letter';
                    }
                    if (!value.contains(RegExp(r'[0-9]'))) {
                      return 'Password must contain at least one number';
                    }
                    if (!value.contains(RegExp(r'[!@#\$&*~_+\-\=\^%]'))) {
                      return 'Password must contain at least one special character';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // 5. Confirm Password Field with Visibility Icon
                _buildLabel('Confirm Password'),
                _buildTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm your password',
                  isPassword: true,
                  showVisibilityToggle: true,
                  currentObscureState: _isObscureConfirm,
                  onVisibilityToggle: () {
                    setState(() {
                      _isObscureConfirm = !_isObscureConfirm;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // 6. Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 7. Login Redirect Text
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SellerLoginScreen()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: 'If you have an Account ? ',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    bool showVisibilityToggle = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool? currentObscureState,
    VoidCallback? onVisibilityToggle,
  }) {
    bool obscure = showVisibilityToggle ? (currentObscureState ?? true) : isPassword;

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
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
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        suffixIcon: showVisibilityToggle
            ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: onVisibilityToggle,
              )
            : null,
      ),
    );
  }
}

