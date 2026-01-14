// File: lib/presentation/features/school_manager/screens/live_map_screen.dart

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SchoolLiveMapScreen extends StatefulWidget {
  const SchoolLiveMapScreen({super.key});

  @override
  State<SchoolLiveMapScreen> createState() => _SchoolLiveMapScreenState();
}

class _SchoolLiveMapScreenState extends State<SchoolLiveMapScreen> {
  final List<Map<String, dynamic>> _activeBuses = [
    {
      'id': 'B-101',
      'number': '101',
      'driver': 'John Driver',
      'status': 'on_route',
      'statusText': 'On Route',
      'delay': 'On Time',
      'passengers': 32,
      'capacity': 40,
      'currentStop': 'Maple Street',
      'nextStop': 'Oak Avenue',
      'etaToNextStop': '5 min',
      'coordinates': {'lat': 37.7749, 'lng': -122.4194},
      'color': Colors.blue,
    },
    {
      'id': 'B-102',
      'number': '102',
      'driver': 'Sarah Driver',
      'status': 'at_stop',
      'statusText': 'At Stop',
      'delay': '2 min late',
      'passengers': 28,
      'capacity': 35,
      'currentStop': 'Central Station',
      'nextStop': 'City Mall',
      'etaToNextStop': '8 min',
      'coordinates': {'lat': 37.7755, 'lng': -122.4188},
      'color': Colors.green,
    },
    {
      'id': 'B-103',
      'number': '103',
      'driver': 'Mike Driver',
      'status': 'moving',
      'statusText': 'Moving',
      'delay': 'On Time',
      'passengers': 15,
      'capacity': 45,
      'currentStop': 'North Campus',
      'nextStop': 'Library',
      'etaToNextStop': '12 min',
      'coordinates': {'lat': 37.7760, 'lng': -122.4200},
      'color': Colors.orange,
    },
    {
      'id': 'B-104',
      'number': '104',
      'driver': 'Emma Driver',
      'status': 'idle',
      'statusText': 'Idle',
      'delay': 'No schedule',
      'passengers': 0,
      'capacity': 30,
      'currentStop': 'School Depot',
      'nextStop': 'N/A',
      'etaToNextStop': 'N/A',
      'coordinates': {'lat': 37.7735, 'lng': -122.4210},
      'color': Colors.grey,
    },
  ];

  final List<Map<String, dynamic>> _routes = [
    {
      'id': 'R-001',
      'name': 'North Route',
      'stops': 12,
      'activeBuses': 2,
      'color': Colors.blue,
      'coordinates': [
        {'lat': 37.7749, 'lng': -122.4194},
        {'lat': 37.7760, 'lng': -122.4200},
        {'lat': 37.7770, 'lng': -122.4210},
      ],
    },
    {
      'id': 'R-002',
      'name': 'South Route',
      'stops': 8,
      'activeBuses': 1,
      'color': Colors.green,
      'coordinates': [
        {'lat': 37.7749, 'lng': -122.4194},
        {'lat': 37.7735, 'lng': -122.4210},
        {'lat': 37.7720, 'lng': -122.4220},
      ],
    },
  ];

  final Map<String, dynamic> _schoolLocation = {
    'name': 'Central High School',
    'coordinates': {'lat': 37.7749, 'lng': -122.4194},
    'address': '123 Education Blvd',
  };

