import 'package:bustracker_007/presentation/features/admin/screens/analytics_screen.dart';
import 'package:bustracker_007/presentation/features/admin/screens/billing_screen.dart';
import 'package:flutter/material.dart';
import 'admin_responsive_layout.dart';
import 'screens/users_screen.dart';
import 'screens/schools_screen.dart';
import 'screens/live_map_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/dashboard_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;
  final List<String> _screenTitles = [
    'Dashboard',
    'Users',
    'Schools',
    'Live Map',
    'Billing',
    'Analytics',
    'Settings',
  ];

  final List<Widget> _screens = [
    AdminDashboardScreen(),
    const UsersScreen(),
    const SchoolsScreen(),
    const LiveMapScreen(),
    const BillingScreen(),
    const AnalyticsScreen(),
    const SettingsScreen(),
  ];

  void _handleNavigation(String screenTitle) {
    final index = _screenTitles.indexOf(screenTitle);
    if (index != -1) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminResponsiveLayout(
      title: _screenTitles[_currentIndex],
      body: _screens[_currentIndex],
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
          tooltip: 'Notifications',
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
          tooltip: 'Search',
        ),
        const SizedBox(width: 8),
      ],
      onNavigationSelected: _handleNavigation,
    );
  }
}