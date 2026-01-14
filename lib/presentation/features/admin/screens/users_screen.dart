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
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    return isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context);
  }

  Widget _buildDesktopLayout(BuildContext context) {
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

        // Stats Grid
        _buildStatsGrid(context),
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
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Users Table
        Expanded(
          child: _buildDesktopTable(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
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
            const SizedBox(height: 16),

            // Stats Grid
            _buildStatsGrid(context),
            const SizedBox(height: 16),

            // Filters Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search users...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedRole,
                            decoration: const InputDecoration(
                              labelText: 'Role',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12),
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
                        const SizedBox(width: 6),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedStatus,
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12),
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
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.upload_outlined),
                            label: const Text('Import'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showAddUserDialog();
                            },
                            icon: const Icon(Icons.person_add),
                            label: const Text('Add User'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Users List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Users (${_users.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Users List
            ..._users.map((user) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: _buildMobileUserItem(user, context),
              );
            }).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    final List<Map<String, dynamic>> _stats = [
      {
        'title': 'Total Users',
        'value': '2,847',
        'icon': Icons.people,
        'color': Colors.deepPurpleAccent.shade100,
        'change': '+125 this month',
      },
      {
        'title': 'Active Today',
        'value': '142',
        'icon': Icons.today,
        'color': Colors.teal,
        'change': '+12 yesterday',
      },
      {
        'title': 'New This Month',
        'value': '125',
        'icon': Icons.person_add,
        'color': Colors.orange.shade200,
        'change': '+25% last month',
      },
      {
        'title': 'Pending Verification',
        'value': '8',
        'icon': Icons.pending,
        'color': Colors.pinkAccent,
        'change': '3 need attention',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 4 : (isTablet ? 2 : 2),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isDesktop ? 1.8 : 1.2,
      ),
      itemCount: _stats.length,
      itemBuilder: (context, index) {
        final stat = _stats[index];
        return _buildUserStatCard(
          stat['title'] as String,
          stat['value'] as String,
          stat['icon'] as IconData,
          stat['color'] as Color,
          stat['change'] as String?,
        );
      },
    );
  }

  Widget _buildUserStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
      String? change,
      ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                if (change != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      change,
                      style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 48,
              child: DataTable(
                dataRowHeight: 70,
                columnSpacing: 20,
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
                        SizedBox(
                          width: 200,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: _getRoleColor(user['role']).withOpacity(0.1),
                              child: Icon(
                                _getRoleIcon(user['role']),
                                color: _getRoleColor(user['role']),
                                size: 20,
                              ),
                            ),
                            title: Text(user['name'], overflow: TextOverflow.ellipsis),
                            subtitle: Text(user['email'], overflow: TextOverflow.ellipsis),
                          ),
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
                      DataCell(
                        SizedBox(
                          width: 150,
                          child: Text(user['school'], overflow: TextOverflow.ellipsis),
                        ),
                      ),
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
                          mainAxisSize: MainAxisSize.min,
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
          ),
        ),
      ),
    );
  }

  Widget _buildMobileUserItem(Map<String, dynamic> user, BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    return Padding(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
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
                  size: isTablet ? 20 : 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                    Text(
                      user['email'],
                      style: TextStyle(
                        fontSize: isTablet ? 13 : 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Chip(
                label: Text(
                  user['status'].toString().capitalize(),
                  style: TextStyle(fontSize: isTablet ? 12 : 10),
                ),
                backgroundColor: _getStatusColor(user['status']).withOpacity(0.1),
                labelStyle: TextStyle(
                  color: _getStatusColor(user['status']),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMobileInfo('Role', user['role'], isTablet),
              const SizedBox(width: 16),
              _buildMobileInfo('School', user['school'], isTablet),
              const Spacer(),
              _buildMobileInfo('Last Login', user['lastLogin'], isTablet),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.edit_outlined, size: isTablet ? 16 : 14),
                  label: Text('Edit', style: TextStyle(fontSize: isTablet ? 14 : 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.remove_red_eye_outlined, size: isTablet ? 16 : 14),
                  label: Text('View', style: TextStyle(fontSize: isTablet ? 14 : 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileInfo(String label, String value, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 12 : 10,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: isTablet ? 14 : 12,
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
        return Colors.pinkAccent;
      case 'Parent':
        return Colors.cyan;
      case 'Driver':
        return Colors.orange.shade200;
      case 'Admin':
        return Colors.purpleAccent;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.teal;
      case 'inactive':
        return Colors.grey;
      case 'pending':
        return Colors.orange.shade300;
      case 'suspended':
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }
}