import 'package:flutter/material.dart';
import 'package:bustracker_007/core/utils/string_extensions.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final List<Map<String, dynamic>> _users = [
    {
      'id': 'U-001',
      'name': 'John Smith',
      'email': 'john@greenwood.edu',
      'role': 'School Manager',
      'school': 'Greenwood High',
      'status': 'active',
      'lastLogin': '2024-01-25 14:30',
      'createdAt': '2023-12-01',
    },
    {
      'id': 'U-002',
      'name': 'Sarah Johnson',
      'email': 'sarah@sunrise.edu',
      'role': 'Parent',
      'school': 'Sunrise Academy',
      'status': 'active',
      'lastLogin': '2024-01-25 10:15',
      'createdAt': '2024-01-05',
    },
    {
      'id': 'U-003',
      'name': 'Mike Wilson',
      'email': 'mike@central.edu',
      'role': 'Driver',
      'school': 'Central School',
      'status': 'inactive',
      'lastLogin': '2024-01-20 08:45',
      'createdAt': '2023-12-15',
    },
    {
      'id': 'U-004',
      'name': 'Emily Davis',
      'email': 'emily@northwood.edu',
      'role': 'School Manager',
      'school': 'Northwood School',
      'status': 'active',
      'lastLogin': '2024-01-25 16:20',
      'createdAt': '2024-01-10',
    },
    {
      'id': 'U-005',
      'name': 'Robert Brown',
      'email': 'robert@valley.edu',
      'role': 'Parent',
      'school': 'Valley Prep',
      'status': 'pending',
      'lastLogin': 'Never',
      'createdAt': '2024-01-22',
    },
  ];

  String _selectedRole = 'all';
  String _selectedStatus = 'all';
  final List<String> _roles = ['all', 'admin', 'school_manager', 'parent', 'driver'];
  final List<String> _statuses = ['all', 'active', 'inactive', 'pending', 'suspended'];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1024;

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
                  'User Management',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage all system users and permissions',
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
                    icon: const Icon(Icons.upload_outlined),
                    label: const Text('Import'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddUserDialog();
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add User'),
                  ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 24),

        // Quick Stats
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildUserStat('Total Users', '2,847', Icons.people, Colors.blue),
            _buildUserStat('Active Today', '142', Icons.today, Colors.green),
            _buildUserStat('New This Month', '125', Icons.person_add, Colors.orange),
            _buildUserStat('Pending Verification', '8', Icons.pending, Colors.red),
          ],
        ),
        const SizedBox(height: 24),

        // Filters Card
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
                          hintText: 'Search users by name, email, or role...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    if (isDesktop) ...[
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: _selectedRole,
                        items: _roles.map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(_formatRole(role)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value!;
                          });
                        },
                      ),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: _selectedStatus,
                        items: _statuses.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status.capitalize()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                          });
                        },
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.filter_alt),
                        label: const Text('More Filters'),
                      ),
                    ],
                  ],
                ),
                if (!isDesktop) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: const InputDecoration(
                            labelText: 'Role',
                            border: OutlineInputBorder(),
                          ),
                          items: _roles.map((role) {
                            return DropdownMenuItem(
                              value: role,
                              child: Text(_formatRole(role)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          items: _statuses.map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status.capitalize()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddUserDialog();
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add User'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Users Table/List
        Expanded(
          child: isDesktop
              ? _buildDesktopTable()
              : _buildMobileList(),
        ),
      ],
    );
  }

  Widget _buildUserStat(String title, String value, IconData icon, Color color) {
    return Card(
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                const Icon(Icons.more_vert, size: 20, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopTable() {
    return Card(
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('User')),
            DataColumn(label: Text('Role')),
            DataColumn(label: Text('School')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Last Login')),
            DataColumn(label: Text('Created')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _users.map((user) {
            return DataRow(
              cells: [
                DataCell(
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: _getRoleColor(user['role']).withOpacity(0.1),
                      child: Icon(
                        _getRoleIcon(user['role']),
                        color: _getRoleColor(user['role']),
                        size: 20,
                      ),
                    ),
                    title: Text(user['name']),
                    subtitle: Text(user['email']),
                  ),
                ),
                DataCell(
                  Chip(
                    label: Text(user['role']),
                    backgroundColor: _getRoleColor(user['role']).withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: _getRoleColor(user['role']),
                      fontSize: 12,
                    ),
                  ),
                ),
                DataCell(Text(user['school'])),
                DataCell(
                  Chip(
                    label: Text(user['status'].toString().capitalize()),
                    backgroundColor: _getStatusColor(user['status']).withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: _getStatusColor(user['status']),
                      fontSize: 12,
                    ),
                  ),
                ),
                DataCell(Text(user['lastLogin'])),
                DataCell(Text(user['createdAt'])),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        onPressed: () {},
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                        onPressed: () {},
                        tooltip: 'View',
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, size: 18),
                        onPressed: () {},
                        tooltip: 'More',
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
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
                      backgroundColor: _getRoleColor(user['role']).withOpacity(0.1),
                      child: Icon(
                        _getRoleIcon(user['role']),
                        color: _getRoleColor(user['role']),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user['email'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Chip(
                      label: Text(user['status'].toString().capitalize()),
                      backgroundColor: _getStatusColor(user['status']).withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: _getStatusColor(user['status']),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildMobileInfo('Role', user['role']),
                    const SizedBox(width: 24),
                    _buildMobileInfo('School', user['school']),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildMobileInfo('Last Login', user['lastLogin']),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      onPressed: () {},
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                      onPressed: () {},
                      tooltip: 'View',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileInfo(String label, String value) {
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

  void _showAddUserDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(),
                ),
                items: ['School Manager', 'Parent', 'Driver', 'Admin']
                    .map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(role),
                ))
                    .toList(),
                onChanged: (value) {},
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'School/Organization',
                  border: OutlineInputBorder(),
                ),
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
                  content: Text('User added successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }

  String _formatRole(String role) {
    switch (role) {
      case 'all':
        return 'All Roles';
      case 'school_manager':
        return 'School Manager';
      default:
        return role.capitalize();
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'School Manager':
        return Icons.school;
      case 'Parent':
        return Icons.family_restroom;
      case 'Driver':
        return Icons.drive_eta;
      case 'Admin':
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'School Manager':
        return Colors.blue;
      case 'Parent':
        return Colors.green;
      case 'Driver':
        return Colors.orange;
      case 'Admin':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.grey;
      case 'pending':
        return Colors.orange;
      case 'suspended':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}