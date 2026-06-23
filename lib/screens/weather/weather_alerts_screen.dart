import 'package:flutter/material.dart';

class WeatherAlertsScreen extends StatelessWidget {
  const WeatherAlertsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryGreen = Theme.of(context).primaryColor;

    return DefaultTabController(
      length: 2, // Total number of tabs (Active Alerts, Past Alerts)
      child: Scaffold(
        backgroundColor: primaryGreen,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Weather Alerts',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              // TabBar design matching the image
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.transparent,
                  // The selected tab border is handled in unselected/selected styles below
                ),
                indicatorWeight: 0, // Removes default bottom line
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: Center(child: Text('Active Alerts')),
                    ),
                  ),
                  Tab(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.5),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Center(child: Text('Past Alerts')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // --- Tab 1: Active Alerts View ---
            _buildActiveAlertsView(context),

            // --- Tab 2: Past Alerts View ---
            const Center(
              child: Text(
                'No past alerts',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for the Active Alerts Content
  Widget _buildActiveAlertsView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Weather Alerts',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Alert Tiles
          _buildAlertTile(
            Icons.warning,
            Colors.red,
            'Heatwave Warning',
            'Critical Alert: Extreme temperatures expected.',
            'Issued: 2 hours ago',
          ),
          _buildDivider(),
          _buildAlertTile(
            Icons.flash_on,
            Colors.orangeAccent,
            'Storm Warning',
            'Strong thunderstorms with heavy rain.',
            'Issued: 1 hour ago',
          ),
          _buildDivider(),
          _buildAlertTile(
            Icons.water_drop,
            Colors.lightBlue,
            'Heavy Rainfall Alert',
            'Moderate Alert: Heavy rain expected tonight.',
            'Issued: 3 hours ago',
          ),
          _buildDivider(),
          _buildAlertTile(
            Icons.ac_unit,
            Colors.lightBlueAccent,
            'Frost Warning',
            'Risk of frost conditions late tonight.',
            'Issued: 4 hours ago',
          ),
          const SizedBox(height: 30),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(
                      context,
                    ).primaryColor, // Green text
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'View Resources',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Dark background
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Take Action',
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
  }

  // Reusable Alert Tile
  Widget _buildAlertTile(
    IconData icon,
    Color iconColor,
    String title,
    String description,
    String time,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Circle
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 15),

          // Alert Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Time & Megaphone Icon
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time.replaceAll(
                  ' ',
                  '\n',
                ), // Split into two lines like the design
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Icon(
                Icons.campaign,
                color: Colors.white54,
                size: 20,
              ), // Megaphone icon
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.white24, thickness: 1, height: 10);
  }
}
