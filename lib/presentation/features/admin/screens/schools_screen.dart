import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bustracker_007/core/utils/string_extensions.dart';
import 'package:bustracker_007/data/models/web/school/school_model.dart';
import 'package:bustracker_007/core/services/api_service.dart';
import '../widgets/school_details_dialog.dart';
import '../widgets/edit_school_dialog.dart';

class SchoolsScreen extends StatefulWidget {
  const SchoolsScreen({super.key});

  @override
  State<SchoolsScreen> createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen> {
  List<School> _schools = [];
  SchoolStats? _stats;
  List<School> _filteredSchools = [];
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  String _selectedStatus = 'all';
  String _selectedSubscription = 'all';
  final List<String> _statuses = ['all', 'active', 'expiring', 'trial', 'inactive'];
  final List<String> _subscriptions = ['all', 'premium', 'basic', 'enterprise', 'trial'];


  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_searchDebounce?.isActive ?? false) {
      _searchDebounce?.cancel();
    }

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _apiService.dispose();
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final schools = await _apiService.getSchools(
        status: _selectedStatus == 'all' ? null : _selectedStatus,
        subscription: _selectedSubscription == 'all' ? null : _selectedSubscription,
      );

      final stats = await _apiService.getSchoolStats();

      setState(() {
        _schools = schools;
        _stats = stats;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });

