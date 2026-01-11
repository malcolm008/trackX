import 'package:flutter/material.dart';
import 'package:bustracker_007/presentation/widgets/cards/stat_card.dart';
import 'bus_management_screen.dart';
import 'driver_management_screen.dart';
import 'route_management_screen.dart';

class SchoolManagerHome extends StatefulWidget {
  const SchoolManagerHome({super.key});

  @override
  State<SchoolManagerHome> createState() => _SchoolManagerHomeState();
}

class _SchoolManagerHomeState extends State<SchoolManagerHome> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const BusManagementScreen(),
    const RouteManagementScreen(),
    Container(color: Colors.blue), // Student assignment screen
    Container(color: Colors.purple), // Live map screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('School Manager Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
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
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus_outlined),
            activeIcon: Icon(Icons.directions_bus),
            label: 'Buses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.route_outlined),
            activeIcon: Icon(Icons.route),
            label: 'Routes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Live Map',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Wrap(
            spacing: 20,
            runSpacing: 16,
            children: [
              StatCard(
                title: 'Total Buses',
                value: '24',
                icon: Icons.directions_bus,
                color: Colors.blue,
                onTap: () {},
              ),
              StatCard(
                title: 'Active Drivers',
                value: '18',
                icon: Icons.person,
                color: Colors.green,
                onTap: () {},
              ),
              StatCard(
                title: 'Total Routes',
                value: '12',
                icon: Icons.route,
                color: Colors.orange,
                onTap: () {},
              ),
              StatCard(
                title: 'Active Students',
                value: '485',
                icon: Icons.school,
                color: Colors.purple,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Recent Activities',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildActivityItem(
                    'Bus #B-101 started route',
                    '5 min ago',
                    Icons.directions_bus,
                    Colors.green,
                  ),
                  const Divider(),
                  _buildActivityItem(
                    'Driver John checked in',
                    '15 min ago',
                    Icons.person,
                    Colors.blue,
                  ),
                  const Divider(),
                  _buildActivityItem(
                    'Route #R-05 completed',
                    '30 min ago',
                    Icons.route,
                    Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(time),
    );
  }
}