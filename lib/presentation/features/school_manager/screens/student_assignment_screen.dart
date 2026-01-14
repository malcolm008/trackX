import 'package:flutter/material.dart';
import 'package:bustracker_007/presentation/widgets/common/app_bar.dart';

class StudentAssignmentScreen extends StatefulWidget {
  const StudentAssignmentScreen({super.key});

  @override
  State<StudentAssignmentScreen> createState() => _StudentAssignmentScreenState();
}

class _StudentAssignmentScreenState extends State<StudentAssignmentScreen> {
  List<Map<String, dynamic>> _students = [
    {
      'id': '1',
      'name': 'John Smith',
      'grade': '5th Grade',
      'busId': 'B-101',
      'busNumber': 'Bus 101',
      'routeId': 'R-001',
      'routeName': 'North Route',
      'parentId': 'P001',
      'parentName': 'Mr. Smith',
      'status': 'active',
      'assigned': true,
    },
    {
      'id': '2',
      'name': 'Sarah Johnson',
      'grade': '6th Grade',
      'busId': 'B-102',
      'busNumber': 'Bus 102',
      'routeId': 'R-002',
      'routeName': 'South Route',
      'parentId': 'P002',
      'parentName': 'Mrs. Johnson',
      'status': 'active',
      'assigned': true,
    },
    {
      'id': '3',
      'name': 'Michael Brown',
      'grade': '4th Grade',
      'busId': null,
      'busNumber': null,
      'routeId': null,
      'routeName': null,
      'parentId': 'P003',
      'parentName': 'Mr. Brown',
      'status': 'pending',
      'assigned': false,
    },
    {
      'id': '4',
      'name': 'Emma Wilson',
      'grade': '7th Grade',
      'busId': 'B-103',
      'busNumber': 'Bus 103',
      'routeId': 'R-003',
      'routeName': 'East Route',
      'parentId': 'P004',
      'parentName': 'Mrs. Wilson',
      'status': 'active',
      'assigned': true,
    },
    {
      'id': '5',
      'name': 'David Lee',
      'grade': '3rd Grade',
      'busId': null,
      'busNumber': null,
      'routeId': null,
      'routeName': null,
      'parentId': 'P005',
      'parentName': 'Mr. Lee',
      'status': 'active',
      'assigned': false,
    },
  ];

  List<Map<String, dynamic>> _buses = [
    {'id': 'B-101', 'number': '101', 'capacity': 40, 'driver': 'John Driver', 'availableSeats': 15},
    {'id': 'B-102', 'number': '102', 'capacity': 35, 'driver': 'Sarah Driver', 'availableSeats': 8},
    {'id': 'B-103', 'number': '103', 'capacity': 45, 'driver': 'Mike Driver', 'availableSeats': 22},
    {'id': 'B-104', 'number': '104', 'capacity': 30, 'driver': 'Emma Driver', 'availableSeats': 5},
  ];

  List<Map<String, dynamic>> _routes = [
    {'id': 'R-001', 'name': 'North Route', 'stops': 12, 'duration': '45 min'},
    {'id': 'R-002', 'name': 'South Route', 'stops': 8, 'duration': '35 min'},
    {'id': 'R-003', 'name': 'East Route', 'stops': 10, 'duration': '40 min'},
    {'id': 'R-004', 'name': 'West Route', 'stops': 14, 'duration': '50 min'},
  ];

