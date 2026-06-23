import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({Key? key}) : super(key: key);

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
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
          'Real-Time Temperature',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.white54,
            height: 1.0,
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Location Section
            const Text(
              'Your Location',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _currentAddress,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 30),

            // 2. Current Temperature Card
            const Text(
              'Current Temperature',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Temperature',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '36°C',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 3. Real-Time Temperature Graph (Updated with fl_chart)
            const Text(
              'Real-Time Temperature',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 220, // Graph height
              padding: const EdgeInsets.only(
                right: 20,
                left: 5,
                top: 20,
                bottom: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: true,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontSize: 9,
                          );
                          Widget text;
                          switch (value.toInt()) {
                            case 0:
                              text = const Text('21 May', style: style);
                              break;
                            case 1:
                              text = const Text('22 May', style: style);
                              break;
                            case 2:
                              text = const Text('23 May', style: style);
                              break;
                            case 3:
                              text = const Text('24 May', style: style);
                              break;
                            case 4:
                              text = const Text('25 May', style: style);
                              break;
                            case 5:
                              text = const Text('26 May', style: style);
                              break;
                            default:
                              text = const Text('', style: style);
                              break;
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: text,
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black12),
                  ),
                  minX: 0,
                  maxX: 5,
                  minY: 20,
                  maxY: 45,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 28), // 21 May
                        FlSpot(1, 40), // 22 May
                        FlSpot(2, 32), // 23 May
                        FlSpot(3, 41), // 24 May
                        FlSpot(4, 33), // 25 May
                        FlSpot(5, 27), // 26 May
                      ],
                      isCurved: false,
                      color: Colors.blue, // Blue line matching your design
                      barWidth: 1.5,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(
                        show: true,
                      ), // Show dots on data points
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 4. Weather Updates List
            const Text(
              'Weather Updates',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildWeatherTile(
              Icons.wb_sunny,
              'Morning',
              'Clear and sunny',
              '24°C',
            ),
            _buildDivider(),
            _buildWeatherTile(
              Icons.cloud_queue,
              'Afternoon',
              'Mostly sunny',
              '36°C',
            ),
            _buildDivider(),
            _buildWeatherTile(
              Icons.water_drop_outlined,
              'Evening',
              'Possibility of rain',
              '30°C',
            ),
            _buildDivider(),
          ],
        ),
      ),
    );
  }

  // --- Modular UI Builders ---
  Widget _buildWeatherTile(
    IconData icon,
    String title,
    String subtitle,
    String temp,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.orangeAccent, size: 24),
          ),
          const SizedBox(width: 15),
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
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            temp,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(color: Colors.white54, thickness: 1, height: 20);
  }
}

