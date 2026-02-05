import 'package:bustracker_007/core/services/api_service.dart';
import 'package:bustracker_007/data/models/web/school_subscription.dart';
import 'package:flutter/material.dart';
import '../../../../data/models/web/subscription_plan.dart';
import '../../../../data/models/web/school.dart';
import 'dart:convert';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';

  // Mock data
  final ApiService _apiService = ApiService();
  List<SchoolSubscription> _subscriptions = [];
  List<SubscriptionPlan> _availablePlans = [];
  final List<Map<String, dynamic>> _invoices = [
    {
      'id': 'INV-2024-001',
      'schoolName': 'Greenwood High',
      'amount': 499.99,
      'date': '2024-01-10',
      'status': 'paid',
      'items': [
        {'name': 'Enterprise Plan', 'quantity': 1, 'price': 499.99},
      ],
    },
    {
      'id': 'INV-2024-002',
      'schoolName': 'Maplewood Academy',
      'amount': 899.97,
      'date': '2024-01-05',
      'status': 'paid',
      'items': [
        {'name': 'Pro Plan (Quarterly)', 'quantity': 1, 'price': 899.97},
      ],
    },
    {
      'id': 'INV-2024-003',
      'schoolName': 'Riverside School',
      'amount': 149.99,
      'date': '2024-01-13',
      'status': 'overdue',
      'items': [
        {'name': 'Basic Plan', 'quantity': 1, 'price': 149.99},
      ],
    },
  ];
  bool _loadingPlans = true;
  bool _loadingSubscriptions = true;
  String _errorMessage = '';


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadPlans();
    _loadSubscriptions();
  }

  Future<void> _loadPlans() async {
    setState(() {
      _loadingPlans = true;
      _errorMessage = '';
    });

    try {
      final plans = await _apiService.getAllPlans();
      setState(() {
        _availablePlans = plans;
        _loadingPlans = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load plans: $e';
        _loadingPlans = false;
      });
    }
  }

  Future<void> _loadSubscriptions() async {
    setState(() {
      _loadingSubscriptions = true;
    });
    try {
      final subscriptions = await _apiService.getSubscriptions();
      print('DEBUG: Loaded ${subscriptions.length} subscriptions'); // ADD THIS
      for (var sub in subscriptions) {
        print('DEBUG: Subscription: ${sub.schoolName}, Status: ${sub.status}');
      }
      setState(() {
        _subscriptions = subscriptions;
        _loadingSubscriptions = false;
      });
    } catch (e) {
      print('DEBUG: Error loading subscriptions: $e'); // ADD THIS
      setState(() {
        _loadingSubscriptions = false;
      });
    }
  }

  Future<void> _refreshPlans() async {
    await _loadPlans();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;
        final isTablet = constraints.maxWidth >= 768;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with stats - Responsive layout
            _buildStatsHeader(isDesktop, isTablet),
            const SizedBox(height: 10),

            // Tabs - Responsive font size
            Container(
              constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : double.infinity),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Subscriptions'),
                  Tab(text: 'Billing Plans'),
                  Tab(text: 'Invoices'),
                ],
                labelColor: Theme.of(context).colorScheme.primary,
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelStyle: TextStyle(
                  fontSize: isDesktop ? 14 : 12,
                ),
                isScrollable: !isDesktop,
              ),
            ),
            const SizedBox(height: 10),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSubscriptionsTab(isDesktop, isTablet),
                  _buildPlansTab(isDesktop, isTablet),
                  _buildInvoicesTab(isDesktop, isTablet),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsHeader(bool isDesktop, bool isTablet) {
    // Calculate stats from SchoolSubscription objects
    final totalRevenue = _subscriptions
        .where((s) => s.status == 'active')
        .fold(0.0, (sum, s) => sum + s.amount); // Use s.amount

    final activeSubscriptions = _subscriptions
        .where((s) => s.status == 'active')
        .length;

    final upcomingRenewals = _subscriptions
        .where((s) {
      // Use s.endDate directly
      return s.endDate.difference(DateTime.now()).inDays <= 7;
    })
        .length;

    // Responsive grid for stats
    final crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 1);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: isDesktop ? 2 : 1.5,
      children: [
        _buildStatCard(
          'Total Revenue',
          '\$${totalRevenue.toStringAsFixed(2)}/month',
          Icons.attach_money,
          Colors.teal,
        ),
        _buildStatCard(
          'Active Subscriptions',
          activeSubscriptions.toString(),
          Icons.subscriptions,
          Colors.deepPurpleAccent.shade100,
        ),
        _buildStatCard(
          'Upcoming Renewals',
          upcomingRenewals.toString(),
          Icons.calendar_today,
          Colors.orange.shade200,
        ),
        _buildStatCard(
          'Annual Revenue',
          '\$${(totalRevenue * 12).toStringAsFixed(2)}',
          Icons.bar_chart,
          Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionsTab(bool isDesktop, bool isTablet) {

    final filteredSubscriptions = _subscriptions.where((sub) {
      final schoolName = (sub.schoolName ?? '').toLowerCase() ?? '';
      final searchQuery = _searchController.text.toLowerCase();
      final statusMatch = _selectedFilter == 'all' || sub.status == _selectedFilter;

      return (schoolName.contains(searchQuery) || searchQuery.isEmpty) && statusMatch;
    }).toList();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 0 : 8,
      ),
      child: Column(
        children: [
          // Search and filter bar - Responsive layout
          if (isDesktop)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search subscriptions...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: const [
                    DropdownMenuItem<String>(
                      value: 'all',
                      child: Text('All Status'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'active',
                      child: Text('Active'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'pending',
                      child: Text('Pending'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'cancelled',
                      child: Text('Cancelled'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _showCreateSubscriptionDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('New Subscription'),
                ),
              ],
            )
          else
            Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search subscriptions...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedFilter,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'all',
                            child: Text('All Status'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'active',
                            child: Text('Active'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'pending',
                            child: Text('Pending'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'cancelled',
                            child: Text('Cancelled'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedFilter = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _showCreateSubscriptionDialog,
                      icon: const Icon(Icons.add),
                      label: isTablet ? const Text('New Subscription') : const Text('New'),
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 16),

          // Subscriptions list
          Expanded(
            child: ListView.builder(
              itemCount: filteredSubscriptions.length,
              itemBuilder: (context, index) {
                final subscription = filteredSubscriptions[index];
                return _buildSubscriptionCard(subscription, isDesktop, isTablet);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(
      SchoolSubscription subscription,
      bool isDesktop,
      bool isTablet,
      ) {
    final schoolName = subscription.schoolName ?? 'Unknown School';
    final schoolCode = subscription.schoolCode.toString() ?? 'N/A';
    final planName = subscription.plan?.name ?? 'Unknown Plan';
    final students = subscription.totalStudents ?? 0;
    final buses = subscription.totalBuses ?? 0;
    final price = subscription.amount;
    final billingCycle = subscription.plan?.billingCycle ?? 'Monthly';
    final startDate = subscription.startDate.toString().split(' ')[0];
    final renewDate = subscription.endDate.toString().split(' ')[0];
    final features = subscription.plan?.features ?? {};

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 16 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schoolName,
                        style: TextStyle(
                          fontSize: isDesktop ? 18 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'ID: $schoolCode',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(subscription.status),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    subscription.status.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Plan details - Responsive layout
            if (isDesktop)
              Row(
                children: [
                  _buildInfoItem('Plan', planName, isDesktop),
                  const SizedBox(width: 24),
                  _buildInfoItem('Price', '\$${price.toStringAsFixed(2)}', isDesktop),
                  const SizedBox(width: 24),
                  _buildInfoItem('Cycle', billingCycle, isDesktop),
                  const SizedBox(width: 24),
                  _buildInfoItem('Students', students.toString(), isDesktop),
                  const SizedBox(width: 24),
                  _buildInfoItem('Buses', buses.toString(), isDesktop),
                ],
              )
            else
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildInfoItem('Plan', planName, isDesktop),
                  _buildInfoItem('Price', '\$${price.toStringAsFixed(2)}', isDesktop),
                  _buildInfoItem('Cycle', billingCycle, isDesktop),
                  _buildInfoItem('Students', students.toString(), isDesktop),
                  _buildInfoItem('Buses', buses.toString(), isDesktop),
                ],
              ),
            const SizedBox(height: 12),

            // Features
            if (features.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: features.entries.map((entry) {
                  return Chip(
                    label: Text(
                      '${entry.key}: ${entry.value}',
                      style: TextStyle(fontSize: isDesktop ? 12 : 10),
                    ),
                    backgroundColor: Colors.teal,
                  );
                }).toList(),
              ),
            const SizedBox(height: 12),

            // Dates and actions
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start: $startDate',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Renewal: $renewDate',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _editSubscription(subscription),
                      tooltip: 'Edit',
                    ),
                    if (isDesktop || isTablet) ...[
                      IconButton(
                        icon: const Icon(Icons.receipt, size: 20),
                        onPressed: () => _viewInvoice(subscription),
                        tooltip: 'View Invoice',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: () => _deleteSubscription(subscription),
                        tooltip: 'Delete',
                        color: Colors.red,
                      ),
                    ] else
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'view',
                            child: Text('View Invoice'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == 'view') {
                            _viewInvoice(subscription);
                          } else if (value == 'delete') {
                            _deleteSubscription(subscription);
                          }
                        },
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlansTab(bool isDesktop, bool isTablet) {
    if (_loadingPlans) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPlans,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _refreshPlans,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 0 : 8,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _showCreatePlanDialog,
                  icon: const Icon(Icons.add),
                  label: isDesktop || isTablet
                      ? const Text('Create New Plan')
                      : const Text('New Plan'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Responsive grid for plans
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isDesktop ? 0.8 : 0.9,
                    ),
                    itemCount: _availablePlans.length,
                    itemBuilder: (context, index) {
                      return _buildPlanCard(_availablePlans[index], isDesktop);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan, bool isDesktop) {
    final features = plan.features ?? {};
    final limitations = plan.limitations ?? {};

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: TextStyle(
                          fontSize: isDesktop ? 20 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (plan.planCode.isNotEmpty)
                        Text(
                          plan.planCode,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _editPlan(plan),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () => _deletePlan(plan),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              plan.description,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Text(
              '\$${plan.price.toStringAsFixed(2)}/${plan.billingCycle.toLowerCase()}',
              style: TextStyle(
                fontSize: isDesktop ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (plan.maxStudents != null) ...[
              const SizedBox(height: 8),
              Text(
                'Max Students: ${plan.maxStudents}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
            if (plan.maxBuses != null) ...[
              Text(
                'Max Buses: ${plan.maxBuses}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (features.isNotEmpty) ...[
                      const Text(
                        'Features:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...features.entries.map<Widget>((feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check, color: Colors.green, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                feature.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                    if (limitations.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Limitations:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...limitations.entries.map<Widget>((limitation) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.close, color: Colors.red, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                limitation.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _assignPlan(plan),
                child: const Text('Assign to School'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoicesTab(bool isDesktop, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 0 : 8,
      ),
      child: Column(
        children: [
          // Responsive search bar
          if (isDesktop)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search invoices...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _generateReport,
                  icon: const Icon(Icons.download),
                  label: const Text('Export Report'),
                ),
              ],
            )
          else
            Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search invoices...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _generateReport,
                  icon: const Icon(Icons.download),
                  label: const Text('Export Report'),
                ),
              ],
            ),
          const SizedBox(height: 16),

          // Responsive table/list
          Expanded(
            child: isDesktop
                ? _buildDesktopInvoiceTable()
                : _buildMobileInvoiceList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopInvoiceTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Invoice ID')),
          DataColumn(label: Text('School')),
          DataColumn(label: Text('Amount')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: _invoices.map((invoice) {
          return DataRow(cells: [
            DataCell(Text(invoice['id'] as String)),
            DataCell(Text(invoice['schoolName'] as String)),
            DataCell(Text('\$${(invoice['amount'] as double).toStringAsFixed(2)}')),
            DataCell(Text(invoice['date'] as String)),
            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getInvoiceStatusColor(invoice['status'] as String),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  (invoice['status'] as String).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            DataCell(
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility, size: 20),
                    onPressed: () => _viewInvoiceDetails(invoice),
                  ),
                  IconButton(
                    icon: const Icon(Icons.download, size: 20),
                    onPressed: () => _downloadInvoice(invoice),
                  ),
                  IconButton(
                    icon: const Icon(Icons.receipt_long, size: 20),
                    onPressed: () => _sendReminder(invoice),
                  ),
                ],
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildMobileInvoiceList() {
    return ListView.builder(
      itemCount: _invoices.length,
      itemBuilder: (context, index) {
        final invoice = _invoices[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        invoice['id'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getInvoiceStatusColor(invoice['status'] as String),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        (invoice['status'] as String).toUpperCase(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  invoice['schoolName'] as String,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${(invoice['amount'] as double).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      invoice['date'] as String,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, size: 20),
                      onPressed: () => _viewInvoiceDetails(invoice),
                      tooltip: 'View',
                    ),
                    IconButton(
                      icon: const Icon(Icons.download, size: 20),
                      onPressed: () => _downloadInvoice(invoice),
                      tooltip: 'Download',
                    ),
                    IconButton(
                      icon: const Icon(Icons.receipt_long, size: 20),
                      onPressed: () => _sendReminder(invoice),
                      tooltip: 'Send Reminder',
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

  Widget _buildInfoItem(String label, String value, bool isDesktop) {
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
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: isDesktop ? 14 : 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.teal;
      case 'pending':
        return Colors.orange.shade200;
      case 'cancelled':
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }

  Color _getInvoiceStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'overdue':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showCreateSubscriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => CreateSubscriptionDialog(
        apiService: _apiService,
        onSubscriptionCreated: (newSubscription) async {
          try {
            await _loadSubscriptions();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Subscription created successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error refreshing list: $e')),
            );
          }
        },
      ),
    );
  }

  void _showCreatePlanDialog() {
    showDialog(
      context: context,
      builder: (context) => CreatePlanDialog(
        onPlanCreated: (newPlan) async {
          try {
            final createdPlan = await _apiService.createPlan(newPlan);
            setState(() {
              _availablePlans.add(createdPlan);
            });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Plan created successfully')),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to create plan: $e')),
            );
          }
        },
      ),
    );
  }

  void _editSubscription(SchoolSubscription subscription) {
    showDialog(
      context: context,
      builder: (context) => EditSubscriptionDialog(
        subscription: subscription,
        onSave: (updatedSubscription) {
          setState(() {
            // Use SchoolSubscription properties, not Map keys
            final index = _subscriptions.indexWhere((s) => s.id == subscription.id);
            if (index != -1) {
              _subscriptions[index] = updatedSubscription;
            }
          });
        },
      ),
    );
  }

  void _deleteSubscription(SchoolSubscription subscription) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Subscription'),
        content: Text('Alert you sure want to delete subscription for ${subscription.schoolName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              try {
                if (subscription.id != null) {
                  await _apiService.deleteSubscription(subscription.id!);

                  setState(() {
                    _subscriptions.removeWhere((s) => s.id == subscription.id);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Subscription for ${subscription.schoolName} deleted'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  throw Exception ('Subscription ID is null');
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _editPlan(SubscriptionPlan plan) {
    showDialog(
      context: context,
      builder: (context) => EditPlanDialog(
        plan: plan,
        onSave: (updatedPlan) async {
          try {
            if (plan.id != null) {
              await _apiService.updatePlan(plan.id!, updatedPlan);
              setState(() {
                final index = _availablePlans.indexWhere((p) => p.id == plan.id);
                if (index != -1) {
                  _availablePlans[index] = updatedPlan;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Plan updated successfully')),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update plan: $e')),
            );
          }
        },
      ),
    );
  }

  void _deletePlan(SubscriptionPlan plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Plan'),
        content: Text('Are you sure you want to delete ${plan.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                if (plan.id != null) {
                  await _apiService.deletePlan(plan.id!);
                  setState(() {
                    _availablePlans.removeWhere((p) => p.id == plan.id);
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Plan ${plan.name} deleted'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete plan: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _viewInvoice(SchoolSubscription subscription) {
    // Navigate to invoice details
  }

  void _assignPlan(SubscriptionPlan plan) {
    showDialog(
      context: context,
      builder: (context) => AssignPlanDialog(plan: plan),
    );
  }

  void _viewInvoiceDetails(Map<String, dynamic> invoice) {
    showDialog(
      context: context,
      builder: (context) => InvoiceDetailsDialog(invoice: invoice),
    );
  }

  void _downloadInvoice(Map<String, dynamic> invoice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading invoice ${invoice['id']}...')),
    );
  }

  void _sendReminder(Map<String, dynamic> invoice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reminder sent for ${invoice['id']}')),
    );
  }

  void _generateReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generating report...')),
    );
  }
}

class CreatePlanDialog extends StatefulWidget {
  final Function(SubscriptionPlan) onPlanCreated; // Expects SubscriptionPlan

  const CreatePlanDialog({super.key, required this.onPlanCreated});

  @override
  State<CreatePlanDialog> createState() => _CreatePlanDialogState();
}

class _CreatePlanDialogState extends State<CreatePlanDialog> {
  final _formKey = GlobalKey<FormState>();
  final _planCodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _maxStudentsController = TextEditingController();
  final _maxBusesController = TextEditingController();
  final _featureKeyController = TextEditingController();
  final _featureValueController = TextEditingController();
  final _limitationKeyController = TextEditingController();
  final _limitationValueController = TextEditingController();

  String _billingCycle = 'monthly';
  final Map<String, dynamic> _features = {};
  final Map<String, dynamic> _limitations = {};

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Billing Plan'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _planCodeController,
                decoration: const InputDecoration(
                  labelText: 'Plan Code (e.g., BASIC001)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter plan code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Plan Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter plan name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                        prefixText: '\$',
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter valid price';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _billingCycle,
                      decoration: const InputDecoration(
                        labelText: 'Billing Cycle',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem<String>(
                          value: 'monthly',
                          child: Text('Monthly'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'quarterly',
                          child: Text('Quarterly'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'annual',
                          child: Text('Annual'),
                        ),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _billingCycle = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _maxStudentsController,
                      decoration: const InputDecoration(
                        labelText: 'Max Students (optional)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _maxBusesController,
                      decoration: const InputDecoration(
                        labelText: 'Max Buses (optional)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Features
              const Text(
                'Features',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              if (_features.isNotEmpty)
                ..._features.entries.map((entry) => ListTile(
                  title: Text('${entry.key}: ${entry.value}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, size: 16),
                    onPressed: () {
                      setState(() {
                        _features.remove(entry.key);
                      });
                    },
                  ),
                )),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _featureKeyController,
                      decoration: const InputDecoration(
                        hintText: 'Feature key...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _featureValueController,
                      decoration: const InputDecoration(
                        hintText: 'Feature value...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_featureKeyController.text.isNotEmpty &&
                          _featureValueController.text.isNotEmpty) {
                        setState(() {
                          _features[_featureKeyController.text] =
                              _featureValueController.text;
                          _featureKeyController.clear();
                          _featureValueController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Limitations
              const Text(
                'Limitations',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              if (_limitations.isNotEmpty)
                ..._limitations.entries.map((entry) => ListTile(
                  title: Text('${entry.key}: ${entry.value}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, size: 16),
                    onPressed: () {
                      setState(() {
                        _limitations.remove(entry.key);
                      });
                    },
                  ),
                )),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _limitationKeyController,
                      decoration: const InputDecoration(
                        hintText: 'Limitation key...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _limitationValueController,
                      decoration: const InputDecoration(
                        hintText: 'Limitation value...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_limitationKeyController.text.isNotEmpty &&
                          _limitationValueController.text.isNotEmpty) {
                        setState(() {
                          _limitations[_limitationKeyController.text] =
                              _limitationValueController.text;
                          _limitationKeyController.clear();
                          _limitationValueController.clear();
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // FIXED: Creating SubscriptionPlan object, not Map
              final newPlan = SubscriptionPlan(
                planCode: _planCodeController.text,
                name: _nameController.text,
                description: _descriptionController.text,
                price: double.parse(_priceController.text),
                billingCycle: _billingCycle,
                maxStudents: _maxStudentsController.text.isNotEmpty
                    ? int.parse(_maxStudentsController.text)
                    : null,
                maxBuses: _maxBusesController.text.isNotEmpty
                    ? int.parse(_maxBusesController.text)
                    : null,
                features: _features.isNotEmpty ? _features : null,
                limitations: _limitations.isNotEmpty ? _limitations : null,
                isActive: true,
                createdAt: DateTime.now(),
              );
              widget.onPlanCreated(newPlan); // Pass SubscriptionPlan
            }
          },
          child: const Text('Create Plan'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _planCodeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _maxStudentsController.dispose();
    _maxBusesController.dispose();
    _featureKeyController.dispose();
    _featureValueController.dispose();
    _limitationKeyController.dispose();
    _limitationValueController.dispose();
    super.dispose();
  }
}

class CreateSubscriptionDialog extends StatefulWidget {
  final ApiService apiService;
  final Function(SchoolSubscription) onSubscriptionCreated;

  const CreateSubscriptionDialog({
    super.key,
    required this.apiService,
    required this.onSubscriptionCreated,
  });

  @override
  State<CreateSubscriptionDialog> createState() =>
      _CreateSubscriptionDialogState();
}

class _CreateSubscriptionDialogState extends State<CreateSubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();

  // School snapshot fields
  final TextEditingController _schoolNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _studentsController = TextEditingController();
  final TextEditingController _busesController = TextEditingController();

  // Dates
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  SubscriptionPlan? _selectedPlan;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));

  String _status = 'active';
  bool _autoRenew = true;
  bool _isLoading = false;

  List<SubscriptionPlan> _availablePlans = [];

  @override
  void initState() {
    super.initState();
    _loadPlans();
    _startDateController.text = _formatDate(_startDate);
    _endDateController.text = _formatDate(_endDate);
  }

  Future<void> _loadPlans() async {
    setState(() => _isLoading = true);
    try {
      _availablePlans = await widget.apiService.getAllPlans();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String _generateSchoolCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = chars.split('')..shuffle();
    return 'SCH-${rand.take(8).join()}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Subscription'),
      content: SingleChildScrollView(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildText(
                controller: _schoolNameController,
                label: 'School Name *',
                icon: Icons.school,
                required: true,
              ),
              const SizedBox(height: 16),

              _buildPlanDropdown(),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: _buildText(controller: _emailController, label: 'Email', icon: Icons.email)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildText(controller: _phoneController, label: 'Phone', icon: Icons.phone)),
                ],
              ),
              const SizedBox(height: 16),

              _buildText(
                controller: _addressController,
                label: 'Address',
                icon: Icons.location_on,
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: _buildNumber(_studentsController, 'Students *', Icons.people)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildNumber(_busesController, 'Buses *', Icons.directions_bus)),
                ],
              ),
              const SizedBox(height: 16),

              _buildDateRow(),
              const SizedBox(height: 16),

              _buildStatusRow(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: _createSubscription, child: const Text('Create')),
      ],
    );
  }

  // ---------------- HELPERS ----------------

  Widget _buildText({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool required = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: required
          ? (v) => v == null || v.isEmpty ? '$label is required' : null
          : null,
    );
  }

  Widget _buildNumber(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: (v) => v == null || int.tryParse(v) == null ? 'Enter a valid number' : null,
    );
  }

  Widget _buildPlanDropdown() {
    return DropdownButtonFormField<SubscriptionPlan>(
      decoration: const InputDecoration(
        labelText: 'Select Plan *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.next_plan),
      ),
      value: _selectedPlan,
      items: _availablePlans
          .map((p) => DropdownMenuItem(
        value: p,
        child: Text('${p.name} - \$${p.price}/${p.billingCycle}'),
      ))
          .toList(),
      onChanged: (p) => setState(() => _selectedPlan = p),
      validator: (v) => v == null ? 'Please select a plan' : null,
    );
  }

  Widget _buildDateRow() {
    return Row(
      children: [
        Expanded(child: _buildDateField(_startDateController, true)),
        const SizedBox(width: 16),
        Expanded(child: _buildDateField(_endDateController, false)),
      ],
    );
  }

  Widget _buildDateField(TextEditingController controller, bool isStart) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: isStart ? _startDate : _endDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
        );
        if (picked != null) {
          setState(() {
            if (isStart) {
              _startDate = picked;
              _startDateController.text = _formatDate(picked);
            } else {
              _endDate = picked;
              _endDateController.text = _formatDate(picked);
            }
          });
        }
      },
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _status,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'active', child: Text('Active')),
              DropdownMenuItem(value: 'pending', child: Text('Pending')),
              DropdownMenuItem(value: 'trial', child: Text('Trial')),
            ],
            onChanged: (v) => setState(() => _status = v ?? 'active'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SwitchListTile(
            title: const Text('Auto Renew'),
            value: _autoRenew,
            onChanged: (v) => setState(() => _autoRenew = v),
          ),
        ),
      ],
    );
  }

  // ---------------- SAVE ----------------

  void _createSubscription() async {
    if (!_formKey.currentState!.validate() || _selectedPlan == null) return;

    final payload = {
      'subscription_code': 'SUB-${DateTime.now().millisecondsSinceEpoch}',
      'school_code': _generateSchoolCode(),
      'school_email': _emailController.text.trim(),
      'school_phone': _phoneController.text.trim(),
      'school_address': _addressController.text.trim(),
      'total_students': int.parse(_studentsController.text),
      'total_buses': int.parse(_busesController.text),
      'plan_id': _selectedPlan!.id,
      'amount': _selectedPlan!.price,
      'status': _status,
      'start_date': _startDateController.text,
      'end_date': _endDateController.text,
      'auto_renew': _autoRenew ? 1 : 0,
      'payment_method': 'manual',
      'transaction_id': 'TXN-${DateTime.now().millisecondsSinceEpoch}',
    };

    final subscription =
    await widget.apiService.createSubscription(payload);

    widget.onSubscriptionCreated(subscription);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    for (final c in [
      _schoolNameController,
      _emailController,
      _phoneController,
      _addressController,
      _studentsController,
      _busesController,
      _startDateController,
      _endDateController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }
}


class EditSubscriptionDialog extends StatefulWidget {
  final SchoolSubscription subscription;
  final Function(SchoolSubscription) onSave;

  const EditSubscriptionDialog({
    super.key,
    required this.subscription,
    required this.onSave,
  });

  @override
  State<EditSubscriptionDialog> createState() =>
      _EditSubscriptionDialogState();
}

class _EditSubscriptionDialogState extends State<EditSubscriptionDialog> {
  late TextEditingController _priceController;
  late String _selectedStatus;
  late DateTime _renewalDate;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: widget.subscription.amount.toStringAsFixed(2),
    );
    _selectedStatus = widget.subscription.status;
    _renewalDate = widget.subscription.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Subscription'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('School'),
              subtitle:
              Text(widget.subscription.schoolCode ?? 'Unknown School'),
            ),
            ListTile(
              title: const Text('Plan'),
              subtitle:
              Text(widget.subscription.plan?.name ?? 'Unknown Plan'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'active', child: Text('ACTIVE')),
                DropdownMenuItem(value: 'pending', child: Text('PENDING')),
                DropdownMenuItem(value: 'trial', child: Text('TRIAL')),
                DropdownMenuItem(value: 'expiring', child: Text('EXPIRING')),
                DropdownMenuItem(value: 'cancelled', child: Text('CANCELLED')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedStatus = value);
                }
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Renewal Date'),
              subtitle: Text(
                '${_renewalDate.year}-'
                    '${_renewalDate.month.toString().padLeft(2, '0')}-'
                    '${_renewalDate.day.toString().padLeft(2, '0')}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _renewalDate,
                    firstDate: DateTime.now(),
                    lastDate:
                    DateTime.now().add(const Duration(days: 365 * 2)),
                  );
                  if (date != null) {
                    setState(() => _renewalDate = date);
                  }
                },
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
            final updatedSubscription =
            widget.subscription.copyWith(
              amount: double.tryParse(_priceController.text) ??
                  widget.subscription.amount,
              status: _selectedStatus,
              endDate: _renewalDate,
            );

            widget.onSave(updatedSubscription);
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Subscription updated')),
            );
          },
          child: const Text('Save Changes'),
        ),
      ],
    );
  }
}


class EditPlanDialog extends StatefulWidget {
  final SubscriptionPlan plan;
  final Function(SubscriptionPlan) onSave;

  const EditPlanDialog({
    super.key,
    required this.plan,
    required this.onSave,
  });

  @override
  State<EditPlanDialog> createState() => _EditPlanDialogState();
}

class _EditPlanDialogState extends State<EditPlanDialog> {
  late TextEditingController _planCodeController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _maxStudentsController;
  late TextEditingController _maxBusesController;
  late TextEditingController _featureKeyController;
  late TextEditingController _featureValueController;
  late TextEditingController _limitationKeyController;
  late TextEditingController _limitationValueController;

  late String _billingCycle;
  late Map<String, dynamic> _features;
  late Map<String, dynamic> _limitations;

  @override
  void initState() {
    super.initState();
    _planCodeController = TextEditingController(text: widget.plan.planCode);
    _nameController = TextEditingController(text: widget.plan.name);
    _descriptionController = TextEditingController(text: widget.plan.description);
    _priceController = TextEditingController(text: widget.plan.price.toStringAsFixed(2));
    _maxStudentsController = TextEditingController(
        text: widget.plan.maxStudents?.toString() ?? '');
    _maxBusesController = TextEditingController(
        text: widget.plan.maxBuses?.toString() ?? '');
    _billingCycle = widget.plan.billingCycle;
    _features = Map<String, dynamic>.from(widget.plan.features ?? {});
    _limitations = Map<String, dynamic>.from(widget.plan.limitations ?? {});

    _featureKeyController = TextEditingController();
    _featureValueController = TextEditingController();
    _limitationKeyController = TextEditingController();
    _limitationValueController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Billing Plan'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _planCodeController,
              decoration: const InputDecoration(
                labelText: 'Plan Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Plan Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder(),
                      prefixText: '\$',
                    ),
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _billingCycle,
                    decoration: const InputDecoration(
                      labelText: 'Billing Cycle',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'monthly',
                        child: Text('Monthly'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'quarterly',
                        child: Text('Quarterly'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'annual',
                        child: Text('Annual'),
                      ),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        _billingCycle = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _maxStudentsController,
                    decoration: const InputDecoration(
                      labelText: 'Max Students',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _maxBusesController,
                    decoration: const InputDecoration(
                      labelText: 'Max Buses',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Features
            const Text(
              'Features',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (_features.isNotEmpty)
              ..._features.entries.map((entry) => ListTile(
                title: Text('${entry.key}: ${entry.value}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, size: 16),
                  onPressed: () {
                    setState(() {
                      _features.remove(entry.key);
                    });
                  },
                ),
              )),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _featureKeyController,
                    decoration: const InputDecoration(
                      hintText: 'Add feature key...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _featureValueController,
                    decoration: const InputDecoration(
                      hintText: 'Add feature value...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_featureKeyController.text.isNotEmpty &&
                        _featureValueController.text.isNotEmpty) {
                      setState(() {
                        _features[_featureKeyController.text] =
                            _featureValueController.text;
                        _featureKeyController.clear();
                        _featureValueController.clear();
                      });
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Limitations
            const Text(
              'Limitations',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (_limitations.isNotEmpty)
              ..._limitations.entries.map((entry) => ListTile(
                title: Text('${entry.key}: ${entry.value}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, size: 16),
                  onPressed: () {
                    setState(() {
                      _limitations.remove(entry.key);
                    });
                  },
                ),
              )),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _limitationKeyController,
                    decoration: const InputDecoration(
                      hintText: 'Add limitation key...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _limitationValueController,
                    decoration: const InputDecoration(
                      hintText: 'Add limitation value...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_limitationKeyController.text.isNotEmpty &&
                        _limitationValueController.text.isNotEmpty) {
                      setState(() {
                        _limitations[_limitationKeyController.text] =
                            _limitationValueController.text;
                        _limitationKeyController.clear();
                        _limitationValueController.clear();
                      });
                    }
                  },
                ),
              ],
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
            // FIXED: Using copyWith() instead of creating a Map
            final updatedPlan = widget.plan.copyWith(
              planCode: _planCodeController.text,
              name: _nameController.text,
              description: _descriptionController.text,
              price: double.tryParse(_priceController.text) ?? widget.plan.price,
              billingCycle: _billingCycle,
              maxStudents: _maxStudentsController.text.isNotEmpty
                  ? int.tryParse(_maxStudentsController.text)
                  : null,
              maxBuses: _maxBusesController.text.isNotEmpty
                  ? int.tryParse(_maxBusesController.text)
                  : null,
              features: _features.isNotEmpty ? _features : null,
              limitations: _limitations.isNotEmpty ? _limitations : null,
            );
            widget.onSave(updatedPlan);
          },
          child: const Text('Save Changes'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _planCodeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _maxStudentsController.dispose();
    _maxBusesController.dispose();
    _featureKeyController.dispose();
    _featureValueController.dispose();
    _limitationKeyController.dispose();
    _limitationValueController.dispose();
    super.dispose();
  }
}

class AssignPlanDialog extends StatefulWidget {
  final SubscriptionPlan plan;

  const AssignPlanDialog({super.key, required this.plan});

  @override
  State<AssignPlanDialog> createState() => _AssignPlanDialogState();
}

class _AssignPlanDialogState extends State<AssignPlanDialog> {
  final List<String> _selectedSchools = [];
  final List<Map<String, dynamic>> _availableSchools = [
    {'id': 'SCH005', 'name': 'Sunrise Elementary', 'location': 'New York', 'students': 350},
    {'id': 'SCH006', 'name': 'Oakridge Middle School', 'location': 'Los Angeles', 'students': 420},
    {'id': 'SCH007', 'name': 'Westview High', 'location': 'Chicago', 'students': 800},
    {'id': 'SCH008', 'name': 'Central Academy', 'location': 'Houston', 'students': 600},
    {'id': 'SCH009', 'name': 'Northside School', 'location': 'Phoenix', 'students': 300},
    {'id': 'SCH010', 'name': 'Springfield Elementary', 'location': 'Philadelphia', 'students': 250},
    {'id': 'SCH011', 'name': 'Lincoln High', 'location': 'San Antonio', 'students': 900},
    {'id': 'SCH012', 'name': 'Jefferson Academy', 'location': 'San Diego', 'students': 550},
  ];

  final TextEditingController _customPriceController = TextEditingController();
  String _billingCycle = 'Monthly';
  bool _useCustomPrice = false;

  @override
  void initState() {
    super.initState();
    _customPriceController.text = (widget.plan.price).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Assign ${widget.plan.name} Plan'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.plan.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.plan.description,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Standard Price:',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          '\$${(widget.plan.price).toStringAsFixed(2)}/${widget.plan.billingCycle}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Custom price option
            Row(
              children: [
                Checkbox(
                  value: _useCustomPrice,
                  onChanged: (value) {
                    setState(() {
                      _useCustomPrice = value!;
                    });
                  },
                ),
                const Text('Use custom price for all selected schools'),
              ],
            ),
            if (_useCustomPrice) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _customPriceController,
                decoration: const InputDecoration(
                  labelText: 'Custom Price per School',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _billingCycle,
              decoration: const InputDecoration(
                labelText: 'Billing Cycle',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem<String>(
                  value: 'Monthly',
                  child: Text('Monthly'),
                ),
                DropdownMenuItem<String>(
                  value: 'Quarterly',
                  child: Text('Quarterly'),
                ),
                DropdownMenuItem<String>(
                  value: 'Annual',
                  child: Text('Annual'),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  _billingCycle = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // School selection
            const Text(
              'Select Schools:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search schools...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: _availableSchools.length,
                itemBuilder: (context, index) {
                  final school = _availableSchools[index];
                  final isSelected = _selectedSchools.contains(school['id'] as String);

                  return CheckboxListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          school['name'] as String,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${school['location']} • ${school['students']} students',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        if (value == true) {
                          _selectedSchools.add(school['id'] as String);
                        } else {
                          _selectedSchools.remove(school['id'] as String);
                        }
                      });
                    },
                    secondary: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      child: Text(
                        school['name'].toString().substring(0, 1),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selected: ${_selectedSchools.length} schools',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
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
          onPressed: _selectedSchools.isEmpty ? null : () {
            _assignPlanToSchools();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Plan assigned to ${_selectedSchools.length} schools'),
                backgroundColor: Colors.green,
              ),
            );
          },
          child: const Text('Assign Plan'),
        ),
      ],
    );
  }

  void _assignPlanToSchools() {
    final price = _useCustomPrice
        ? double.tryParse(_customPriceController.text) ?? widget.plan.price
        : widget.plan.price;

    // Here you would implement the actual assignment logic
    // For now, we'll just print the details
    print('Assigning plan to schools: $_selectedSchools');
    print('Price: \$$price per $_billingCycle');
    print('Plan: ${widget.plan.name}');
  }

  @override
  void dispose() {
    _customPriceController.dispose();
    super.dispose();
  }
}

class InvoiceDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> invoice;

  const InvoiceDetailsDialog({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final items = invoice['items'] as List<dynamic>;
    final total = invoice['amount'] as double;
    final date = invoice['date'] as String;
    final status = invoice['status'] as String;
    final schoolName = invoice['schoolName'] as String;

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.receipt, color: Colors.blue),
          const SizedBox(width: 8),
          Text('Invoice ${invoice['id']}'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invoice header
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          schoolName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Date: $date',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Invoice items
            const Text(
              'Invoice Items',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Description',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Qty',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Price',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Amount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Items
                  ...items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value as Map<String, dynamic>;
                    final quantity = item['quantity'] as int;
                    final price = item['price'] as double;
                    final amount = quantity * price;

                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey[300]!,
                            width: index == 0 ? 0 : 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              item['name'] as String,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              quantity.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '\$${price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '\$${amount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Total section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal:',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tax (0%):',
                        style: TextStyle(fontSize: 14),
                      ),
                      const Text(
                        '\$0.00',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payment information
            const Text(
              'Payment Information',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.credit_card, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      const Text(
                        'Payment Method:',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Spacer(),
                      Text(
                        status == 'paid' ? 'Paid via Stripe' : 'Pending',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      const Text(
                        'Due Date:',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const Spacer(),
                      Text(
                        _calculateDueDate(date),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            if (status != 'paid') ...[
              OutlinedButton.icon(
                onPressed: () {
                  _sendPaymentReminder(context);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.email, size: 16),
                label: const Text('Send Reminder'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  _markAsPaid(context);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Mark as Paid'),
              ),
            ],
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () => _downloadInvoice(context),
              icon: const Icon(Icons.download, size: 16),
              label: const Text('Download'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.teal;
      case 'overdue':
        return Colors.pinkAccent;
      case 'pending':
        return Colors.orange.shade200;
      default:
        return Colors.grey;
    }
  }

  String _calculateDueDate(String invoiceDate) {
    final date = DateTime.parse(invoiceDate);
    final dueDate = date.add(const Duration(days: 30));
    return '${dueDate.day}/${dueDate.month}/${dueDate.year}';
  }

  void _sendPaymentReminder(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment reminder sent for invoice ${invoice['id']}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _markAsPaid(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invoice ${invoice['id']} marked as paid'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _downloadInvoice(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading invoice ${invoice['id']}...'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
