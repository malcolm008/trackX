import 'package:flutter/material.dart';
import 'package:bustracker_007/core/utils/string_extensions.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  final List<Map<String, dynamic>> _activeBuses = [
    {
      'id': 'B-101',
      'driver': 'John Smith',
      'school': 'Greenwood High',
      'route': 'Route 1',
      'status': 'moving',
      'speed': '45 km/h',
      'passengers': 28,
      'capacity': 45,
      'eta': '15 min',
      'location': 'Downtown Area',
      'coordinates': {'lat': 40.7128, 'lng': -74.0060},
    },
    {
      'id': 'B-102',
      'driver': 'Sarah Johnson',
      'school': 'Sunrise Academy',
      'route': 'Route 2',
      'status': 'stopped',
      'speed': '0 km/h',
      'passengers': 15,
      'capacity': 35,
      'eta': '30 min',
      'location': 'Sunrise Station',
      'coordinates': {'lat': 40.7589, 'lng': -73.9851},
    },
    {
      'id': 'B-103',
      'driver': 'Mike Wilson',
      'school': 'Central School',
      'route': 'Route 3',
      'status': 'moving',
      'speed': '35 km/h',
      'passengers': 40,
      'capacity': 50,
      'eta': '10 min',
      'location': 'Central Park',
      'coordinates': {'lat': 40.7812, 'lng': -73.9665},
    },
    {
      'id': 'B-104',
      'driver': 'Emily Davis',
      'school': 'Northwood School',
      'route': 'Route 4',
      'status': 'delayed',
      'speed': '20 km/h',
      'passengers': 22,
      'capacity': 45,
      'eta': '45 min',
      'location': 'Northwood Ave',
      'coordinates': {'lat': 40.8397, 'lng': -73.9408},
    },
    {
      'id': 'B-105',
      'driver': 'Robert Brown',
      'school': 'Valley Prep',
      'route': 'Route 5',
      'status': 'moving',
      'speed': '50 km/h',
      'passengers': 10,
      'capacity': 30,
      'eta': '25 min',
      'location': 'Valley Road',
      'coordinates': {'lat': 40.7489, 'lng': -73.9680},
    },
  ];

  String _selectedFilter = 'all';
  bool _showSidePanel = true;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live Map Tracking',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Real-time tracking of all school buses',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            if (isDesktop)
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download),
                    label: const Text('Export'),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 24),

        // Main Map Area
        Expanded(
          child: isDesktop
              ? _buildDesktopLayout(context)
              : _buildMobileLayout(context),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Map Container
        Expanded(
          flex: 3,
          child: Card(
            child: Stack(
              children: [
                // Map placeholder
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Interactive Map View',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Live bus locations and routes would appear here',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Map controls
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
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),

        // Side Panel
        if (_showSidePanel)
          SizedBox(
            width: 400,
            child: Card(
              child: Column(
                children: [
                  // Panel Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Active Buses (${_activeBuses.length})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.filter_list),
                              onPressed: () {},
                              tooltip: 'Filter',
                            ),
                            IconButton(
                              icon: Icon(_showSidePanel ? Icons.chevron_right : Icons.chevron_left),
                              onPressed: () {
                                setState(() {
                                  _showSidePanel = !_showSidePanel;
                                });
                              },
                              tooltip: 'Toggle Panel',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 0),
                  // Filters
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search buses...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        DropdownButton<String>(
                          value: _selectedFilter,
                          items: ['all', 'moving', 'stopped', 'delayed', 'offline']
                              .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status.capitalize()),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedFilter = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // Bus List
                  Expanded(
                    child: ListView.builder(
                      itemCount: _activeBuses.length,
                      itemBuilder: (context, index) {
                        final bus = _activeBuses[index];
                        return _buildBusListItem(bus, context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        // Map Container
        Card(
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Live Map View',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Filters
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search buses...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _selectedFilter,
                      items: ['all', 'moving', 'stopped', 'delayed', 'offline']
                          .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status.capitalize()),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedFilter = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download),
                        label: const Text('Export'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Bus List
        Expanded(
          child: ListView.builder(
            itemCount: _activeBuses.length,
            itemBuilder: (context, index) {
              final bus = _activeBuses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: _buildBusListItem(bus, context),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBusListItem(Map<String, dynamic> bus, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getStatusColor(bus['status']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.directions_bus,
                  color: _getStatusColor(bus['status']),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bus ${bus['id']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Driver: ${bus['driver']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Chip(
                label: Text(bus['status'].toString().capitalize()),
                backgroundColor: _getStatusColor(bus['status']).withOpacity(0.1),
                labelStyle: TextStyle(
                  color: _getStatusColor(bus['status']),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildBusInfo('School', bus['school']),
              const SizedBox(width: 16),
              _buildBusInfo('Route', bus['route']),
              const SizedBox(width: 16),
              _buildBusInfo('ETA', bus['eta']),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildBusInfo('Location', bus['location']),
              const Spacer(),
              _buildBusInfo('Speed', bus['speed']),
              const SizedBox(width: 16),
              _buildBusInfo('Capacity', '${bus['passengers']}/${bus['capacity']}'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.location_on, size: 16),
                  label: const Text('Track'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone, size: 16),
                  label: const Text('Call'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'moving':
        return Colors.green;
      case 'stopped':
        return Colors.blue;
      case 'delayed':
        return Colors.orange;
      case 'offline':
        return Colors.grey;
      default:
        return Colors.green;
    }
  }
}