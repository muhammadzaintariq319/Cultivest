import 'package:flutter/material.dart';

import 'package:cultivest_app/screens/auth/forgot_password_screen.dart';
import 'package:cultivest_app/screens/auth/registration_screen.dart';
import 'package:cultivest_app/screens/dashboard/main_wrapper.dart';
import 'package:provider/provider.dart';
import 'package:cultivest_app/providers/auth_provider.dart';

class FarmerLoginScreen extends StatefulWidget {
  const FarmerLoginScreen({super.key});

  @override
  State<FarmerLoginScreen> createState() => _FarmerLoginScreenState();
}

class _FarmerLoginScreenState extends State<FarmerLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

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
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Welcome, Back Farmer !',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                _buildLabel('Username/Email'),
                _buildTextField(
                  controller: _emailController,
                  hint: 'Enter your email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _buildLabel('Enter Password'),
                _buildPasswordField(),
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
                _buildLoginButton(primaryGreen),
                const SizedBox(height: 50),
                _buildSignUpRedirect(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable Components
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 4),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: controller,
    validator: validator,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.white70),
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
    ),
  );

  Widget _buildPasswordField() => TextFormField(
    controller: _passwordController,
    obscureText: _isObscure,
    style: const TextStyle(color: Colors.white),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your password';
      }
      return null;
    },
    decoration: InputDecoration(
      hintText: 'Enter your password',
      hintStyle: const TextStyle(color: Colors.white70, fontSize: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: Colors.white70),
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
      suffixIcon: IconButton(
        icon: Icon(
          _isObscure ? Icons.visibility_off : Icons.visibility,
          color: Colors.white70,
        ),
        onPressed: () => setState(() => _isObscure = !_isObscure),
      ),
    ),
  );

  Widget _buildLoginButton(Color color) => Consumer<AuthProvider>(
    builder: (context, authProvider, child) {
      return SizedBox(
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final email = _emailController.text.trim();
              final password = _passwordController.text;
              
              bool emailExists = await authProvider.checkEmailExists(email, 'farmer');
              if (!context.mounted) return;
              
              if (!emailExists) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This email is not registered. Please sign up first.')),
                );
                return;
              }

              bool success = await authProvider.login(email, password, 'farmer');
              if (!context.mounted) return;

              if (success) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainWrapper(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Incorrect password')),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: const Text(
            'Login',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  );

  Widget _buildSignUpRedirect() => Center(
    child: GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RegistrationScreen()),
        );
      },
      child: RichText(
        text: const TextSpan(
          text: "Don't have an account ? ",
          style: TextStyle(color: Colors.white70),
          children: [
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}

