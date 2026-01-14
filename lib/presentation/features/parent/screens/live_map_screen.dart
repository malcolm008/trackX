import 'package:flutter/material.dart';

class ParentLiveMapScreen extends StatefulWidget {
  const ParentLiveMapScreen({super.key});

  @override
  State<ParentLiveMapScreen> createState() => _ParentLiveMapScreenState();
}

class _ParentLiveMapScreenState extends State<ParentLiveMapScreen> {
  final List<Map<String, dynamic>> _childRoutes = [
    {
      'student': 'Emily Johnson',
      'busNumber': 'B-101',
      'driver': 'John Smith',
      'route': 'Route 1',
      'status': 'moving',
      'currentLocation': 'Downtown Area',
      'nextStop': 'Maple Street Stop',
      'etaToNextStop': '5 min',
      'etaToSchool': '15 min',
      'passengers': 28,
      'capacity': 45,
      'speed': '45 km/h',
      'coordinates': {'lat': 40.7128, 'lng': -74.0060},
      'stops': [
        {'name': 'Home (Pickup)', 'time': '7:30 AM', 'status': 'completed'},
        {'name': 'Maple Street', 'time': '7:45 AM', 'status': 'upcoming'},
        {'name': 'Oak Avenue', 'time': '8:00 AM', 'status': 'upcoming'},
        {'name': 'Greenwood High', 'time': '8:15 AM', 'status': 'upcoming'},
      ],
    },
    {
      'student': 'Michael Johnson',
      'busNumber': 'B-102',
      'driver': 'Sarah Johnson',
      'route': 'Route 2',
      'status': 'stopped',
      'currentLocation': 'Sunrise Station',
      'nextStop': 'Valley Road',
      'etaToNextStop': '10 min',
      'etaToSchool': '30 min',
      'passengers': 15,
      'capacity': 35,
      'speed': '0 km/h',
      'coordinates': {'lat': 40.7589, 'lng': -73.9851},
      'stops': [
        {'name': 'Home (Pickup)', 'time': '7:45 AM', 'status': 'completed'},
        {'name': 'Sunrise Station', 'time': '8:00 AM', 'status': 'current'},
        {'name': 'Valley Road', 'time': '8:15 AM', 'status': 'upcoming'},
        {'name': 'Sunrise Academy', 'time': '8:30 AM', 'status': 'upcoming'},
      ],
    },
  ];

  int _selectedChildIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selectedRoute = _childRoutes[_selectedChildIndex];

    return Column(
      children: [
        // Child Selector
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  // Child Selection
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_childRoutes.length, (index) {
                      final route = _childRoutes[index];
                      return ChoiceChip(
                        label: Text(route['student']),
                        selected: _selectedChildIndex == index,
                        onSelected: (selected) {
                          setState(() {
                            _selectedChildIndex = index;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
            ],
          )
        ),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Map View
                Container(
                  height: 250,
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue[50],
                  ),
                  child: Stack(
                    children: [
                      // Map Placeholder
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map_outlined,
                              size: 64,
                              color: Colors.blue[300],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Live Map View',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tracking: ${selectedRoute['student']}\'s Bus',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      // Map Controls
                      Positioned(
                        top: 12,
                        right: 12,
                        child: FloatingActionButton.small(
                          onPressed: () {},
                          child: const Icon(Icons.my_location, color: Colors.purple,),
                        ),
                      ),
                      // Bus Indicator
                      Positioned(
                        left: 0.4,
                        top: 0.4,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.directions_bus,
                                color: _getStatusColor(selectedRoute['status']),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                selectedRoute['busNumber'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Current Status Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(selectedRoute['status']).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.directions_bus,
                                  color: _getStatusColor(selectedRoute['status']),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bus ${selectedRoute['busNumber']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      selectedRoute['currentLocation'],
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Chip(
                                label: Text(
                                  selectedRoute['status'].toString().toUpperCase(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: _getStatusColor(selectedRoute['status']).withOpacity(0.1),
                                labelStyle: TextStyle(
                                  color: _getStatusColor(selectedRoute['status']),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Stats Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildRouteStat('Speed', selectedRoute['speed'], Icons.speed),
                              _buildRouteStat('ETA to School', selectedRoute['etaToSchool'], Icons.schedule),
                              _buildRouteStat('Capacity', '${selectedRoute['passengers']}/${selectedRoute['capacity']}', Icons.people),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Route Stops
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Route Stops',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...selectedRoute['stops'].map<Widget>((stop) {
                            return _buildStopItem(
                              stop['name'],
                              stop['time'],
                              stop['status'],
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Driver Information
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Driver Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const CircleAvatar(
                              child: Icon(Icons.person, color: Colors.deepPurple,),
                            ),
                            title: Text(
                              selectedRoute['driver'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text('Professional Driver'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.phone),
                                  onPressed: () {},
                                  tooltip: 'Call Driver',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.message),
                                  onPressed: () {},
                                  tooltip: 'Message Driver',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Emergency & Actions
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.notifications),
                              label: const Text('Get Notifications'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.share_location),
                              label: const Text('Share Location'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showReportIssueDialog();
                          },
                          icon: const Icon(Icons.report_problem),
                          label: const Text('Report Issue'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRouteStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStopItem(String name, String time, String status) {
    IconData icon;
    Color color;

    switch (status) {
      case 'completed':
        icon = Icons.check_circle;
        color = Colors.teal;
        break;
      case 'current':
        icon = Icons.radio_button_checked;
        color = Colors.blue;
        break;
      case 'upcoming':
      default:
        icon = Icons.radio_button_unchecked;
        color = Colors.grey;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          if (status == 'current')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Current',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showReportIssueDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Report an Issue',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Let us know if there\'s a problem with the bus or route',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              // Issue Type
              const Text(
                'Issue Type',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Late Bus',
                  'Safety Concern',
                  'Route Change',
                  'Driver Issue',
                  'Other'
                ].map((type) {
                  return FilterChip(
                    label: Text(type),
                    selected: false,
                    onSelected: (selected) {},
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Description
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  hintText: 'Please describe the issue in detail...',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              // Urgency
              const Text(
                'Urgency Level',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Low'),
                      selected: true,
                      onSelected: (selected) {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Medium'),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('High'),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Issue reported successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Submit Report'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'moving':
        return Colors.teal;
      case 'stopped':
        return Colors.blue;
      case 'delayed':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}