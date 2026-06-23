import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class WeatherConditionScreen extends StatefulWidget {
  const WeatherConditionScreen({Key? key}) : super(key: key);

  @override
  State<WeatherConditionScreen> createState() => _WeatherConditionScreenState();
}

class _WeatherConditionScreenState extends State<WeatherConditionScreen> {
  String _currentAddress = 'Fetching location...';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentAddress = 'Lahore, Pakistan';
        });
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _currentAddress = 'Lahore, Pakistan';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _currentAddress = 'Lahore, Pakistan';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddress = '${place.locality ?? 'Lahore'}, ${place.country ?? 'Pakistan'}';
        });
      } else {
        setState(() {
          _currentAddress = 'Lahore, Pakistan';
        });
      }
    } catch (e) {
      setState(() {
        _currentAddress = 'Lahore, Pakistan';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = Theme.of(context).primaryColor;

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
          'Current Weather Conditions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Location Header
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    // Yahan farm ki actual image laga sakte hain: Image.asset('assets/farm.png')
                    child: Icon(Icons.grass, color: primaryGreen, size: 30),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _currentAddress,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            // 2. Current Weather Section
            const Text(
              'Current Weather',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // Grid layout for weather details
            Row(
              children: [
                Expanded(child: _buildWeatherCard('Temperature', '28°C')),
                const SizedBox(width: 10),
                Expanded(child: _buildWeatherCard('Wind Speed', '15 km/h')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildWeatherCard('Humidity', '60%')),
                const SizedBox(width: 10),
                Expanded(child: _buildWeatherCard('Chance of Rain', '30%')),
              ],
            ),
            const SizedBox(height: 10),
            // Full width card for Air Pressure
            _buildWeatherCard('Air Pressure', '1015 hPa', isFullWidth: true),

            const SizedBox(height: 30),

            // 3. Forecast Section
            const Text(
              '3-5 Day Forecast',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            _buildForecastTile(
              Icons.wb_sunny,
              'Day 1',
              'Sunny',
              '30°C',
              '20°C',
            ),
            _buildDivider(),
            _buildForecastTile(
              Icons.cloud_queue,
              'Day 2',
              'Partly Cloudy',
              '28°C',
              '19°C',
            ),
            _buildDivider(),
            _buildForecastTile(
              Icons.water_drop_outlined,
              'Day 3',
              'Showers Expected',
              '25°C',
              '18°C',
            ),
            _buildDivider(),
            _buildForecastTile(
              Icons.wb_sunny,
              'Day 4',
              'Sunny',
              '29°C',
              '21°C',
            ),
            _buildDivider(),
          ],
        ),
      ),
    );
  }

  // --- Modular UI Builders ---

  // Reusable card for weather metrics
  Widget _buildWeatherCard(
    String title,
    String value, {
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Reusable tile for forecast list
  Widget _buildForecastTile(
    IconData icon,
    String day,
    String condition,
    String highTemp,
    String lowTemp,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Weather Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.orangeAccent, size: 28),
          ),
          const SizedBox(width: 15),

          // Day and Condition
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  condition,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          // High/Low Temps
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'High: $highTemp',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Low: $lowTemp',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(width: 10),

          // Small Trailing Icon (Placeholder for the mini gradient image)
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.orange],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white, width: 1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.white54, thickness: 1, height: 10);
  }
}

