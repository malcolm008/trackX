import 'package:flutter/material.dart';

class AssignedStudentsScreen extends StatefulWidget {
  const AssignedStudentsScreen({super.key});

  @override
  State<AssignedStudentsScreen> createState() => _AssignedStudentsScreenState();
}

class _AssignedStudentsScreenState extends State<AssignedStudentsScreen> {
  final List<Map<String, dynamic>> _students =[
    {
      'id': 'ST-101',
      'name': 'Emily Johnson',
      'grade': 'Grade 5',
      'school': 'Greenwood High',
      'stop': 'Main Street Stop',
      'pickupTime': '7:30 AM',
      'dropTime': '3:45 PM',
      'status': 'on_board',
      'parent': 'Sarah Johnson',
      'parentPhone': '+1 (555) 123-4567',
      'address': '123 Main St, Greenwood City',
    },
    {
      'id': 'ST-102',
      'name': 'Michael Wilson',
      'grade': 'Grade 3',
      'school': 'Sunrise Academy',
      'stop': 'Oak Avenue Stop',
      'pickupTime': '7:45 AM',
      'dropTime': '3:30 PM',
      'status': 'not_boarded',
      'parent': 'John Wilson',
      'parentPhone': '+1 (555) 234-5678',
      'address': '456 Oak Ave, Sunrise Town',
    },
    {
      'id': 'ST-103',
      'name': 'Sophia Martinez',
      'grade': 'Grade 6',
      'school': 'Central School',
      'stop': 'Pine Road Stop',
      'pickupTime': '7:20 AM',
      'dropTime': '4:00 PM',
      'status': 'on_board',
      'parent': 'Maria Martinez',
      'parentPhone': '+1 (555) 345-6789',
      'address': '789 Pine Rd, Metro City',
    },
    {
      'id': 'ST-104',
      'name': 'David Brown',
      'grade': 'Grade 4',
      'school': 'Northwood School',
      'stop': 'Elm Street Stop',
      'pickupTime': '7:35 AM',
      'dropTime': '3:50 PM',
      'status': 'absent',
      'parent': 'Robert Brown',
      'parentPhone': '+1 (555) 456-7890',
      'address': '101 Elm St, Northwood',
    },
    {
      'id': 'ST-105',
      'name': 'Olivia Davis',
      'grade': 'Grade 2',
      'school': 'Valley Prep',
      'stop': 'Maple Lane Stop',
      'pickupTime': '7:50 AM',
      'dropTime': '3:25 PM',
      'status': 'not_boarded',
      'parent': 'Jennifer Davis',
      'parentPhone': '+1 (555) 567-8901',
      'address': '202 Maple Ln, Valley Town',
    },
  ];

  String _selectedFilter = 'all';
  final List<String> _filters = ['all', 'on-board', 'not-boarded', 'absent'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search students...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(child: DropdownButton<String>(
                    value: _selectedFilter,
                    items: _filters.map((filter) {
                      return DropdownMenuItem(
                        value: filter,
                        child: Text(
                          filter == 'all' ? 'All' : filter.replaceAll('_', ' ').toUpperCase(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedFilter = value!;
                      });
                    },
                  ),),
                ),
              ],
            ),
          ),

          //Status Overview
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStudentStat('On Board', Icons.check_circle, Colors.teal, _students.where((s) => s['status'] == 'on_board').length),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStudentStat('To Pickup', Icons.pending, Color(0xFFFF9F7B), _students.where((s) => s['status'] == 'not_boarded').length),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStudentStat('Absent', Icons.cancel, Colors.pinkAccent, _students.where((s) => s['status'] == 'absent').length),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          //Students's List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: _getStatusColor(student['status']).withOpacity(0.1),
                              child: Icon(
                                _getStatusIcon(student['status']),
                                color: _getStatusColor(student['status']),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '${student['grade']} • ${student['school']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Chip(
                              label: Text(
                                student['status'].replaceAll('_', ' ').toUpperCase(),
                                style: const TextStyle(fontSize: 10),
                              ),
                              backgroundColor: _getStatusColor(student['status']).withOpacity(0.1),
                              labelStyle: TextStyle(
                                color: _getStatusColor(student['status']),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            _buildDetailItem('Stop', Icons.location_on, student['stop']),
                            const SizedBox(width: 16),
                            _buildDetailItem('Pickup', Icons.arrow_upward, student['pickupTime']),
                            const SizedBox(width: 16),
                            _buildDetailItem('Drop', Icons.arrow_downward, student['dropTime']),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.person_outline, size: 16, color: Colors.grey),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Parent: ${student['parent']}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      student['parentPhone'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.phone, size: 18),
                                onPressed: () {
                                  _callParent(student['parentPhone']);
                                },
                                tooltip: 'Call Parent',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _markAttendance(student);
                                },
                                icon: Icon(
                                  student['status'] == 'on_board'
                                      ? Icons.person_remove
                                      : Icons.person_add,
                                  size: 16,
                                ),
                                label: Text(
                                  student['status'] == 'on_board'
                                      ? 'Mark Dropped'
                                      : 'Mark Picked',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _showStudentDetails(student);
                                },
                                icon: const Icon(Icons.info_outline, size: 16),
                                label: const Text('Details'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentStat(String title, IconData icon, Color color, int count) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, IconData icon, String value){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.blue),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'on_board':
        return Colors.teal;
      case 'not_boarded':
        return Color(0xFFFF9F7B);
      case 'absent':
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'on_board':
        return Icons.check_circle;
      case 'not_boarded':
        return Icons.pending;
      case 'absent':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  void _callParent(String phoneNumber) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling $phoneNumber...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _markAttendance(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark Attendance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: _getStatusColor(student['status']).withOpacity(0.1),
              child: Icon(
                _getStatusIcon(student['status']),
                color: _getStatusColor(student['status']),
                size: 30,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              student['name'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${student['grade']} • ${student['school']}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Action',
                border: OutlineInputBorder(),
              ),
              value: student['status'],
              items: [
                DropdownMenuItem(
                  value: 'on_board',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      const Text('Mark as Picked Up'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'not_boarded',
                  child: Row(
                    children: [
                      Icon(Icons.pending, color: Colors.orange),
                      const SizedBox(width: 8),
                      const Text('Not yet Boarded'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'absent',
                  child: Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.red),
                      const SizedBox(width: 8),
                      const Text('Mark as Absent'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {

              },
            )
          ],
        )
      )
    );
  }

  void _showStudentDetails(Map<String, dynamic> student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
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
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: _getStatusColor(student['status']).withOpacity(0.1),
                    child: Icon(
                      _getStatusIcon(student['status']),
                      color: _getStatusColor(student['status']),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          student['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'ID ${student['id']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Student Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Grade', student['grade']),
              _buildDetailRow('School', student['school']),
              _buildDetailRow('Bus Stop', student['stop']),
              _buildDetailRow('Pickup Time', student['pickupTime']),
              _buildDetailRow('Drop Time', student['status'].replaceAll('_', ' ').toUpperCase()),
              const SizedBox(height: 16),
              const Text(
                'Parent Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Parent Name', student['parent']),
              _buildDetailRow('Contact', student['parentPhone']),
              _buildDetailRow('Address', student['address']),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _callParent(student['parentPhone']);
                      },
                      icon: const Icon(Icons.phone),
                      label: const Text('Call Parent'),
                    ),
                  ),
                ],
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}