      if (_schools.isEmpty) {
        _loadMockData();
      }
    }
  }

  void _applyFilters() {
    List<School> filtered = List.from(_schools);

    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((school) {
        return school.name.toLowerCase().contains(searchTerm) ||
            school.email.toLowerCase().contains(searchTerm) ||
            school.address.toLowerCase().contains(searchTerm) ||
            school.schoolId.toLowerCase().contains(searchTerm) ||
            school.phone.toLowerCase().contains(searchTerm);
      }).toList();
    }

    if (_selectedStatus != 'all') {
      filtered = filtered.where((school) {
        return school.status.toLowerCase() == _selectedStatus.toLowerCase();
      }).toList();
    }

    // Apply subscription filter
    if (_selectedSubscription != 'all') {
      filtered = filtered.where((school) {
        return school.subscription.toLowerCase() == _selectedSubscription.toLowerCase();
      }).toList();
    }

    setState(() {
      _filteredSchools = filtered;
    });
  }

  void _loadMockData() {
    setState(() {
      _schools = [
        School(
          schoolId: 'SCH-001',
          name: 'Greenwood High',
          email: 'contact@greenwood.edu',
          phone: '+1 (555) 123-4567',
          address: '123 Main St, Greenwood City',
          students: 500,
          buses: 10,
          status: 'active',
          subscription: 'Premium',
          createdAt: DateTime(2023, 12, 1),
        ),
      ];
      _stats = SchoolStats(
        totalSchools: 42,
        activeSchools: 38,
        newThisMonth: 5,
        totalStudents: 2300,
        totalBuses: 52,
        revenue: 12450.00,
      );
    });
  }

  void _handleStatusChange(String? value) {
    if (value != null) {
      setState(() {
        _selectedStatus = value;
      });
      _loadData();
    }
  }

  void _handleSubscriptionChange(String? value) {
    if (value != null) {
      setState(() {
        _selectedSubscription = value;
      });
      _loadData();
    }
  }
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1024;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error', style: TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

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
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('View on Map'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddSchoolDialog();
                  },
                  icon: const Icon(Icons.add_business),
                  label: const Text('Add School'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Stats Grid
        if (_stats != null) ...[
          _buildStatsGrid(context),
          const SizedBox(height: 15),
        ],

        // Filters Card
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
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search schools by name, location, or ID...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _applyFilters();
                            },
                          )
                              : null,
                        ),
                        onChanged: (value) {
                          // Triggered by the controller listener
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Status filter
                    Container(
                      width: 150,
                      child: DropdownButtonFormField<String>(
                        value: _selectedStatus,
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        items: _statuses.map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(status),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(status.capitalize()),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: _handleStatusChange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Subscription filter
                    Container(
                      width: 150,
                      child: DropdownButtonFormField<String>(
                        value: _selectedSubscription,
                        decoration: InputDecoration(
                          labelText: 'Subscription',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        items: _subscriptions.map((subscription) {
                          return DropdownMenuItem(
                            value: subscription,
                            child: Text(subscription),
                          );
                        }).toList(),
                        onChanged: _handleSubscriptionChange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Filter actions
                    OutlinedButton.icon(
                      onPressed: () {
                        _showAdvancedFiltersDialog();
                      },
                      icon: const Icon(Icons.filter_alt),
                      label: const Text('Advanced'),
                    ),
                    const SizedBox(width: 8),
                    // Reset filters button
                    if (_searchController.text.isNotEmpty ||
                        _selectedStatus != 'all' ||
                        _selectedSubscription != 'all')
                      TextButton.icon(
                        onPressed: () {
                          _resetFilters();
                        },
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Reset'),
                      ),
                  ],
                ),
                // Filter summary
                if (_filteredSchools.length != _schools.length) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Chip(
                        label: Text('${_filteredSchools.length} of ${_schools.length} schools'),
                        backgroundColor: Colors.blue.shade50,
                      ),
                      const SizedBox(width: 8),
                      if (_searchController.text.isNotEmpty)
                        Chip(
                          label: Row(
                            children: [
                              const Text('Search: '),
                              Text(
                                _searchController.text,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.clear, size: 14),
                                onPressed: () {
                                  _searchController.clear();
                                  _applyFilters();
                                },
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                          backgroundColor: Colors.grey.shade100,
                          onDeleted: () {
                            _searchController.clear();
                            _applyFilters();
                          },
                        ),
                      if (_selectedStatus != 'all')
                        Chip(
                          label: Row(
                            children: [
                              const Text('Status: '),
                              Text(_selectedStatus.capitalize()),
                              IconButton(
                                icon: const Icon(Icons.clear, size: 14),
                                onPressed: () {
                                  setState(() {
                                    _selectedStatus = 'all';
                                  });
                                  _applyFilters();
                                },
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                          backgroundColor: Colors.grey.shade100,
                        ),
                      if (_selectedSubscription != 'all')
                        Chip(
                          label: Row(
                            children: [
                              const Text('Plan: '),
                              Text(_selectedSubscription),
                              IconButton(
                                icon: const Icon(Icons.clear, size: 14),
                                onPressed: () {
                                  setState(() {
                                    _selectedSubscription = 'all';
                                  });
                                  _applyFilters();
                                },
                                padding: EdgeInsets.zero,
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                          backgroundColor: Colors.grey.shade100,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Schools Table
        Expanded(
          child: _schools.isEmpty ? const Center(child: Text('No schools found')) : _buildDesktopTable(),
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
            _buildStatsGrid(context),
            const SizedBox(height: 20),

            // Filters Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedSubscription,
                            decoration: const InputDecoration(
                              labelText: 'Subscription',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12),
                            ),
                            items: _subscriptions.map((subscription) {
                              return DropdownMenuItem(
                                value: subscription,
                                child: Text(subscription.capitalize()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSubscription = value!;
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
                            icon: const Icon(Icons.map_outlined),
                            label: const Text('View Map'),
                          ),
                        ),
                        const SizedBox(width: 12),
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
                  'Schools (${_schools.length})',
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
            ..._schools.map((school) {
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

  Widget _buildStatsGrid(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    final List<Map<String, dynamic>> _stats = [
      {
        'title': 'Total Schools',
        'value': '42',
        'icon': Icons.school,
        'color': Colors.deepPurpleAccent.shade100,
      },
      {
        'title': 'Active Today',
        'value': '38',
        'icon': Icons.today,
        'color': Colors.teal,
      },
      {
        'title': 'New This Month',
        'value': '5',
        'icon': Icons.new_releases,
        'color': Colors.orange.shade200,
      },
      {
        'title': 'Total Students',
        'value': '2,300',
        'icon': Icons.people,
        'color': Colors.purpleAccent,
      },
      {
        'title': 'Total Buses',
        'value': '52',
        'icon': Icons.directions_bus,
        'color': Colors.indigo.shade200,
      },
      {
        'title': 'Revenue/Month',
        'value': '\$12,450',
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
      itemCount: _stats.length,
      itemBuilder: (context, index) {
        final stat = _stats[index];
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
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 18),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
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
                  DataColumn(label: Text('School')),
                  DataColumn(label: Text('Contact')),
                  DataColumn(label: Text('Stats')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Subscription')),
                  DataColumn(label: Text('Created')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _filteredSchools.isEmpty && !_isLoading
                  ? [
                    DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 48,
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.search_off, size: 48, color: Colors.grey),
                                    SizedBox(height: 16),
                                    Text(
                                      'No schools found',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Try changing youe search or filters',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const DataCell(SizedBox()),
                        const DataCell(SizedBox()),
                        const DataCell(SizedBox()),
                        const DataCell(SizedBox()),
                        const DataCell(SizedBox()),
                        const DataCell(SizedBox()),
                      ],
                    ),
                ]
                : _filteredSchools.map((school)  {
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
                            subtitle: Text(school.address, overflow: TextOverflow.ellipsis),
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
                              Text(school.phone, overflow: TextOverflow.ellipsis),
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
                                  school.students.toString(),
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
                                  school.buses.toString(),
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
                      DataCell(
                        Chip(
                          label: Text(school.subscription),
                          backgroundColor: _getSubscriptionColor(school.subscription).withOpacity(0.1),
                          labelStyle: TextStyle(
                            color: _getSubscriptionColor(school.subscription),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataCell(Text(_formatDate(school.createdAt))),
                      DataCell(
                        PopupMenuButton(
                          shadowColor: Colors.green,
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'view',
                              child: ListTile(
                                leading: Icon(Icons.remove_red_eye, color: Colors.grey,),
                                title: Text('View Details', style: TextStyle(color: Colors.grey),),
                              ),
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  _showSchoolDetails(school);
                                });
                              },
                            ),
                            PopupMenuItem(
                              value: 'edit',
                              child: ListTile(
                                leading: Icon(Icons.edit, color: Colors.grey,),
                                title: Text('Edit School', style: TextStyle(color: Colors.grey),),
                              ),
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  _showEditSchoolDialog(school);
                                });
                              },
                            ),
                            const PopupMenuItem(
                              value: 'subscription',
                              child: ListTile(
                                leading: Icon(Icons.subscriptions, color: Colors.grey,),
                                title: Text('Manage Subscription', style: TextStyle(color: Colors.grey),),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'users',
                              child: ListTile(
                                leading: Icon(Icons.people, color: Colors.grey,),
                                title: Text('Manage Users', style: TextStyle(color: Colors.grey),),
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'buses',
                              child: ListTile(
                                leading: Icon(Icons.directions_bus, color: Colors.grey,),
                                title: Text('Manage Buses', style: TextStyle(color: Colors.grey),),
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
                      school.address,
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
                school.phone,
                style: TextStyle(fontSize: isTablet ? 14 : 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMobileStat('Students', school.students.toString(), isTablet),
              const SizedBox(width: 16),
              _buildMobileStat('Buses', school.buses.toString(), isTablet),
              const Spacer(),
              Chip(
                label: Text(
                  school.subscription,
                  style: TextStyle(fontSize: isTablet ? 12 : 10),
                ),
                backgroundColor: _getSubscriptionColor(school.subscription).withOpacity(0.1),
                labelStyle: TextStyle(
                  color: _getSubscriptionColor(school.subscription),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.remove_red_eye, size: isTablet ? 16 : 14),
                  label: Text('View', style: TextStyle(fontSize: isTablet ? 14 : 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
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

  void _showAddSchoolDialog() {
    // Create controllers for form fields
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _phoneController = TextEditingController();
    final TextEditingController _contactPersonController = TextEditingController();
    final TextEditingController _addressController = TextEditingController();
    final TextEditingController _cityController = TextEditingController();
    final TextEditingController _countryController = TextEditingController();
    final TextEditingController _studentsController = TextEditingController(text: '0');
    final TextEditingController _busesController = TextEditingController(text: '0');

    String _selectedStatus = 'active';
    String _selectedSubscription = 'Basic';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add New School',
                        style: TextStyle(
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
                  const SizedBox(height: 24),

                  // Make the form scrollable for mobile
                  SingleChildScrollView(
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 5,
                      children: [
                        // School Name (Required)
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'School Name *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.school),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter school name';
                            }
                            return null;
                          },
                        ),

                        // Email (Required)
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),

                        // Phone (Required)
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter phone number';
                            }
                            return null;
                          },
                        ),

                        // Contact Person
                        TextFormField(
                          controller: _contactPersonController,
                          decoration: const InputDecoration(
                            labelText: 'Contact Person',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),

                        // Address (Required)
                        TextFormField(
                          controller: _addressController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Address *',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter address';
                            }
                            return null;
                          },
                        ),

                        // City (Required)
                        TextFormField(
                          controller: _cityController,
                          decoration: const InputDecoration(
                            labelText: 'City *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.location_city),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter city';
                            }
                            return null;
                          },
                        ),

                        // Country (Required)
                        TextFormField(
                          controller: _countryController,
                          decoration: const InputDecoration(
                            labelText: 'Country *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.public),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter country';
                            }
                            return null;
                          },
                        ),

                        // Status Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.circle),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'active',
                              child: Row(
                                children: [
                                  Icon(Icons.circle, size: 12, color: Colors.green),
                                  const SizedBox(width: 8),
                                  const Text('Active'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'trial',
                              child: Row(
                                children: [
                                  Icon(Icons.circle, size: 12, color: Colors.orange),
                                  const SizedBox(width: 8),
                                  const Text('Trial'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'expiring',
                              child: Row(
                                children: [
                                  Icon(Icons.circle, size: 12, color: Colors.yellow[700]),
                                  const SizedBox(width: 8),
                                  const Text('Expiring'),
                                ],
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'inactive',
                              child: Row(
                                children: [
                                  Icon(Icons.circle, size: 12, color: Colors.red),
                                  const SizedBox(width: 8),
                                  const Text('Inactive'),
                                ],
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              _selectedStatus = value;
                            }
                          },
                        ),

                        // Subscription Plan
                        DropdownButtonFormField<String>(
                          value: _selectedSubscription,
                          decoration: const InputDecoration(
                            labelText: 'Subscription Plan *',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.subscriptions),
                          ),
                          items: ['Basic', 'Premium', 'Enterprise', 'Trial']
                              .map((plan) => DropdownMenuItem(
                            value: plan,
                            child: Text(plan),
                          ))
                              .toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select subscription plan';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value != null) {
                              _selectedSubscription = value;
                            }
                          },
                        ),

                        // Number of Students
                        TextFormField(
                          controller: _studentsController,
                          decoration: const InputDecoration(
                            labelText: 'Number of Students',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.people),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter number of students';
                            }
                            final int? students = int.tryParse(value);
                            if (students == null || students < 0) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),

                        // Number of Buses
                        TextFormField(
                          controller: _busesController,
                          decoration: const InputDecoration(
                            labelText: 'Number of Buses',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.directions_bus),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter number of buses';
                            }
                            final int? buses = int.tryParse(value);
                            if (buses == null || buses < 0) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Additional Info
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.info, size: 16, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Fields marked with * are required',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Clean up controllers
                            _nameController.dispose();
                            _emailController.dispose();
                            _phoneController.dispose();
                            _contactPersonController.dispose();
                            _addressController.dispose();
                            _cityController.dispose();
                            _countryController.dispose();
                            _studentsController.dispose();
                            _busesController.dispose();
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // Validate form
                            if (_formKey.currentState!.validate()) {
                              // Show loading indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );

                              try {
                                // Create School object from form data
                                final school = School(
                                  schoolId: '', // Will be generated by backend
                                  name: _nameController.text.trim(),
                                  email: _emailController.text.trim(),
                                  phone: _phoneController.text.trim(),
                                  address: '${_addressController.text.trim()}, ${_cityController.text.trim()}, ${_countryController.text.trim()}',
                                  students: int.parse(_studentsController.text),
                                  buses: int.parse(_busesController.text),
                                  status: _selectedStatus,
                                  subscription: _selectedSubscription,
                                  createdAt: DateTime.now(),
                                );

                                // Call API to add school
                                final newSchool = await _apiService.addSchool(school);

                                // Close loading dialog
                                Navigator.pop(context);

                                // Close add school dialog
                                Navigator.pop(context);

                                // Update local schools list
                                setState(() {
                                  _schools.insert(0, newSchool);
                                });

                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('School added successfully'),
                                    backgroundColor: Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );

                                // Refresh stats
                                _loadData();

                              } catch (e) {
                                // Close loading dialog
                                Navigator.pop(context);

                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to add school: $e'),
                                    backgroundColor: Colors.red,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text('Add School'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAdvancedFiltersDialog() {
    int? minStudents;
    int? maxStudents;
    int? minBuses;
    int? maxBuses;
    DateTimeRange? dateRange;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.filter_alt),
                SizedBox(width: 8),
                Text('Advanced Filters'),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student range
                  const Text(
                    'Number of Students',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Min',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            minStudents = int.tryParse(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Max',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            maxStudents = int.tryParse(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Buses range
                  const Text(
                    'Number of Buses',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Min',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            minBuses = int.tryParse(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Max',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            maxBuses = int.tryParse(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Date range
                  const Text(
                    'Registration Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () async {
                      final DateTimeRange? picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        initialDateRange: dateRange,
                      );
                      if (picked != null) {
                        setState(() {
                          dateRange = picked;
                        });
                      }
                    },
                    child: Text(
                      dateRange != null
                          ? '${_formatDate(dateRange!.start)} - ${_formatDate(dateRange!.end)}'
                          : 'Select Date Range',
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
                  // Apply advanced filters
                  _applyAdvancedFilters(
                    minStudents: minStudents,
                    maxStudents: maxStudents,
                    minBuses: minBuses,
                    maxBuses: maxBuses,
                    dateRange: dateRange,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _applyAdvancedFilters({
    int? minStudents,
    int? maxStudents,
    int? minBuses,
    int? maxBuses,
    DateTimeRange? dateRange,
  }) {
    // You can extend the _applyFilters method or create a new one
    // For simplicity, I'll show how to add this to the existing filter logic
    // You would need to update _applyFilters to include these parameters
  }

  void _showEditSchoolDialog(School school) {
    showDialog(
      context: context,
      builder: (context) => EditSchoolDialog(
        school: school,
        apiService: _apiService,
        onSchoolUpdated: (School updatedSchool) {
          setState(() {
            final index = _schools.indexWhere((s)=> s.schoolId == updatedSchool.schoolId);
            if (index != -1) {
              _schools[index] = updatedSchool;
            }
          });
        },
        onRefreshData: _loadData,
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedStatus = 'all';
      _selectedSubscription = 'all';
    });
    _applyFilters();
  }

  void _showSchoolDetails(School school) {
    showDialog(
      context: context,
      builder: (context) => SchoolDetailsDialog(school: school),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
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

  Future<void> _deleteSchool(School school) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete School'),
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
      try{
        await _apiService.deleteSchool(school.schoolId);
        setState(() {
          _schools.removeWhere((s) => s.schoolId == school.schoolId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('School deleted successfully'), backgroundColor: Colors.greenAccent,),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete school: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}