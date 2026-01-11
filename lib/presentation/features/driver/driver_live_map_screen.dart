import 'package:flutter/material.dart';

class DriverLiveMapScreen extends StatefulWidget {
  const DriverLiveMapScreen({super.key});

  @override
  State<DriverLiveMapScreen> createState() => _DriverLiveMapScreenState();
}

class _DriverLiveMapScreenState extends State<DriverLiveMapScreen> {
  bool _isTripActive = true;
  String _currentStop = 'Main Street Stop';
  int _currentStopIndex = 1;
  int _studentsOnBoard = 18;
  int _totalStudents = 24;

  final List<Map<String, dynamic>> _routeStops = [
    {
      'id': 'STP-001',
      'name': 'Bus Depot',
      'time': '7:00 AM',
      'type': 'start',
      'status': 'completed',
      'students': 0,
      'location': {'lat': 40.7128, 'lng': -74.0060},
    },
    {
      'id': 'STP-002',
      'name': 'Main Street Stop',
      'time': '7:30 AM',
      'type': 'pickup',
      'status': 'current',
      'students': 5,
      'location': {'lat': 40.7589, 'lng': -73.9851},
    },
    {
      'id': 'STP-003',
      'name': 'Oak Avenue Stop',
      'time': '7:45 AM',
      'type': 'pickup',
      'status': 'upcoming',
      'students': 8,
      'location': {'lat': 40.7812, 'lng': -73.9665},
    },
    {
      'id': 'STP-004',
      'name': 'Pine Road Stop',
      'time': '8:00 AM',
      'type': 'pickup',
      'status': 'upcoming',
      'students': 4,
      'location': {'lat': 40.8397, 'lng': -73.9408},
    },
    {
      'id': 'STP-005',
      'name': 'Greenwood High',
      'time': '8:15 AM',
      'type': 'school',
      'status': 'upcoming',
      'students': 0,
      'location': {'lat': 40.7489, 'lng': -73.9680},
    },
    {
      'id': 'STP-006',
      'name': 'Sunrise Academy',
      'time': '3:30 PM',
      'type': 'school',
      'status': 'upcoming',
      'students': 0,
      'location': {'lat': 40.7289, 'lng': -73.9500},
    },
  ];

