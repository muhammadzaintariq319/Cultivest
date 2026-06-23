import 'package:flutter/material.dart';
import 'package:cultivest_app/screens/settings/privacy_security_screen.dart';
import 'package:cultivest_app/screens/settings/about_us_screen.dart';
import 'package:provider/provider.dart';
import 'package:cultivest_app/providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryGreen = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: primaryGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            _buildSettingsTile(
              Icons.dark_mode,
              'Dark Mode',
              trailingWidget: Consumer<ThemeProvider>(
                builder: (context, themeProvider, _) {
                  return Switch(
                    value: themeProvider.themeMode == ThemeMode.dark,
                    onChanged: (val) {
                      themeProvider.toggleTheme(val);
                    },
                    activeColor: Colors.white,
                    activeTrackColor: Colors.green.shade800,
                  );
                }
              ),
            ),
            _buildSettingsTile(
              Icons.security,
              'Privacy & Security',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrivacySecurityScreen()),
                );
              },
            ),
            _buildSettingsTile(
              Icons.info_outline,
              'About Us',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {Widget? trailingWidget, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 28),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        trailing: trailingWidget ?? const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
        onTap: onTap,
      ),
    );
  }
}

