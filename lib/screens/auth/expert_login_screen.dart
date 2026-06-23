import 'package:flutter/material.dart';
import 'package:cultivest_app/screens/auth/forgot_password_screen.dart';
import 'package:cultivest_app/screens/auth/expert_registration_screen.dart';
import 'package:cultivest_app/screens/dashboard/main_wrapper.dart';
import 'package:cultivest_app/core/database/database_helper.dart';

import 'package:provider/provider.dart';
import 'package:cultivest_app/providers/auth_provider.dart';

class ExpertLoginScreen extends StatefulWidget {
  const ExpertLoginScreen({super.key});

  @override
  State<ExpertLoginScreen> createState() => _ExpertLoginScreenState();
}

class _ExpertLoginScreenState extends State<ExpertLoginScreen> {
  // Form Validation ke liye Key (Mandatory Requirement)
  final _formKey = GlobalKey<FormState>();

  // Input Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Password hide/show toggle
  bool _isObscure = true;

  @override
  void dispose() {
    // Memory management
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    // Input Validation Logic
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      bool emailExists = await authProvider.checkEmailExists(email, 'expert');
      if (!mounted) return;

      if (!emailExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'This email is not registered. Please sign up first.',
            ),
          ),
        );
        return;
      }

      bool success = await authProvider.login(email, password, 'expert');
      if (!mounted) return;

      if (success) {
        // Append (Expert) to DatabaseHelper username for display purposes
        DatabaseHelper.loggedInUser = '${authProvider.loggedInUser} (Expert)';
        
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainWrapper()),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Incorrect password')));
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
                const SizedBox(height: 30),

                // 1. Logo
                Center(
                  child: Container(
                    width: 130,
                    height: 130,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Transform.scale(
                        scale: 1.5,
                        child: Image.asset(
                          'assets/cultivest_logo.png',
                          width: 90,
                          height: 90,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 2. Welcome Text (Updated for Expert)
                const Center(
                  child: Text(
                    'Welcome Back Expert !',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // 3. Username/Email Field
                _buildLabel('Username/Email'),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Enter your email or username',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email or username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // 4. Password Field
                _buildLabel('Enter Password'),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),

                // 5. Forgot Password Text
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    // YAHAN NAVIGATION ADD KI GAYI HAI 👇
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(top: 8, right: 0),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Forgot password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 6. Login Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // 7. Sign Up Redirect Text
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ExpertRegistrationScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        text: "Don't have an account ? ",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
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

  // --- Reusable Widgets (Modular Code Architecture) --- //

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
    required String hintText,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? _isObscure : false,
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
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
      ),
    );
  }
}