  final List<Map<String, dynamic>> _nearbyStops = [
    {'name': 'Next: Oak Avenue Stop', 'distance': '1.2 km', 'eta': '5 min'},
    {'name': 'Pine Road Stop', 'distance': '3.5 km', 'eta': '12 min'},
    {'name': 'Greenwood High', 'distance': '8.2 km', 'eta': '25 min'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Map Container
          Container(
            height: 250,
            decoration: BoxDecoration(
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
                        'Live Route Tracking',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isTripActive ? 'Trip in Progress' : 'Trip Not Started',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // Map Controls
                Positioned(
                  top: 16,
                  right: 16,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        onPressed: () {},
                        child: const Icon(Icons.zoom_in),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        onPressed: () {},
                        child: const Icon(Icons.zoom_out),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        onPressed: () {},
                        child: const Icon(Icons.my_location),
                      ),
                    ],
                  ),
                ),
                // Bus Indicator
                Positioned(
                  left: 0.5,
                  top: 0.5,
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
                          color: _isTripActive ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'B-101',
                          style: TextStyle(
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

          // Trip Status Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isTripActive ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _isTripActive ? Icons.directions_bus : Icons.directions_bus_outlined,
                          color: _isTripActive ? Colors.green : Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isTripActive ? 'Trip in Progress' : 'Trip Not Started',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              _currentStop,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isTripActive,
                        onChanged: (value) {
                          setState(() {
                            _isTripActive = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildTripStat('On Board', '$_studentsOnBoard/$_totalStudents', Icons.people),
                      _buildTripStat('Next Stop', '5 min', Icons.timelapse),
                      _buildTripStat('Speed', '45 km/h', Icons.speed),
                      _buildTripStat('ETA to School', '25 min', Icons.schedule),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Route Stops
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue,
                    tabs: [
                      Tab(text: 'Route Stops'),
                      Tab(text: 'Navigation'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Route Stops Tab
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Route Stops',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ..._routeStops.map((stop) {
                                return _buildStopCard(stop);
                              }).toList(),
                            ],
                          ),
                        ),
                        // Navigation Tab
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Navigation',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Nearby Stops
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Upcoming Stops',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ..._nearbyStops.map((stop) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.location_on, size: 20, color: Colors.blue),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      stop['name'],
                                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                                    ),
                                                    Text(
                                                      '${stop['distance']} • ${stop['eta']} ETA',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.directions, size: 20),
                                                onPressed: () {
                                                  _startNavigation(stop['name']);
                                                },
                                                tooltip: 'Start Navigation',
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Quick Actions
                              const Text(
                                'Quick Actions',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 2.5,
                                children: [
                                  _buildQuickAction('Arrive at Stop', Icons.flag, Colors.green),
                                  _buildQuickAction('Depart Stop', Icons.play_arrow, Colors.blue),
                                  _buildQuickAction('Report Delay', Icons.timelapse, Colors.orange),
                                  _buildQuickAction('Emergency', Icons.warning, Colors.red),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Navigation Controls
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Navigation Controls',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed: () {},
                                              icon: const Icon(Icons.replay),
                                              label: const Text('Reroute'),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed: () {},
                                              icon: const Icon(Icons.announcement),
                                              label: const Text('Announce'),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed: () {},
                                              icon: const Icon(Icons.map),
                                              label: const Text('Map View'),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: OutlinedButton.icon(
                                              onPressed: () {},
                                              icon: const Icon(Icons.list),
                                              label: const Text('List View'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }

  Widget _buildTripStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 20),
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

  Widget _buildStopCard(Map<String, dynamic> stop) {
    IconData icon;
    Color color;

    switch (stop['status']) {
      case 'completed':
        icon = Icons.check_circle;
        color = Colors.green;
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

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Status Icon
            Icon(icon, color: color),
            const SizedBox(width: 12),

            // Stop Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        stop['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (stop['type'] == 'pickup')
                        Chip(
                          label: Text(
                            '${stop['students']} students',
                            style: const TextStyle(fontSize: 10),
                          ),
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          labelStyle: const TextStyle(color: Colors.blue),
                        ),
                      if (stop['type'] == 'school')
                        Chip(
                          label: const Text(
                            'SCHOOL',
                            style: TextStyle(fontSize: 10),
                          ),
                          backgroundColor: Colors.purple.withOpacity(0.1),
                          labelStyle: const TextStyle(color: Colors.purple),
                        ),
                    ],
                  ),
                  Text(
                    stop['time'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            if (stop['status'] == 'current')
              ElevatedButton.icon(
                onPressed: () {
                  _arriveAtStop(stop);
                },
                icon: const Icon(Icons.flag, size: 16),
                label: const Text('Arrive'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              )
            else if (stop['status'] == 'upcoming')
              OutlinedButton.icon(
                onPressed: () {
                  _setNextStop(stop);
                },
                icon: const Icon(Icons.navigate_next, size: 16),
                label: const Text('Next'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(String label, IconData icon, Color color) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        onTap: () {
          if (label == 'Emergency') {
            _triggerEmergency();
          } else if (label == 'Report Delay') {
            _reportDelay();
          } else if (label == 'Arrive at Stop') {
            _arriveAtCurrentStop();
          } else if (label == 'Depart Stop') {
            _departFromStop();
          }
        },
      ),
    );
  }

  void _arriveAtStop(Map<String, dynamic> stop) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Arrive at Stop'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flag,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              stop['name'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (stop['type'] == 'pickup')
              Text(
                'Pickup ${stop['students']} students',
                style: const TextStyle(color: Colors.grey),
              ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
                hintText: 'Any notes about this stop...',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Arrived at ${stop['name']}'),
                  backgroundColor: Colors.green,
                ),
              );
              // Update stop status
              setState(() {
                for (var s in _routeStops) {
                  if (s['status'] == 'current') {
                    s['status'] = 'completed';
                  }
                }
                stop['status'] = 'current';
              });
            },
            child: const Text('Confirm Arrival'),
          ),
        ],
      ),
    );
  }

  void _setNextStop(Map<String, dynamic> stop) {
    setState(() {
      for (var s in _routeStops) {
        if (s['status'] == 'current') {
          s['status'] = 'completed';
        }
      }
      stop['status'] = 'current';
      _currentStop = stop['name'];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Next stop set to: ${stop['name']}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _startNavigation(String destination) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Navigation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.navigation,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Navigate to $destination?',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Google Maps will open with navigation',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Navigation started to $destination'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Start Navigation'),
          ),
        ],
      ),
    );
  }

  void _triggerEmergency() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Emergency Alert'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'This will send an emergency alert to all administrators and emergency contacts.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              'Please confirm this is an actual emergency situation.',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('EMERGENCY ALERT SENT!'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 5),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('SEND ALERT'),
          ),
        ],
      ),
    );
  }

  void _reportDelay() {
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
                'Report Delay',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Notify parents and school about delay',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Delay Reason',
                  border: OutlineInputBorder(),
                ),
                items: [
                  'Traffic',
                  'Accident',
                  'Road Construction',
                  'Weather',
                  'Mechanical Issue',
                  'Other'
                ].map((reason) => DropdownMenuItem(
                  value: reason,
                  child: Text(reason),
                )).toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Estimated Delay (minutes)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Additional Details',
                  border: OutlineInputBorder(),
                  hintText: 'Provide more details about the delay...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Notify Parents'),
                subtitle: const Text('Send notification to all affected parents'),
                value: true,
                onChanged: (value) {},
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Delay reported successfully'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  },
                  child: const Text('Report Delay'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _arriveAtCurrentStop() {
    final currentStop = _routeStops.firstWhere(
          (stop) => stop['status'] == 'current',
      orElse: () => _routeStops.first,
    );
    _arriveAtStop(currentStop);
  }

  void _departFromStop() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Depart from Stop'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_arrow,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              'Confirm departure from current stop?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'This will mark the current stop as completed',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Departed from stop'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirm Departure'),
          ),
        ],
      ),
    );
  }
}