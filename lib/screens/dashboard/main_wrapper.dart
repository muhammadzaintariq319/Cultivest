import 'package:flutter/material.dart';
import 'package:cultivest_app/screens/dashboard/home_screen.dart';
import 'package:cultivest_app/screens/learning/learning_tools_screen.dart';
import 'package:cultivest_app/screens/marketplace/marketplace_screen.dart';
import 'package:cultivest_app/screens/community/community_screen.dart';
import 'package:cultivest_app/screens/profile/profile_screen.dart';
import 'package:cultivest_app/core/database/database_helper.dart';
import 'package:cultivest_app/screens/seller/seller_dashboard_screen.dart';

class MainWrapper extends StatefulWidget {
  final int initialIndex;
  
  const MainWrapper({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // The pages to display.
  // Note: For expert/seller, we might want to swap out the HomeScreen or other screens, 
  // but for now we follow the general 5-tab structure.
  final List<Widget> _pages = [
    // We can conditionally inject different screens based on role if needed,
    // but the original app used the same bottom nav items with different body content.
    // To keep it safe, if loggedInRole == 'seller', tab 0 is SellerDashboardScreen
    DatabaseHelper.loggedInRole == 'seller' ? const SellerDashboardScreen() : const HomeScreen(),
    const LearningToolsScreen(),
    const MarketplaceScreen(),
    const CommunityScreen(),
    const ProfileScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.menu_book_outlined),
      label: 'Learning tools',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.insights),
      label: 'Market Place',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.groups_outlined),
      label: 'Community',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_outlined),
      label: 'Profile',
    ),
  ];

  final List<NavigationRailDestination> _railItems = const [
    NavigationRailDestination(
      icon: Icon(Icons.home_outlined),
      label: Text('Home'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.menu_book_outlined),
      label: Text('Learning tools'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.insights),
      label: Text('Market Place'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.groups_outlined),
      label: Text('Community'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.account_circle_outlined),
      label: Text('Profile'),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If width is less than 600, show BottomNavigationBar
        if (constraints.maxWidth < 600) {
          return Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Theme.of(context).primaryColor,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              currentIndex: _currentIndex,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              onTap: _onItemTapped,
              items: _navItems,
            ),
          );
        } else {
          // If width is 600 or more, show NavigationRail
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  backgroundColor: Theme.of(context).primaryColor,
                  selectedIconTheme: const IconThemeData(color: Colors.white),
                  unselectedIconTheme: const IconThemeData(color: Colors.white70),
                  selectedLabelTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
                  unselectedLabelTextStyle: const TextStyle(color: Colors.white70, fontSize: 12),
                  selectedIndex: _currentIndex,
                  onDestinationSelected: _onItemTapped,
                  labelType: NavigationRailLabelType.all,
                  destinations: _railItems,
                ),
                const VerticalDivider(thickness: 1, width: 1, color: Colors.white24),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _pages,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
