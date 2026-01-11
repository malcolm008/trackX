import 'package:flutter/material.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  String _selectedDate = 'Today';
  String _selectedStudent = 'All Students';
  final List<String> _dateFilters = ['Today', 'Yesterday', 'This Week', 'This Month', 'Custom'];
  final List<String> _studentFilters = ['All Students', 'Emily Johnson', 'Michael Johnson', 'Sarah Johnson'];

  final List<Map<String, dynamic>> _attendanceHistory = [
    {
      'date': '2024-01-25',
      'student': 'Emily Johnson',
      'status': 'present',
      'pickupTime': '7:30 AM',
      'dropTime': '3:45 PM',
      'busNumber': 'B-101',
      'notes': 'On time',
    },
    {
      'date': '2024-01-25',
      'student': 'Michael Johnson',
      'status': 'absent',
      'pickupTime': '7:45 AM',
      'dropTime': '3:30 PM',
      'busNumber': 'B-102',
      'notes': 'Sick leave',
    },
    {
      'date': '2024-01-24',
      'student': 'Emily Johnson',
      'status': 'present',
      'pickupTime': '7:28 AM',
      'dropTime': '3:42 PM',
      'busNumber': 'B-101',
      'notes': 'Early pickup',
    },
    {
      'date': '2024-01-24',
      'student': 'Michael Johnson',
      'status': 'present',
      'pickupTime': '7:47 AM',
      'dropTime': '3:35 PM',
      'busNumber': 'B-102',
      'notes': 'On time',
    },
    {
      'date': '2024-01-23',
      'student': 'Emily Johnson',
      'status': 'late',
      'pickupTime': '7:45 AM',
      'dropTime': '4:00 PM',
      'busNumber': 'B-101',
      'notes': 'Traffic delay',
    },
    {
      'date': '2024-01-23',
      'student': 'Michael Johnson',
      'status': 'present',
      'pickupTime': '7:42 AM',
      'dropTime': '3:38 PM',
      'busNumber': 'B-102',
      'notes': 'On time',
    },
  ];

  final List<Map<String, dynamic>> _monthlySummary = [
    {'month': 'Jan', 'present': 15, 'absent': 2, 'late': 3},
    {'month': 'Dec', 'present': 18, 'absent': 1, 'late': 1},
    {'month': 'Nov', 'present': 16, 'absent': 3, 'late': 1},
    {'month': 'Oct', 'present': 17, 'absent': 2, 'late': 2},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Attendance Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () {

                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedDate,
                          decoration: InputDecoration(
                            labelText: 'Date Range',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: _dateFilters.map((filter) {
                            return DropdownMenuItem(
                              value: filter,
                              child: Text(filter),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDate = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedStudent,
                          decoration: InputDecoration(
                            labelText: 'Student',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          items: _studentFilters.map((filter) {
                            return DropdownMenuItem(
                              value: filter,
                              child: Text(filter),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedStudent = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: [
                  Tab(text: 'Today\'s Status'),
                  Tab(text: 'History'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                  _buildTodayStatus(),
                  _buildHistoryTab(),
                ],
              )
            )
          ],
        )
      )
    );
  }

  Widget _buildTodayStatus() {
    final todayStatus = _attendanceHistory
        .where((record) => record['date'] == '2024-01-25')
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(26),
              child: Column(
                children: [
                  const Text(
                    "Todays's Summary",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatusCircle('Present', Colors.green, 1),
                      _buildStatusCircle('Absent', Colors.red, 1),
                      _buildStatusCircle('Late', Colors.orange, 0),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Current Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...todayStatus.map((status) {
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
                          backgroundColor: _getStatusColor(status['status']).withOpacity(0.7),
                          child: Icon(
                            _getStatusIcon(status['status']),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                status['student'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Bus ${status['busNumber']}',
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
                            status['status'].toString().toUpperCase(),
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: _getStatusColor(status['status']).withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: _getStatusColor(status['status']),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (status['notes'] != null && status['notes'].isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal[400],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                status['notes'],
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildTimeInfo('Drop', status['pickupTime']),
                        const SizedBox(width: 24),
                        _buildTimeInfo('Pickup', status['pickupTime']),
                        const SizedBox(width: 24),
                        _buildTimeInfo('Drop', status['dropTime']),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _showMarkAttendanceDialog();
              },
              icon: const Icon(Icons.edit_calendar),
              label: const Text('Mark Attendance for Tomorrow'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monthtly Summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: _monthlySummary.map((summary) {
                      return Expanded(
                        child: Column(
                          children: [
                            Text(
                              summary['month'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text('${summary['present']}'),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Text(
            'Attendance History',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          ..._attendanceHistory.map((record) {
            return Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getStatusColor(record['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getStatusIcon(record['status']),
                    color: _getStatusColor(record['status']),
                  ),
                ),
                title: Text(
                  record['student'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      '${record['date']} • Bus ${record['busNumber']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (record['notes'] != null && record['notes'].isNotEmpty)
                      Text(
                        record['notes'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Chip(
                      label: Text(
                        record['status'].toString().toUpperCase(),
                        style: const TextStyle(fontSize: 10),
                      ),
                      backgroundColor: _getStatusColor(record['status']).withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: _getStatusColor(record['status']),
                      ),
                    ),
                    Text(
                      '${record['pickupTime']} - ${record['dropTime']}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStatusCircle(String label, Color color, int count) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTimeInfo(String label, String time) {
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
          time,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showMarkAttendanceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark Attendance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text('Emily Johnson'),
              subtitle: const Text('Grade 5'),
              trailing: DropdownButton<String>(
                value: 'present',
                items: ['present', 'absent', 'late'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
            ),
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: const Text('Michael Johnson'),
              subtitle: const Text('Grade 3'),
              trailing: DropdownButton<String>(
                value: 'present',
                items: ['present', 'absent', 'late'].map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
                  content: Text('Attendance marked successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'absent':
        return Colors.red;
      case 'late':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Icons.check_circle;
      case 'absent':
        return Icons.cancel;
      case 'late':
        return Icons.watch_later;
      default:
        return Icons.help;
    }
  }
}