  String _filterType = 'all';
  String? _selectedBusFilter;
  String? _selectedRouteFilter;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredStudents = _getFilteredStudents();

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddStudentDialog,
          icon: const Icon(Icons.add),
          label: const Text('Add Student'),
          backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // Summary Cards
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).cardColor.withOpacity(0.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryCard('Total Students', _students.length.toString(), Icons.people, Colors.deepPurpleAccent.shade100),
                _buildSummaryCard('Assigned', _students.where((s) => s['assigned'] == true).length.toString(), Icons.check_circle, Colors.teal),
                _buildSummaryCard('Unassigned', _students.where((s) => s['assigned'] == false).length.toString(), Icons.pending, Color(0xFFFF9F7B)),
              ],
            ),
          ),

          // Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedBusFilter,
                    decoration: InputDecoration(
                      labelText: 'Filter by Bus',
                      border: const OutlineInputBorder(),
                      suffixIcon: _selectedBusFilter != null
                          ? IconButton(
                        icon: const Icon(Icons.clear, size: 16),
                        onPressed: () => setState(() => _selectedBusFilter = null),
                      )
                          : null,
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Buses')),
                      ..._buses.map((bus) => DropdownMenuItem(
                        value: bus['id'],
                        child: Text('Bus ${bus['number']}'),
                      )),
                    ],
                    onChanged: (value) => setState(() => _selectedBusFilter = value),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedRouteFilter,
                    decoration: InputDecoration(
                      labelText: 'Filter by Route',
                      border: const OutlineInputBorder(),
                      suffixIcon: _selectedRouteFilter != null
                          ? IconButton(
                        icon: const Icon(Icons.clear, size: 16),
                        onPressed: () => setState(() => _selectedRouteFilter = null),
                      )
                          : null,
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All Routes')),
                      ..._routes.map((route) => DropdownMenuItem(
                        value: route['id'],
                        child: Text(route['name']),
                      )),
                    ],
                    onChanged: (value) => setState(() => _selectedRouteFilter = value),
                  ),
                ),
                const SizedBox(width: 5),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: _showFilterDialog,
                  tooltip: 'Filter Students',
                ),
              ],
            ),
          ),

          // Student List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
                return _buildStudentCard(student);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    final isAssigned = student['assigned'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Student Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Grade: ${student['grade']} • Parent: ${student['parentName']}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  if (isAssigned)
                    Wrap(
                      spacing: 8,
                      children: [
                        Chip(
                          label: Text(
                            student['busNumber'] ?? 'No Bus',
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.deepPurpleAccent.shade100,
                          avatar: const Icon(Icons.directions_bus, size: 16),
                        ),
                        Chip(
                          label: Text(
                            student['routeName'] ?? 'No Route',
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: Colors.teal,
                          avatar: const Icon(Icons.route, size: 16),
                        ),
                      ],
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warning, color: Colors.orange.shade700, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'Not Assigned',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Action Buttons
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    isAssigned ? Icons.edit : Icons.add_circle,
                    color: isAssigned ? Colors.deepPurpleAccent.shade100 : Colors.teal,
                  ),
                  onPressed: () => _showAssignmentDialog(student),
                  tooltip: isAssigned ? 'Edit Assignment' : 'Assign Student',
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => _showStudentOptions(student),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredStudents() {
    List<Map<String, dynamic>> filtered = _students;

    // Apply status filter
    if (_filterType == 'assigned') {
      filtered = filtered.where((s) => s['assigned'] == true).toList();
    } else if (_filterType == 'unassigned') {
      filtered = filtered.where((s) => s['assigned'] == false).toList();
    }

    // Apply bus filter
    if (_selectedBusFilter != null) {
      filtered = filtered.where((s) => s['busId'] == _selectedBusFilter).toList();
    }

    // Apply route filter
    if (_selectedRouteFilter != null) {
      filtered = filtered.where((s) => s['routeId'] == _selectedRouteFilter).toList();
    }

    return filtered;
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Students'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('All Students'),
              value: 'all',
              groupValue: _filterType,
              onChanged: (value) => setState(() => _filterType = value!),
            ),
            RadioListTile<String>(
              title: const Text('Assigned Only'),
              value: 'assigned',
              groupValue: _filterType,
              onChanged: (value) => setState(() => _filterType = value!),
            ),
            RadioListTile<String>(
              title: const Text('Unassigned Only'),
              value: 'unassigned',
              groupValue: _filterType,
              onChanged: (value) => setState(() => _filterType = value!),
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
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }

  void _showAssignmentDialog(Map<String, dynamic> student) {
    String? selectedBusId = student['busId'];
    String? selectedRouteId = student['routeId'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(student['assigned'] == true ? 'Edit Assignment' : 'Assign Student'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Assigning: ${student['name']}'),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedBusId,
                      decoration: const InputDecoration(
                        labelText: 'Select Bus',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('No Bus Selected')),
                        ..._buses.map((bus) => DropdownMenuItem(
                          value: bus['id'],
                          child: Text('Bus ${bus['number']} (${bus['availableSeats']} seats left)'),
                        )),
                      ],
                      onChanged: (value) => setState(() => selectedBusId = value),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedRouteId,
                      decoration: const InputDecoration(
                        labelText: 'Select Route',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('No Route Selected')),
                        ..._routes.map((route) => DropdownMenuItem(
                          value: route['id'],
                          child: Text('${route['name']} (${route['stops']} stops)'),
                        )),
                      ],
                      onChanged: (value) => setState(() => selectedRouteId = value),
                    ),
                  ],
                ),
              ),
              actions: [
                if (student['assigned'] == true)
                  TextButton(
                    onPressed: () {
                      _unassignStudent(student['id']);
                      Navigator.pop(context);
                    },
                    child: const Text('Unassign', style: TextStyle(color: Colors.red)),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _assignStudent(student['id'], selectedBusId, selectedRouteId);
                    Navigator.pop(context);
                  },
                  child: const Text('Save Assignment'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showStudentOptions(Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                _showStudentDetails(student);
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Contact Parent'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement contact functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('View Attendance History'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement attendance history
              },
            ),
            if (student['assigned'] == true)
              ListTile(
                leading: const Icon(Icons.map, color: Colors.blue),
                title: const Text('Track Bus Location'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to live map
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Remove Student', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(student);
              },
            ),
          ],
        );
      },
    );
  }

  void _showStudentDetails(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Student Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Name', student['name']),
              _buildDetailRow('Grade', student['grade']),
              _buildDetailRow('Parent', student['parentName']),
              _buildDetailRow('Status', student['status']),
              _buildDetailRow('Bus', student['busNumber'] ?? 'Not assigned'),
              _buildDetailRow('Route', student['routeName'] ?? 'Not assigned'),
              if (student['assigned'] == true) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Assignment Details:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Bus ID', student['busId']),
                _buildDetailRow('Route ID', student['routeId']),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
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

  void _showAddStudentDialog() {
    // TODO: Implement add student functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add student functionality coming soon')),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Student'),
        content: Text('Are you sure you want to remove ${student['name']} from the system?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _removeStudent(student['id']);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _assignStudent(String studentId, String? busId, String? routeId) {
    int studentIndex = _students.indexWhere((s) => s['id'] == studentId);

    setState(() {
      if (studentIndex != -1) {
        _students[studentIndex]['busId'] = busId;
        _students[studentIndex]['routeId'] = routeId;
        _students[studentIndex]['assigned'] = busId != null || routeId != null;

        if (busId != null) {
          final bus = _buses.firstWhere((b) => b['id'] == busId);
          _students[studentIndex]['busNumber'] = 'Bus ${bus['number']}';
        }

        if (routeId != null) {
          final route = _routes.firstWhere((r) => r['id'] == routeId);
          _students[studentIndex]['routeName'] = route['name'];
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_students[studentIndex]['assigned'] == true
            ? 'Student assigned successfully'
            : 'Assignment cleared'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _unassignStudent(String studentId) {
    setState(() {
      final index = _students.indexWhere((s) => s['id'] == studentId);
      if (index != -1) {
        _students[index]['busId'] = null;
        _students[index]['routeId'] = null;
        _students[index]['busNumber'] = null;
        _students[index]['routeName'] = null;
        _students[index]['assigned'] = false;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Student unassigned successfully'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _removeStudent(String studentId) {
    setState(() {
      _students.removeWhere((s) => s['id'] == studentId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Student removed successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
}