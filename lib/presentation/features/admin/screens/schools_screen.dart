import 'package:bustracker_007/core/repositories/school_repository.dart';
import 'package:bustracker_007/presentation/features/admin/widgets/view_school_dialog.dart';
import 'package:flutter/material.dart';
import '../../../../data/models/web/school.dart';
import '../widgets/add_school_dialog.dart';

class SchoolsScreen extends StatefulWidget {
  const SchoolsScreen({super.key});

  @override
  State<SchoolsScreen> createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen> {
  final SchoolRepository _schoolRepository = SchoolRepository();
  late Future<Map<String, dynamic>> _statsFuture;
  bool _isLoading = true;

  List<School> _allSchools = [];
  List<School> _filteredSchools = [];
  String _selectedStatus = 'all';
  String _selectedSubscription = 'all';
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadSchools();
  }

  Future<void> _loadSchools() async {
    setState(() => _isLoading = true);

    final schools = await _schoolRepository.getSchools();
    final stats = await _schoolRepository.getSchoolStats();

    setState(() {
      _allSchools = schools;
      _filteredSchools = schools;
      _statsFuture = Future.value(stats);
      _isLoading = false;
    });
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredSchools = _allSchools.where((school) {
        final matchesSearch =
            school.name.toLowerCase().contains(query) ||
                (school.address ?? '').toLowerCase().contains(query) ||
                school.email.toLowerCase().contains(query);

        final matchesStatus =
            _selectedStatus == 'all' || school.status.toLowerCase() == _selectedStatus;

        return matchesSearch && matchesStatus;
      }).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    return isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context);
  }

  Widget _buildDesktopLayout(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
                  'Schools Management',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage all registered schools and institutions',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: _showAddSchoolDialog,
              icon: const Icon(Icons.add_business),
              label: const Text('Add School'),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Stats
        FutureBuilder<Map<String, dynamic>>(
          future: _statsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            return _buildStatsGrid(context, snapshot.data!);
          },
        ),

        const SizedBox(height: 15),

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
                        controller: _searchController,
                        onChanged: (_) => _applyFilters(),
                        decoration: InputDecoration(
                          hintText: 'Search schools by name, location, or ID...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      value: _selectedStatus,
                      items: ['all', 'active', 'expiring', 'trial', 'inactive'].map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.capitalize()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _selectedStatus = value!;
                        _applyFilters();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // TABLE
        Expanded(child: _buildDesktopTable()),
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
                  'Schools Management',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Manage all registered schools and institutions',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stats Grid
            FutureBuilder<Map<String, dynamic>>(
              future: _statsFuture,
              builder: (context, statsSnapshot) {
                if (statsSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (statsSnapshot.hasData) {
                  return _buildStatsGrid(context, statsSnapshot.data!);
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 20),

            // Filters Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (_) => _applyFilters(),
                      decoration: InputDecoration(
                        hintText: 'Search schools...',
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
                            value: _selectedStatus,
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12),
                            ),
                            items: ['all', 'active', 'expiring', 'trial', 'inactive'].map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status.capitalize()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              _selectedStatus = value!;
                              _applyFilters();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showAddSchoolDialog();
                            },
                            icon: const Icon(Icons.add_business),
                            label: const Text('Add School'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Schools List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Schools (${_filteredSchools.length})',
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

            // Schools List
            ..._filteredSchools.map((school) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: _buildMobileSchoolItem(school, context),
              );
            }).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, Map<String, dynamic> stats) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    final List<Map<String, dynamic>> statCards = [
      {
        'title': 'Total Schools',
        'value': stats['total_schools'].toString(),
        'icon': Icons.school,
        'color': Colors.deepPurpleAccent.shade100,
      },
      {
        'title': 'Active Today',
        'value': stats['active_schools'].toString(),
        'icon': Icons.today,
        'color': Colors.teal,
      },
      {
        'title': 'New This Month',
        'value': stats['new_this_month'].toString(),
        'icon': Icons.new_releases,
        'color': Colors.orange.shade200,
      },
      {
        'title': 'Total Students',
        'value': stats['total_students'].toString(),
        'icon': Icons.people,
        'color': Colors.purpleAccent,
      },
      {
        'title': 'Total Buses',
        'value': stats['total_buses'].toString(),
        'icon': Icons.directions_bus,
        'color': Colors.indigo.shade200,
      },
      {
        'title': 'Revenue/Month',
        'value': '\$${stats['revenue_per_month']}',
        'icon': Icons.attach_money,
        'color': Colors.cyan,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 6 : (isTablet ? 3 : 2),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: isDesktop ? 1.2 : 1.1,
      ),
      itemCount: statCards.length,
      itemBuilder: (context, index) {
        final stat = statCards[index];
        return _buildSchoolStatCard(
          stat['title'] as String,
          stat['value'] as String,
          stat['icon'] as IconData,
          stat['color'] as Color,
        );
      },
    );
  }

  Widget _buildSchoolStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
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
    if (_filteredSchools.isEmpty) {
      return const Center(child: Text('No schools found'));
    }
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
                  DataColumn(label: Text('School')),
                  DataColumn(label: Text('Contact')),
                  DataColumn(label: Text('Stats')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Created')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _filteredSchools.map((school) {
                  return DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: 200,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.withOpacity(0.1),
                              child: const Icon(Icons.school, size: 20, color: Colors.blue),
                            ),
                            title: Text(school.name, overflow: TextOverflow.ellipsis),
                            subtitle: Text(school.address ?? '', overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: 180,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(school.email, overflow: TextOverflow.ellipsis),
                              Text(school.phone ?? '', overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  school.totalStudents.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Text(
                                  'Students',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  school.totalBuses.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Text(
                                  'Buses',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Chip(
                          label: Text(school.status.toString().capitalize()),
                          backgroundColor: _getStatusColor(school.status).withOpacity(0.1),
                          labelStyle: TextStyle(
                            color: _getStatusColor(school.status),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataCell(Text(school.createdAt.toString().split(' ')[0])),
                      DataCell(
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'view',
                              child: ListTile(
                                leading: Icon(Icons.remove_red_eye, color: Colors.grey),
                                title: Text('View Details', style: TextStyle(color: Colors.grey),),
                              ),
                              onTap: () => _viewSchoolDetails(school),
                            ),
                            PopupMenuItem(
                              value: 'edit',
                              child: ListTile(
                                leading: Icon(Icons.edit, color: Colors.grey),
                                title: Text('Edit School', style: TextStyle(color: Colors.grey),),
                              ),
                              onTap: () => _editSchool(school),
                            ),
                            const PopupMenuItem(
                              value: 'users',
                              child: ListTile(
                                leading: Icon(Icons.people, color: Colors.grey,),
                                title: Text('Manage Users', style: TextStyle(color: Colors.grey,)),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'buses',
                              child: ListTile(
                                leading: Icon(Icons.directions_bus, color: Colors.grey),
                                title: Text('Manage Buses', style: TextStyle(color: Colors.grey,)),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: ListTile(
                                leading: Icon(Icons.delete, color: Colors.red),
                                title: Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                              onTap: () => _deleteSchool(school),
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

  Widget _buildMobileSchoolItem(School school, BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    return Padding(
      padding: EdgeInsets.all(isTablet ? 16 : 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.withOpacity(0.1),
                child: const Icon(Icons.school, size: 20, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      school.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                    Text(
                      school.address ?? '',
                      style: TextStyle(
                        fontSize: isTablet ? 13 : 11,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Chip(
                label: Text(
                  school.status.toString().capitalize(),
                  style: TextStyle(fontSize: isTablet ? 12 : 10),
                ),
                backgroundColor: _getStatusColor(school.status).withOpacity(0.1),
                labelStyle: TextStyle(
                  color: _getStatusColor(school.status),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact',
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                school.email,
                style: TextStyle(fontSize: isTablet ? 14 : 12),
              ),
              Text(
                school.phone ?? '',
                style: TextStyle(fontSize: isTablet ? 14 : 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMobileStat('Students', school.totalStudents.toString(), isTablet),
              const SizedBox(width: 16),
              _buildMobileStat('Buses', school.totalBuses.toString(), isTablet),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _viewSchoolDetails(school),
                  icon: Icon(Icons.remove_red_eye, size: isTablet ? 16 : 14),
                  label: Text('View', style: TextStyle(fontSize: isTablet ? 14 : 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _editSchool(school),
                  icon: Icon(Icons.edit, size: isTablet ? 16 : 14),
                  label: Text('Edit', style: TextStyle(fontSize: isTablet ? 14 : 12)),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.more_vert, size: isTablet ? 20 : 18),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileStat(String label, String value, bool isTablet) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 12 : 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  void _showAddSchoolDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddSchoolDialog(),
    );

    if (result == true) {
      _loadSchools();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('School added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _viewSchoolDetails(School school) {
    showDialog(
      context: context,
      builder: (_) => ViewSchoolDialog(school: school),
    );
  }

  void _editSchool(School school) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddSchoolDialog(school: school),
    );

    if (result == true) {
      _loadSchools();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('School updated successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _deleteSchool(School school) async {
    final confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${school.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _schoolRepository.deleteSchool(school.id!);
        _loadSchools();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${school.name} deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting school: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.teal;
      case 'expiring':
        return Colors.orange.shade200;
      case 'trial':
        return Colors.deepPurpleAccent.shade100;
      case 'inactive':
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }

  Color _getSubscriptionColor(String subscription) {
    switch (subscription) {
      case 'Premium':
        return Colors.purpleAccent;
      case 'Enterprise':
        return Colors.deepPurpleAccent.shade100;
      case 'Basic':
        return Colors.teal;
      case 'Trial':
        return Colors.orange.shade200;
      default:
        return Colors.grey;
    }
  }
}

