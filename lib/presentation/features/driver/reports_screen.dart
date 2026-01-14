import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final List<Map<String, dynamic>> _reports = [
    {
      'id': 'RPT-001',
      'type': 'mechanical',
      'title': 'Brake Issue',
      'description': 'Squeaking noise from front brakes',
      'status': 'pending',
      'priority': 'high',
      'date': '2024-01-25',
      'time': '08:30 AM',
      'location': 'Main Street',
      'attachments': 1,
      'comments': 'Need immediate attention',
    },
    {
      'id': 'RPT-002',
      'type': 'traffic',
      'title': 'Road Construction',
      'description': 'Major construction on Route 1 causing 30min delays',
      'status': 'resolved',
      'priority': 'medium',
      'date': '2024-01-24',
      'time': '07:45 AM',
      'location': 'Downtown Area',
      'attachments': 0,
      'comments': 'Route diverted successfully',
    },
    {
      'id': 'RPT-003',
      'type': 'safety',
      'title': 'Broken Seatbelt',
      'description': 'Seatbelt in seat 3B not retracting properly',
      'status': 'in_progress',
      'priority': 'high',
      'date': '2024-01-23',
      'time': '03:20 PM',
      'location': 'Bus Depot',
      'attachments': 2,
      'comments': 'Scheduled for repair tomorrow',
    },
    {
      'id': 'RPT-004',
      'type': 'student_issue',
      'title': 'Student Medical Issue',
      'description': 'Student felt dizzy during trip',
      'status': 'resolved',
      'priority': 'high',
      'date': '2024-01-22',
      'time': '08:15 AM',
      'location': 'Oak Avenue Stop',
      'attachments': 0,
      'comments': 'Parent notified, student taken home',
    },
    {
      'id': 'RPT-005',
      'type': 'weather',
      'title': 'Heavy Rain Visibility',
      'description': 'Poor visibility due to heavy rainfall',
      'status': 'acknowledged',
      'priority': 'medium',
      'date': '2024-01-21',
      'time': '07:30 AM',
      'location': 'Entire Route',
      'attachments': 1,
      'comments': 'Driving with extra caution',
    },
  ];

  String _selectedFilter = 'all';
  String _selectedType = 'all';
  final List<String> _filters = ['all', 'pending', 'in_progress', 'resolved'];
  final List<String> _types = ['all', 'mechanical', 'traffic', 'safety', 'student_issue', 'weather', 'other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewReport,
        icon: const Icon(Icons.add_alert),
        label: const Text('New Report'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // Quick Stats
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildReportStat('Pending', Icons.pending, Color(0xFFFF9F7B),
                      _reports.where((r) => r['status'] == 'pending').length),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildReportStat('In Progress', Icons.build, Colors.deepPurpleAccent.shade100,
                      _reports.where((r) => r['status'] == 'in_progress').length),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildReportStat('Resolved', Icons.check_circle, Colors.teal,
                      _reports.where((r) => r['status'] == 'resolved').length),
                ),
              ],
            ),
          ),

          // Filters
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search reports...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.filter_alt),
                        onPressed: _showAdvancedFilters,
                        tooltip: 'Advanced Filters',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedFilter,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                          items: _filters.map((filter) {
                            return DropdownMenuItem(
                              value: filter,
                              child: Text(
                                filter == 'all' ? 'All Status' : filter.replaceAll('_', ' ').toUpperCase(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedFilter = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedType,
                          decoration: const InputDecoration(
                            labelText: 'Type',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                          items: _types.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(
                                type == 'all' ? 'All Types' : type.replaceAll('_', ' ').toUpperCase(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Reports List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _reports.length,
              itemBuilder: (context, index) {
                final report = _reports[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Report Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getTypeColor(report['type']).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getTypeIcon(report['type']),
                                color: _getTypeColor(report['type']),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    report['title'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    '${report['date']} • ${report['time']}',
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
                                report['status'].replaceAll('_', ' ').toUpperCase(),
                                style: const TextStyle(fontSize: 10),
                              ),
                              backgroundColor: _getStatusColor(report['status']).withOpacity(0.1),
                              labelStyle: TextStyle(
                                color: _getStatusColor(report['status']),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Report Details
                        Text(
                          report['description'],
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 12),

                        // Additional Info
                        Row(
                          children: [
                            _buildReportInfo('Location', Icons.location_on, report['location']),
                            const SizedBox(width: 16),
                            _buildReportInfo('Priority', Icons.priority_high, report['priority'].toUpperCase()),
                            if (report['attachments'] > 0) ...[
                              const SizedBox(width: 16),
                              _buildReportInfo('Files', Icons.attach_file, '${report['attachments']}'),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Comments
                        if (report['comments'].isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.comment, size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    report['comments'],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 12),

                        // Actions
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _viewReportDetails(report);
                                },
                                icon: const Icon(Icons.remove_red_eye, size: 16),
                                label: const Text('View Details'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _updateReportStatus(report);
                                },
                                icon: const Icon(Icons.edit, size: 16),
                                label: const Text('Update'),
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

  Widget _buildReportStat(String title, IconData icon, Color color, int count) {
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

  Widget _buildReportInfo(String label, IconData icon, String value) {
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

  void _createNewReport() {
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
                'Create New Report',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Report any incidents or issues during your route',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Report Type
              const Text(
                'Report Type',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Mechanical',
                  'Traffic',
                  'Safety',
                  'Student Issue',
                  'Weather',
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

              // Form Fields
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  hintText: 'Brief description of the issue',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  hintText: 'Describe the issue in detail...',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                        hintText: 'Where did it happen?',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Priority',
                        border: OutlineInputBorder(),
                      ),
                      items: ['low', 'medium', 'high', 'urgent']
                          .map((priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(priority.toUpperCase()),
                      ))
                          .toList(),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Requires Immediate Attention'),
                subtitle: const Text('Send emergency notification to admin'),
                value: false,
                onChanged: (value) {},
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Report submitted successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: const Text('Submit Report'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewReportDetails(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Report #${report['id']}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getTypeColor(report['type']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getTypeIcon(report['type']),
                        color: _getTypeColor(report['type']),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${report['date']} • ${report['time']}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Chip(
                      label: Text(
                        report['status'].replaceAll('_', ' ').toUpperCase(),
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: _getStatusColor(report['status']).withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: _getStatusColor(report['status']),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(report['description']),
                const SizedBox(height: 24),
                const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildDetailRow('Type', report['type'].replaceAll('_', ' ').toUpperCase()),
                _buildDetailRow('Priority', report['priority'].toUpperCase()),
                _buildDetailRow('Location', report['location']),
                _buildDetailRow('Date/Time', '${report['date']} ${report['time']}'),
                _buildDetailRow('Attachments', '${report['attachments']} file(s)'),
                const SizedBox(height: 24),
                if (report['comments'].isNotEmpty) ...[
                  const Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(report['comments']),
                  ),
                ],
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
                      child: ElevatedButton(
                        onPressed: () {
                          _updateReportStatus(report);
                          Navigator.pop(context);
                        },
                        child: const Text('Update Status'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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

  void _updateReportStatus(Map<String, dynamic> report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Report Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              value: report['status'],
              items: [
                DropdownMenuItem(
                  value: 'pending',
                  child: Row(
                    children: [
                      Icon(Icons.pending, color: Colors.orange),
                      const SizedBox(width: 8),
                      const Text('Pending'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'in_progress',
                  child: Row(
                    children: [
                      Icon(Icons.build, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text('In Progress'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'resolved',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      const Text('Resolved'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: 'closed',
                  child: Row(
                    children: [
                      Icon(Icons.done_all, color: Colors.grey),
                      const SizedBox(width: 8),
                      const Text('Closed'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {},
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Update Comments',
                border: OutlineInputBorder(),
                hintText: 'Add any updates or notes...',
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
                  content: Text('Report status updated'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showAdvancedFilters() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Advanced Filters'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Date Range
              const Text('Date Range', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'From',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'To',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Priority
              const Text('Priority', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['low', 'medium', 'high', 'urgent'].map((priority) {
                  return FilterChip(
                    label: Text(priority.toUpperCase()),
                    selected: false,
                    onSelected: (selected) {},
                  );
                }).toList(),
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filters applied'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Apply Filters'),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'mechanical':
        return Colors.pinkAccent;
      case 'traffic':
        return Colors.orange.shade300;
      case 'safety':
        return Colors.purpleAccent;
      case 'student_issue':
        return Colors.blue.shade300;
      case 'weather':
        return Colors.cyan.shade200;
      case 'other':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'mechanical':
        return Icons.build;
      case 'traffic':
        return Icons.traffic;
      case 'safety':
        return Icons.security;
      case 'student_issue':
        return Icons.people;
      case 'weather':
        return Icons.cloud;
      case 'other':
        return Icons.report;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Color(0xFFFF9F7B);
      case 'in_progress':
        return Colors.deepPurpleAccent.shade100;
      case 'resolved':
        return Colors.teal;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}