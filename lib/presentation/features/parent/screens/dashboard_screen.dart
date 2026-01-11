import 'package:bustracker_007/presentation/features/admin/screens/settings_screen.dart';
import 'package:bustracker_007/presentation/features/parent/screens/live_map_screen.dart';
import 'package:bustracker_007/presentation/features/parent/screens/settings_screen.dart';
import 'package:bustracker_007/presentation/features/parent/screens/status_screen.dart';
import 'package:bustracker_007/presentation/features/parent/screens/students_screen.dart';
import 'package:flutter/material.dart';
import 'package:bustracker_007/core/theme/app_theme.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ParentDashboardScreen(),
    StudentsScreen(), // Student management
    StatusScreen(), // Status management
    ParentLiveMapScreen(), // Live map
    ParentSettingsScreen(), // Settings
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Portal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Live Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Welcome Back,',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            'Sarah Johnson',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today\'s Schedule',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildScheduleItem(
                    'Emily Johnson',
                    'Pickup: 7:30 AM',
                    'Bus #B-101',
                    Icons.school,
                    Colors.blue,
                  ),
                  const Divider(),
                  _buildScheduleItem(
                    'Michael Johnson',
                    'Drop-off: 3:45 PM',
                    'Bus #B-102',
                    Icons.home,
                    Colors.green,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Children Status',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildChildStatus(
                    'Emily Johnson',
                    'Present',
                    'Grade 5',
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildChildStatus(
                    'Michael Johnson',
                    'Absent',
                    'Grade 3',
                    Colors.red,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Notifications',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildNotification(
                    context,
                    'Bus delayed by 15 minutes',
                    'Due to traffic on Route 1',
                    Icons.timer,
                  ),
                  const SizedBox(height: 12),
                  _buildNotification(
                    context,
                    'Parent-Teacher Meeting',
                    'Tomorrow at 3:00 PM',
                    Icons.event,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(
      String name, String time, String bus, IconData icon, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(name),
      subtitle: Text(time),
      trailing: Chip(
        label: Text(bus),
        backgroundColor: color.withOpacity(0.1),
        labelStyle: TextStyle(color: color),
      ),
    );
  }

  Widget _buildChildStatus(String name, String status, String grade, Color color) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(
          status == 'Present' ? Icons.check : Icons.close,
          color: color,
        ),
      ),
      title: Text(name),
      subtitle: Text(grade),
      trailing: Chip(
        label: Text(status),
        backgroundColor: color.withOpacity(0.1),
        labelStyle: TextStyle(color: color),
      ),
    );
  }

  Widget _buildNotification(BuildContext context,String title, String subtitle, IconData icon) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}