import 'package:flutter/material.dart';

class RouteManagementScreen extends StatefulWidget {
  const RouteManagementScreen({super.key});

  @override
  State<RouteManagementScreen> createState() => _RouteManagementScreenState();
}

class _RouteManagementScreenState extends State<RouteManagementScreen> {
  final List<Map<String, dynamic>> _routes = [
    {
      'id': 'R-001',
      'name': 'Downtown Route',
      'distance': '15.2 km',
      'stops': '8',
      'duration': '45 min',
      'status': 'active',
      'driver': 'John Smith',
      'bus': 'B-101',
    },
    {
      'id': 'R-002',
      'name': 'Suburban Route',
      'distance': '22.5 km',
      'stops': '12',
      'duration': '60 min',
      'status': 'active',
      'driver': 'Sarah Johnson',
      'bus': 'B-102',
    },
    {
      'id': 'R-003',
      'name': 'North Campus Route',
      'distance': '8.7 km',
      'stops': '6',
      'duration': '30 min',
      'status': 'inactive',
      'driver': 'Mike Wilson',
      'bus': 'B-103',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add route
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              hintText: 'Search routes...',
              leading: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _routes.length,
              itemBuilder: (context, index) {
                final route = _routes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.route,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text(route['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${route['distance']} • ${route['stops']} stops'),
                        Text('Driver: ${route['driver']} • Bus: ${route['bus']}'),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(
                        route['status'],
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: _getStatusColor(route['status']).withOpacity(0.1),
                      labelStyle: TextStyle(color: _getStatusColor(route['status'])),
                    ),
                    onTap: () {
                      // Navigate to route details
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}