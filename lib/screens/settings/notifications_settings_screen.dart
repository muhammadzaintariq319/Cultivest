import 'package:flutter/material.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  Color get primaryGreen => Theme.of(context).primaryColor;

  // State variables har notification toggle ke liye
  bool isMarketplaceAlertsOn = true;
  bool isOrderConfirmationOn = true;
  bool isOrderCancellationOn = true;
  bool isWeatherAlertsOn = true;
  bool isNewExpertSessionOn = true;
  bool isSubsidyUpdatesOn = true;
  bool isAppUpdatesOn = true;

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
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              _buildNotificationToggle(
                'Marketplace Alerts',
                isMarketplaceAlertsOn,
                (val) => setState(() => isMarketplaceAlertsOn = val),
              ),
              _buildDivider(),

              _buildNotificationToggle(
                'Order Confirmation',
                isOrderConfirmationOn,
                (val) => setState(() => isOrderConfirmationOn = val),
              ),
              _buildDivider(),

              _buildNotificationToggle(
                'Order Cancellation',
                isOrderCancellationOn,
                (val) => setState(() => isOrderCancellationOn = val),
              ),
              _buildDivider(),

              _buildNotificationToggle(
                'Weather Alerts',
                isWeatherAlertsOn,
                (val) => setState(() => isWeatherAlertsOn = val),
              ),
              _buildDivider(),

              _buildNotificationToggle(
                'New Expert Session',
                isNewExpertSessionOn,
                (val) => setState(() => isNewExpertSessionOn = val),
              ),
              _buildDivider(),

              _buildNotificationToggle(
                'Subsidy & Scheme Updates',
                isSubsidyUpdatesOn,
                (val) => setState(() => isSubsidyUpdatesOn = val),
              ),
              _buildDivider(),

              _buildNotificationToggle(
                'App Updates & Features',
                isAppUpdatesOn,
                (val) => setState(() => isAppUpdatesOn = val),
              ),
              _buildDivider(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Modular UI Builders ---

  Widget _buildNotificationToggle(
    String title,
    bool currentValue,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          // Customizing Switch to look like iOS/Modern Switch
          Transform.scale(
            scale: 0.9, // Thora chota karne ke liye taake design se match kare
            child: Switch(
              value: currentValue,
              onChanged: onChanged,
              activeColor: primaryGreen, // Green dot inside
              activeTrackColor: Colors.white, // White background when ON
              inactiveThumbColor: Colors.grey.shade400, // Grey dot when OFF
              inactiveTrackColor: Colors.white54, // Dull background when OFF
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: Colors.white24, // Halka (faded) divider jaisa image mein hai
      thickness: 1,
      height: 10,
    );
  }
}