  String _selectedRoute = 'all';
  String _mapViewType = 'standard';
  bool _showBusMarkers = true;
  bool _showRouteLines = true;
  bool _showSchoolMarker = true;
  Timer? _refreshTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // Simulate live updates every 10 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) {
        _simulateBusMovement();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _simulateBusMovement() {
    setState(() {
      for (var bus in _activeBuses) {
        if (bus['status'] == 'moving' || bus['status'] == 'on_route') {
          // Small random movement
          final currentLat = bus['coordinates']['lat'] as double;
          final currentLng = bus['coordinates']['lng'] as double;

          final lat = currentLat + (0.0001 * (_random.nextDouble() - 0.5));
          final lng = currentLng + (0.0001 * (_random.nextDouble() - 0.5));

          bus['coordinates']['lat'] = lat;
          bus['coordinates']['lng'] = lng;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Bus Tracking'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshMap,
            tooltip: 'Refresh Map',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showMapFilters,
            tooltip: 'Map Filters',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showMapSettings,
            tooltip: 'Map Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stats Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Theme.of(context).primaryColor.withOpacity(0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem('Active Buses', '${_activeBuses.where((b) => b['status'] != 'idle').length}'),
                  _buildStatItem('On Time', '${_activeBuses.where((b) => b['delay'] == 'On Time').length}'),
                  _buildStatItem('Delayed', '${_activeBuses.where((b) => b['delay'] != 'On Time' && b['delay'] != 'No schedule').length}'),
                  _buildStatItem('Routes', '${_routes.length}'),
                ],
              ),
            ),

            // Route Filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<String>(
                value: _selectedRoute,
                decoration: const InputDecoration(
                  labelText: 'Filter by Route',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                isExpanded: true,
                items: [
                  const DropdownMenuItem(value: 'all', child: Text('All Routes')),
                  ..._routes.map((route) => DropdownMenuItem(
                    value: route['id'],
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: route['color'],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(route['name']),
                      ],
                    ),
                  )),
                ],
                onChanged: (value) => setState(() => _selectedRoute = value!),
              ),
            ),

            // Map Container (Simulated)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Stack(
                  children: [
                    // Simulated Map Background
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Live Map View',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_activeBuses.length} buses tracked',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    // Bus Markers (Simulated)
                    if (_showBusMarkers)
                      ..._activeBuses.map((bus) {
                        final coordinates = bus['coordinates'] as Map<String, dynamic>;
                        final double lat = coordinates['lat'] as double;
                        final double lng = coordinates['lng'] as double;

                        final double x = 50 + (lng * 10000).abs() % 300;
                        final double y = 50 + (lat * 10000).abs() % 300;

                        return Positioned(
                          left: x,
                          top: y,
                          child: _buildBusMarker(bus),
                        );
                      }).toList(),

                    // School Marker
                    if (_showSchoolMarker)
                      const Positioned(
                        left: 200,
                        top: 200,
                        child: Column(
                          children: [
                            Icon(Icons.school, color: Colors.green, size: 32),
                            SizedBox(height: 4),
                            Text(
                              'School',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Active Buses List
            SizedBox(
              height: 180,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Active Buses',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Updated: ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _activeBuses.length,
                      itemBuilder: (context, index) {
                        final bus = _activeBuses[index];
                        return _buildBusInfoCard(bus);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildBusMarker(Map<String, dynamic> bus) {
    Color getStatusColor() {
      switch (bus['status']) {
        case 'moving':
        case 'on_route':
          return Colors.green;
        case 'at_stop':
          return Colors.blue;
        case 'idle':
          return Colors.grey;
        default:
          return Colors.orange;
      }
    }

    return GestureDetector(
      onTap: () => _showBusDetails(bus),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: getStatusColor(),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.directions_bus, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              bus['number'],
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: getStatusColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusInfoCard(Map<String, dynamic> bus) {
    Color getStatusColor() {
      switch (bus['status']) {
        case 'moving':
        case 'on_route':
          return Colors.green;
        case 'at_stop':
          return Colors.blue;
        case 'idle':
          return Colors.grey;
        default:
          return Colors.orange;
      }
    }

    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bus ${bus['number']}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      bus['statusText'],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: getStatusColor(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Driver: ${bus['driver']}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: Colors.blue),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      bus['currentStop'],
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.timer, size: 14, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(
                    'Next: ${bus['nextStop']} in ${bus['etaToNextStop']}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: (bus['passengers'] as int) / (bus['capacity'] as int),
                backgroundColor: Colors.grey[200],
                color: (bus['passengers'] as int) / (bus['capacity'] as int) > 0.9 ? Colors.red : Colors.green,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${bus['passengers']}/${bus['capacity']} passengers',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  Text(
                    bus['delay'],
                    style: TextStyle(
                      fontSize: 11,
                      color: bus['delay'] == 'On Time' ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
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

  void _refreshMap() {
    _simulateBusMovement();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Map refreshed'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showMapFilters() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Map Filters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Show Bus Markers'),
                    value: _showBusMarkers,
                    onChanged: (value) => setState(() => _showBusMarkers = value),
                  ),
                  SwitchListTile(
                    title: const Text('Show Route Lines'),
                    value: _showRouteLines,
                    onChanged: (value) => setState(() => _showRouteLines = value),
                  ),
                  SwitchListTile(
                    title: const Text('Show School Location'),
                    value: _showSchoolMarker,
                    onChanged: (value) => setState(() => _showSchoolMarker = value),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Bus Status Filter:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['all', 'moving', 'at_stop', 'idle'].map((status) {
                      return FilterChip(
                        label: Text(_toTitleCase(status.replaceAll('_', ' '))),
                        selected: true,
                        onSelected: (selected) {},
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: const Text('Apply Filters'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showMapSettings() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Map Settings'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _mapViewType,
                  decoration: const InputDecoration(labelText: 'Map View Type'),
                  items: [
                    'standard',
                    'satellite',
                    'terrain',
                    'hybrid',
                  ].map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_toTitleCase(type)),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _mapViewType = value!),
                ),
                const SizedBox(height: 16),
                const Text('Auto-refresh Interval'),
                Slider(
                  value: 10,
                  min: 5,
                  max: 60,
                  divisions: 11,
                  label: '10 seconds',
                  onChanged: (value) {},
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Save settings
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showBusDetails(Map<String, dynamic> bus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bus ${bus['number']} Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Bus Number', bus['number']),
              _buildDetailItem('Driver', bus['driver']),
              _buildDetailItem('Status', bus['statusText']),
              _buildDetailItem('Current Stop', bus['currentStop']),
              _buildDetailItem('Next Stop', bus['nextStop']),
              _buildDetailItem('ETA to Next Stop', bus['etaToNextStop']),
              _buildDetailItem('Passengers', '${bus['passengers']}/${bus['capacity']}'),
              _buildDetailItem('Delay Status', bus['delay']),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              const Text(
                'Quick Actions:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    label: const Text('Contact Driver'),
                    avatar: const Icon(Icons.phone, size: 16),
                    onPressed: () {},
                  ),
                  ActionChip(
                    label: const Text('View Route'),
                    avatar: const Icon(Icons.route, size: 16),
                    onPressed: () {},
                  ),
                  ActionChip(
                    label: const Text('Passenger List'),
                    avatar: const Icon(Icons.people, size: 16),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to detailed tracking
              Navigator.pop(context);
            },
            child: const Text('Track Live'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value?.toString() ?? 'N/A')),
        ],
      ),
    );
  }

  String _toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return '';
      return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
    }).join(' ');
  }
}