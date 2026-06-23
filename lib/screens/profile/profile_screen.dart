import 'dart:io';
import 'package:flutter/material.dart';

// --- Saari connected screens ke imports ---
import 'package:cultivest_app/screens/profile/edit_profile_screen.dart';
import 'package:cultivest_app/screens/settings/notifications_settings_screen.dart';
import 'package:cultivest_app/screens/settings/help_support_screen.dart';
import 'package:cultivest_app/screens/auth/role_selection_screen.dart'; // Logout hone ke baad yahan jayega
import 'package:cultivest_app/screens/settings/settings_screen.dart';
import 'package:cultivest_app/core/database/database_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // --- Logout Bottom Sheet Function ---
  void _showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Colors.transparent, // Transparent for custom rounded corners
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap content height
            children: [
              const SizedBox(height: 30),
              const Text(
                'Are You Sure You Want to Logout?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Cancel Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(
                        context,
                      ), // Sirf Bottom sheet band karega
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0D6EFD), // Blue text
                        side: const BorderSide(
                          color: Color(0xFF0D6EFD),
                          width: 1.5,
                        ), // Blue border
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Yes, Logout Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await DatabaseHelper.clearLoginSession();

                        if (context.mounted) {
                          // Saari pichli screens ko khatam kar ke seedha Role Selection par bhej dega
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RoleSelectionScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D6EFD), // Solid Blue
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Yes, Logout',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: primaryGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Navigator.canPop(context)
            ? GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 1. Profile Picture
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade400,
                  border: Border.all(color: Colors.white24, width: 2),
                  image: DatabaseHelper.loggedInProfilePicture.isNotEmpty
                      ? DecorationImage(
                          image: FileImage(
                            File(DatabaseHelper.loggedInProfilePicture),
                          ),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: DatabaseHelper.loggedInProfilePicture.isEmpty
                    ? ClipOval(
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white70,
                        ),
                      )
                    : null,
              ),
              const SizedBox(height: 15),

              // 2. Name and Email
              Text(
                DatabaseHelper.loggedInUser,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                DatabaseHelper.loggedInEmail.isNotEmpty
                    ? DatabaseHelper.loggedInEmail
                    : 'No Email Added',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 25),

              // Divider Line
              const Divider(color: Colors.white54, thickness: 1),
              const SizedBox(height: 20),

              // 3. Menu Options List connected to respective screens
              _buildMenuOption(Icons.person, 'Edit profile', () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
                setState(() {}); // Rebuild screen to show updated profile info
              }),

              _buildMenuOption(Icons.settings_outlined, 'Settings', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              }),

              _buildMenuOption(Icons.chat_bubble_rounded, 'Notifications', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsSettingsScreen(),
                  ),
                );
              }),

              _buildMenuOption(Icons.help_outline, 'Help & Support', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpSupportScreen(),
                  ),
                );
              }),

              const SizedBox(height: 40),

              // 4. Logout Button triggers Bottom Sheet
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    _showLogoutBottomSheet(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                      255,
                      198,
                      14,
                      14,
                    ), // Red Color
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- Modular UI Builder for Menu Options ---
  Widget _buildMenuOption(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.black87, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
