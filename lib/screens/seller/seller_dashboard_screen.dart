import 'package:flutter/material.dart';
import 'package:cultivest_app/screens/seller/new_listing_screen.dart';
import 'package:cultivest_app/screens/seller/my_products_screen.dart';
import 'package:cultivest_app/screens/seller/incoming_orders_screen.dart';
import 'package:cultivest_app/screens/profile/profile_screen.dart';
import 'package:cultivest_app/screens/community/community_screen.dart';
import 'package:cultivest_app/screens/settings/notifications_settings_screen.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryGreen = Theme.of(context).primaryColor;
    const textDarkGreen = Color(
      0xFF1E5B22,
    ); // Buttons ke text ka dark green color

    return Scaffold(
      backgroundColor: primaryGreen,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Dashboard par back button nahi hota
        title: const Text(
          'Cultivest',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsSettingsScreen()));
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDashboardButton(
                  context: context,
                  icon: Icons.add,
                  title: 'Add New Product',
                  textColor: textDarkGreen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NewListingScreen()),
                    );
                  },
                ),
                _buildDashboardButton(
                  context: context,
                  icon: Icons.inventory_2,
                  title: 'Manage Listings',
                  textColor: textDarkGreen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyProductsScreen()),
                    );
                  },
                ),
                _buildDashboardButton(
                  context: context,
                  icon: Icons.list_alt, // Order list icon
                  title: 'Orders',
                  textColor: textDarkGreen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const IncomingOrdersScreen()),
                    );
                  },
                ),
                _buildDashboardButton(
                  context: context,
                  icon: Icons.groups_outlined,
                  title: 'Community',
                  textColor: textDarkGreen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CommunityScreen()),
                    );
                  },
                ),
                _buildDashboardButton(
                  context: context,
                  icon: Icons.person_outline,
                  title: 'Profile',
                  textColor: textDarkGreen,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Modular UI Builder for Seller Dashboard Buttons ---
  Widget _buildDashboardButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: double.infinity,
          height: 65, // Bade buttons jaisa image mein hai
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 4), // Neechay ki taraf shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 22),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

