import 'package:flutter/material.dart';
import 'admin_responsive_layout.dart';
import 'screens/subscriptions_screen.dart';
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
    'Subscriptions',
    'Users',
    'Schools',
    'Live Map',
    'Settings',
  ];

  final List<Widget> _screens = [
    AdminDashboardScreen(),
    const SubscriptionsScreen(),
    const UsersScreen(),
    const SchoolsScreen(),
    const LiveMapScreen(),
    const SettingsScreen(),
  ];

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
    );
  }
}