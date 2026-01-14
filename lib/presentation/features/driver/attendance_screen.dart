import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedShift = 'morning';
  List<Map<String, dynamic>> _attendanceList = [];

  final List<Map<String, dynamic>> _mockAttendance = [
    {
      'id': 'ST-101',
      'name': 'Emily Johnson',
      'grade': 'Grade 5',
      'stop': 'Main Street Stop',
      'morning': 'present',
      'morningTime': '7:30 AM',
      'afternoon': 'pending',
      'afternoonTime': '',
      'notes': '',
    },
    {
      'id': 'ST-102',
      'name': 'Michael Wilson',
      'grade': 'Grade 3',
      'stop': 'Oak Avenue Stop',
      'morning': 'absent',
      'morningTime': '',
      'afternoon': 'pending',
      'afternoonTime': '',
      'notes': 'Sick leave',
    },
    {
      'id': 'ST-103',
      'name': 'Sophia Martinez',
      'grade': 'Grade 6',
      'stop': 'Pine Road Stop',
      'morning': 'present',
      'morningTime': '7:25 AM',
      'afternoon': 'pending',
      'afternoonTime': '',
      'notes': '',
    },
    {
      'id': 'ST-104',
      'name': 'David Brown',
      'grade': 'Grade 4',
      'stop': 'Elm Street Stop',
      'morning': 'present',
      'morningTime': '7:35 AM',
      'afternoon': 'pending',
      'afternoonTime': '',
      'notes': '',
    },
    {
      'id': 'ST-105',
      'name': 'Olivia Davis',
      'grade': 'Grade 2',
      'stop': 'Maple Lane Stop',
      'morning': 'late',
      'morningTime': '7:55 AM',
      'afternoon': 'pending',
      'afternoonTime': '',
      'notes': 'Late due to traffic',
    },
  ];

  @override
  void initState() {
    super.initState();
    _attendanceList = _mockAttendance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitAttendance,
        icon: const Icon(Icons.send),
        label: const Text('Submit Attendance'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // Date and Shift Selector
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Date Selection
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Date:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_month),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2025),
                          );
                          if (picked != null && picked != _selectedDate) {
                            setState(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Shift Selection
                  Row(
                    children: [
                      const Icon(Icons.timelapse_outlined, size: 14),
                      const SizedBox(width: 2),
                      const Text(
                        'Shift:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      ChoiceChip(
                        label: const Text('Morning Pickup'),
                        selected: _selectedShift == 'morning',
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedShift = 'morning';
                            });
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Afternoon Drop'),
                        selected: _selectedShift == 'afternoon',
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedShift = 'afternoon';
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Attendance Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildAttendanceStat('Present', Colors.teal,
                      _attendanceList.where((a) => a[_selectedShift] == 'present').length),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAttendanceStat('Absent', Colors.pinkAccent,
                      _attendanceList.where((a) => a[_selectedShift] == 'absent').length),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAttendanceStat('Late', Color(0xFFFF9F7B),
                      _attendanceList.where((a) => a[_selectedShift] == 'late').length),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildAttendanceStat('Pending', Colors.deepPurpleAccent.shade100,
                      _attendanceList.where((a) => a[_selectedShift] == 'pending').length),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quick Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _markAllPresent,
                    icon: const Icon(Icons.check_circle_outline, size: 14),
                    label: const Text('All Present'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _markAllAbsent,
                    icon: const Icon(Icons.cancel_outlined, size: 14),
                    label: const Text('All Absent'),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: _scanQRCode,
                  tooltip: 'Scan QR Code',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Attendance List Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Text(
                    'Student',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Stop',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    _selectedShift == 'morning' ? 'Pickup' : 'Drop',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),

          // Attendance List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _attendanceList.length,
              itemBuilder: (context, index) {
                final student = _attendanceList[index];
                final status = student[_selectedShift];
                final timeKey = _selectedShift == 'morning' ? 'morningTime' : 'afternoonTime';

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Student Info
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student['name'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                student['grade'],
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        // Stop
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                student['stop'],
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        ),
                        // Time
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (student[timeKey].isNotEmpty)
                                Text(
                                  student[timeKey],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              if (student[timeKey].isEmpty)
                                IconButton(
                                  icon: const Icon(Icons.access_time, size: 18),
                                  onPressed: () => _markTime(student, index),
                                  padding: EdgeInsets.zero,
                                ),
                            ],
                          ),
                        ),
                        // Status with Action
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PopupMenuButton<String>(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(status).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _getStatusIcon(status),
                                        color: _getStatusColor(status),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        status.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: _getStatusColor(status),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'present',
                                    child: Row(
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.green),
                                        const SizedBox(width: 8),
                                        const Text('Present'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'absent',
                                    child: Row(
                                      children: [
                                        Icon(Icons.cancel, color: Colors.red),
                                        const SizedBox(width: 8),
                                        const Text('Absent'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'late',
                                    child: Row(
                                      children: [
                                        Icon(Icons.watch_later, color: Colors.orange),
                                        const SizedBox(width: 8),
                                        const Text('Late'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'pending',
                                    child: Row(
                                      children: [
                                        Icon(Icons.pending, color: Colors.blue),
                                        const SizedBox(width: 8),
                                        const Text('Pending'),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  _updateAttendanceStatus(index, value);
                                },
                              ),
                            ],
                          )
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

  Widget _buildAttendanceStat(String label, Color color, int count) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markAllPresent() {
    setState(() {
      for (var student in _attendanceList) {
        student[_selectedShift] = 'present';
        if (_selectedShift == 'morning') {
          student['morningTime'] = _getCurrentTime();
        } else {
          student['afternoonTime'] = _getCurrentTime();
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All students marked as present'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _markAllAbsent() {
    setState(() {
      for (var student in _attendanceList) {
        student[_selectedShift] = 'absent';
        if (_selectedShift == 'morning') {
          student['morningTime'] = '';
        } else {
          student['afternoonTime'] = '';
        }
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All students marked as absent'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _markTime(Map<String, dynamic> student, int index) {
    final now = _getCurrentTime();
    setState(() {
      if (_selectedShift == 'morning') {
        _attendanceList[index]['morningTime'] = now;
      } else {
        _attendanceList[index]['afternoonTime'] = now;
      }
      if (_attendanceList[index][_selectedShift] == 'pending') {
        _attendanceList[index][_selectedShift] = 'present';
      }
    });
  }

  void _updateAttendanceStatus(int index, String status) {
    setState(() {
      _attendanceList[index][_selectedShift] = status;
      if (status == 'present' || status == 'late') {
        final now = _getCurrentTime();
        if (_selectedShift == 'morning') {
          _attendanceList[index]['morningTime'] = now;
        } else {
          _attendanceList[index]['afternoonTime'] = now;
        }
      } else {
        if (_selectedShift == 'morning') {
          _attendanceList[index]['morningTime'] = '';
        } else {
          _attendanceList[index]['afternoonTime'] = '';
        }
      }
    });
  }

  void _scanQRCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan QR Code'),
        content: SizedBox(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.qr_code_scanner,
                size: 80,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
              const SizedBox(height: 20),
              const Text(
                'Scan Student QR Code',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Point camera at student\'s QR code to mark attendance automatically',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // Simulate QR scan
                  _simulateQRScan();
                },
                icon: const Icon(Icons.qr_code_2),
                label: const Text('Start Scanning'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _simulateQRScan() {
    // Simulate scanning first pending student
    final pendingIndex = _attendanceList.indexWhere((s) => s[_selectedShift] == 'pending');
    if (pendingIndex != -1) {
      _updateAttendanceStatus(pendingIndex, 'present');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scanned: ${_attendanceList[pendingIndex]['name']}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No pending students to scan'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _submitAttendance() {
    final pendingCount = _attendanceList.where((s) => s[_selectedShift] == 'pending').length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Attendance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_upload,
              size: 48,
              color: pendingCount > 0 ? Colors.orange : Colors.green,
            ),
            const SizedBox(height: 16),
            Text(
              'Submit ${_selectedShift == 'morning' ? 'Morning Pickup' : 'Afternoon Drop'} Attendance?',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (pendingCount > 0)
              Text(
                '$pendingCount students still pending',
                style: const TextStyle(color: Colors.orange),
              ),
            const SizedBox(height: 16),
            const Text(
              'Submitted attendance cannot be modified without admin approval.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
                  content: Text('${_selectedShift == 'morning' ? 'Morning' : 'Afternoon'} attendance submitted successfully'),
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

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'present':
        return Colors.teal;
      case 'absent':
        return Colors.pinkAccent;
      case 'late':
        return Color(0xFFFF9F7B);
      case 'pending':
        return Colors.deepPurpleAccent.shade100;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'present':
        return Icons.check_circle;
      case 'absent':
        return Icons.cancel;
      case 'late':
        return Icons.watch_later;
      case 'pending':
        return Icons.pending;
      default:
        return Icons.help;
    }
  }
}