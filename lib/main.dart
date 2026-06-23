import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cultivest_app/screens/auth/role_selection_screen.dart';
import 'package:cultivest_app/screens/dashboard/main_wrapper.dart';
import 'package:cultivest_app/screens/seller/seller_dashboard_screen.dart';
import 'package:cultivest_app/providers/theme_provider.dart';
import 'package:cultivest_app/providers/auth_provider.dart';
import 'package:cultivest_app/providers/product_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else if (defaultTargetPlatform == TargetPlatform.windows || 
             defaultTargetPlatform == TargetPlatform.linux || 
             defaultTargetPlatform == TargetPlatform.macOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()..fetchProducts()),
      ],
      child: const CultivestApp(),
    ),
  );
}

class CultivestApp extends StatelessWidget {
  const CultivestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cultivest',
      theme: ThemeData(
        primaryColor: const Color(0xFF367B3B),
        scaffoldBackgroundColor: const Color(0xFF367B3B),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primaryColor: const Color(0xFF1E1E1E),
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        brightness: Brightness.dark,
      ),
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // 3 Seconds baad next screen par navigate karega
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.loadSession();
    
    if (!mounted) return;

    if (authProvider.isLoggedIn) {
      if (authProvider.loggedInRole == 'seller') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SellerDashboardScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainWrapper()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset('assets/cultivest_logo.png', width: 120),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cultivest',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

