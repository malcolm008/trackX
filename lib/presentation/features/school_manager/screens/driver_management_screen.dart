import 'package:flutter/material.dart';

class DriverManagementScreen extends StatefulWidget {
  const DriverManagementScreen({super.key});

  @override
  State<DriverManagementScreen> createState() => _DriverManagementScreenState();
}

class _DriverManagementScreenState extends State<DriverManagementScreen> {
  final List<Map<String, dynamic>> _drivers = [
    {
      'id': 'D-001',
      'name': 'John Smith',
      'phone': '+1234567890',
      'email': 'john@example.com',
      'license': 'DL-123456',
      'status': 'active',
      'assignedBus': 'B-101',
    },
    {
      'id': 'D-002',
      'name': 'Sarah Johnson',
      'phone': '+1234567891',
      'email': 'sarah@example.com',
      'license': 'DL-123457',
      'status': 'active',
      'assignedBus': 'B-102',
    },
    {
      'id': 'D-003',
      'name': 'Mike Wilson',
      'phone': '+1234567892',
      'email': 'mike@example.com',
      'license': 'DL-123458',
      'status': 'on_leave',
      'assignedBus': 'B-103',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add driver
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              hintText: 'Search drivers...',
              leading: const Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _drivers.length,
              itemBuilder: (context, index) {
                final driver = _drivers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text(driver['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(driver['phone']),
                        Text(driver['email']),
                      ],
                    ),
                    trailing: Chip(
                      label: Text(
                        driver['status'].replaceAll('_', ' '),
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: _getStatusColor(driver['status']).withOpacity(0.1),
                      labelStyle: TextStyle(color: _getStatusColor(driver['status'])),
                    ),
                    onTap: () {
                      // Navigate to driver details
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
      case 'on_leave':
        return Colors.orange;
      case 'inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}