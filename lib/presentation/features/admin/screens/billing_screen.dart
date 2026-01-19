import 'package:flutter/material.dart';

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
  final List<Map<String, dynamic>> _subscriptions = [
    {
      'id': '1',
      'schoolId': 'SCH001',
      'schoolName': 'Greenwood High',
      'plan': 'Enterprise',
      'students': 500,
      'price': 499.99,
      'billingCycle': 'Monthly',
      'status': 'active',
      'startDate': '2024-01-01',
      'renewalDate': '2024-02-01',
      'features': {
        'Live Tracking': true,
        'GPS Accuracy': 'High',
        'Notifications': 'Unlimited',
        'Data Retention': '1 Year',
        'Support': '24/7 Priority',
      },
    },
    {
      'id': '2',
      'schoolId': 'SCH002',
      'schoolName': 'Maplewood Academy',
      'plan': 'Pro',
      'students': 250,
      'price': 299.99,
      'billingCycle': 'Quarterly',
      'status': 'active',
      'startDate': '2023-12-01',
      'renewalDate': '2024-03-01',
      'features': {
        'Live Tracking': true,
        'GPS Accuracy': 'Medium',
        'Notifications': '1000/month',
        'Data Retention': '6 Months',
        'Support': 'Business Hours',
      },
    },
    {
      'id': '3',
      'schoolId': 'SCH003',
      'schoolName': 'Riverside School',
      'plan': 'Basic',
      'students': 100,
      'price': 149.99,
      'billingCycle': 'Monthly',
      'status': 'pending',
      'startDate': '2024-01-15',
      'renewalDate': '2024-02-15',
      'features': {
        'Live Tracking': true,
        'GPS Accuracy': 'Basic',
        'Notifications': '500/month',
        'Data Retention': '3 Months',
        'Support': 'Email Only',
      },
    },
    {
      'id': '4',
      'schoolId': 'SCH004',
      'schoolName': 'Sunrise Elementary',
      'plan': 'Enterprise',
      'students': 400,
      'price': 449.99,
      'billingCycle': 'Annual',
      'status': 'cancelled',
      'startDate': '2023-01-01',
      'renewalDate': '2024-01-01',
      'features': {
        'Live Tracking': true,
        'GPS Accuracy': 'High',
        'Notifications': 'Unlimited',
        'Data Retention': '2 Years',
        'Support': '24/7 Priority',
      },
    },
  ];

  final List<Map<String, dynamic>> _availablePlans = [
    {
      'name': 'Basic',
      'description': 'Essential tracking for small schools',
      'price': 149.99,
      'billingCycle': 'Monthly',
      'features': [
        'Up to 100 students',
        'Live GPS tracking',
        '500 notifications/month',
        '3 months data retention',
        'Email support',
        'Basic reports',
      ],
      'limitations': [
        'No API access',
        'Limited customization',
        'Standard GPS accuracy',
      ],
    },
    {
      'name': 'Pro',
      'description': 'Advanced features for growing institutions',
      'price': 299.99,
      'billingCycle': 'Monthly',
      'features': [
        'Up to 250 students',
        'High-accuracy GPS',
        '1000 notifications/month',
        '6 months data retention',
        'Priority support',
        'Advanced analytics',
        'Custom branding',
        'API access',
      ],
      'limitations': [
        'Limited to 5 admins',
        'No white-labeling',
      ],
    },
    {
      'name': 'Enterprise',
      'description': 'Complete solution for large districts',
      'price': 499.99,
      'billingCycle': 'Monthly',
      'features': [
        'Unlimited students',
        'Real-time GPS tracking',
        'Unlimited notifications',
        '1 year data retention',
        '24/7 dedicated support',
        'Advanced AI analytics',
        'White-label solution',
        'Full API access',
        'Custom integrations',
        'SLA guarantee',
        'Bulk operations',
        'Advanced security',
      ],
      'limitations': [],
    },
  ];

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
    final totalRevenue = _subscriptions
        .where((s) => s['status'] == 'active')
        .fold(0.0, (sum, s) => sum + (s['price'] as double));

    final activeSubscriptions = _subscriptions
        .where((s) => s['status'] == 'active')
        .length;

    final upcomingRenewals = _subscriptions
        .where((s) {
      final renewalDate = DateTime.parse(s['renewalDate'] as String);
      return renewalDate.difference(DateTime.now()).inDays <= 7;
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
              itemCount: _subscriptions.length,
              itemBuilder: (context, index) {
                final subscription = _subscriptions[index];
                return _buildSubscriptionCard(subscription, isDesktop, isTablet);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(
      Map<String, dynamic> subscription,
      bool isDesktop,
      bool isTablet,
      ) {
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
                        subscription['schoolName'] as String,
                        style: TextStyle(
                          fontSize: isDesktop ? 18 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'ID: ${subscription['schoolId']}',
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
                    color: _getStatusColor(subscription['status'] as String),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    (subscription['status'] as String).toUpperCase(),
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
                  _buildInfoItem('Plan', subscription['plan'] as String, isDesktop),
                  const SizedBox(width: 24),
                  _buildInfoItem('Price', '\$${(subscription['price'] as double).toStringAsFixed(2)}', isDesktop),
                  const SizedBox(width: 24),
                  _buildInfoItem('Cycle', subscription['billingCycle'] as String, isDesktop),
                  const SizedBox(width: 24),
                  _buildInfoItem('Students', subscription['students'].toString(), isDesktop),
                ],
              )
            else
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildInfoItem('Plan', subscription['plan'] as String, isDesktop),
                  _buildInfoItem('Price', '\$${(subscription['price'] as double).toStringAsFixed(2)}', isDesktop),
                  _buildInfoItem('Cycle', subscription['billingCycle'] as String, isDesktop),
                  _buildInfoItem('Students', subscription['students'].toString(), isDesktop),
                ],
              ),
            const SizedBox(height: 12),

            // Features
            if (subscription['features'] is Map && (subscription['features'] as Map).isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (subscription['features'] as Map<String, dynamic>).entries.map((entry) {
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
                        'Start: ${subscription['startDate']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Renewal: ${subscription['renewalDate']}',
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
    return Padding(
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
    );
  }

  Widget _buildPlanCard(Map<String, dynamic> plan, bool isDesktop) {
    final features = plan['features'] as List<dynamic>;
    final limitations = plan['limitations'] as List<dynamic>;

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
                  child: Text(
                    plan['name'] as String,
                    style: TextStyle(
                      fontSize: isDesktop ? 20 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _editPlan(plan),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              plan['description'] as String,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Text(
              '\$${(plan['price'] as double).toStringAsFixed(2)}/${(plan['billingCycle'] as String).toLowerCase()}',
              style: TextStyle(
                fontSize: isDesktop ? 24 : 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Features:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...features.map<Widget>((feature) => Padding(
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
                      ...limitations.map<Widget>((limitation) => Padding(
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
      builder: (context) => AlertDialog(
        title: const Text('Create New Subscription'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'School Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'School ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Plan',
                  border: OutlineInputBorder(),
                ),
                items: _availablePlans.map<DropdownMenuItem<String>>((plan) {
                  final planName = plan['name'] as String;
                  final planPrice = plan['price'] as double;
                  return DropdownMenuItem<String>(
                    value: planName,
                    child: Text('$planName - \$$planPrice'),
                  );
                }).toList(),
                onChanged: (String? value) {},
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Number of Students',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
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
              setState(() {
                _subscriptions.add({
                  'id': '${_subscriptions.length + 1}',
                  'schoolId': 'SCH00${_subscriptions.length + 1}',
                  'schoolName': 'New School ${_subscriptions.length + 1}',
                  'plan': 'Basic',
                  'students': 100,
                  'price': 149.99,
                  'billingCycle': 'Monthly',
                  'status': 'active',
                  'startDate': '2024-01-01',
                  'renewalDate': '2024-02-01',
                  'features': {},
                });
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Subscription created successfully')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showCreatePlanDialog() {
    showDialog(
      context: context,
      builder: (context) => CreatePlanDialog(
        onPlanCreated: (newPlan) {
          setState(() {
            _availablePlans.add(newPlan);
          });
        },
      ),
    );
  }

  void _editSubscription(Map<String, dynamic> subscription) {
    showDialog(
      context: context,
      builder: (context) => EditSubscriptionDialog(
        subscription: subscription,
        onSave: (updatedSubscription) {
          setState(() {
            final index = _subscriptions.indexWhere((s) => s['id'] == subscription['id']);
            if (index != -1) {
              _subscriptions[index] = updatedSubscription;
            }
          });
        },
      ),
    );
  }

  void _editPlan(Map<String, dynamic> plan) {
    showDialog(
      context: context,
      builder: (context) => EditPlanDialog(
        plan: plan,
        onSave: (updatedPlan) {
          setState(() {
            final index = _availablePlans.indexWhere((p) => p['name'] == plan['name']);
            if (index != -1) {
              _availablePlans[index] = updatedPlan;
            }
          });
        },
      ),
    );
  }


  void _deleteSubscription(Map<String, dynamic> subscription) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Subscription'),
        content: Text('Are you sure you want to delete subscription for ${subscription['schoolName']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _subscriptions.removeWhere((s) => s['id'] == subscription['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Subscription for ${subscription['schoolName']} deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _viewInvoice(Map<String, dynamic> subscription) {
    // Navigate to invoice details
  }

  void _assignPlan(Map<String, dynamic> plan) {
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

// Dialog classes (CreatePlanDialog, EditSubscriptionDialog, etc.) remain the same
// but need to be updated with proper type annotations

class CreatePlanDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onPlanCreated;

  const CreatePlanDialog({super.key, required this.onPlanCreated});

  @override
  State<CreatePlanDialog> createState() => _CreatePlanDialogState();
}

class _CreatePlanDialogState extends State<CreatePlanDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _featureController = TextEditingController();
  final _limitationController = TextEditingController();
  String _billingCycle = 'Monthly';
  final List<String> _features = [];
  final List<String> _limitations = [];

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
                      keyboardType: TextInputType.number,
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
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _features.map((feature) => Chip(
                  label: Text(feature),
                  onDeleted: () {
                    setState(() {
                      _features.remove(feature);
                    });
                  },
                )).toList(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _featureController,
                      decoration: const InputDecoration(
                        hintText: 'Add feature...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_featureController.text.isNotEmpty) {
                        setState(() {
                          _features.add(_featureController.text);
                          _featureController.clear();
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
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _limitations.map((limitation) => Chip(
                  label: Text(limitation),
                  onDeleted: () {
                    setState(() {
                      _limitations.remove(limitation);
                    });
                  },
                )).toList(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _limitationController,
                      decoration: const InputDecoration(
                        hintText: 'Add limitation...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_limitationController.text.isNotEmpty) {
                        setState(() {
                          _limitations.add(_limitationController.text);
                          _limitationController.clear();
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
              final newPlan = {
                'name': _nameController.text,
                'description': _descriptionController.text,
                'price': double.parse(_priceController.text),
                'billingCycle': _billingCycle,
                'features': List<String>.from(_features),
                'limitations': List<String>.from(_limitations),
              };
              widget.onPlanCreated(newPlan);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Plan created successfully')),
              );
            }
          },
          child: const Text('Create Plan'),
        ),
      ],
    );
  }
}

class EditSubscriptionDialog extends StatefulWidget {
  final Map<String, dynamic> subscription;
  final Function(Map<String, dynamic>) onSave;

  const EditSubscriptionDialog({
    super.key,
    required this.subscription,
    required this.onSave,
  });

  @override
  State<EditSubscriptionDialog> createState() => _EditSubscriptionDialogState();
}

class _EditSubscriptionDialogState extends State<EditSubscriptionDialog> {
  late TextEditingController _priceController;
  late String _selectedStatus;
  late String _renewalDate;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
      text: (widget.subscription['price'] as double).toStringAsFixed(2),
    );
    _selectedStatus = widget.subscription['status'] as String;
    _renewalDate = widget.subscription['renewalDate'] as String;
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
              subtitle: Text(widget.subscription['schoolName'] as String),
            ),
            ListTile(
              title: const Text('Plan'),
              subtitle: Text(widget.subscription['plan'] as String),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(),
                prefixText: '\$',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem<String>(
                  value: 'active',
                  child: Text('ACTIVE'),
                ),
                DropdownMenuItem<String>(
                  value: 'pending',
                  child: Text('PENDING'),
                ),
                DropdownMenuItem<String>(
                  value: 'cancelled',
                  child: Text('CANCELLED'),
                ),
                DropdownMenuItem<String>(
                  value: 'suspended',
                  child: Text('SUSPENDED'),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Renewal Date'),
              subtitle: Text(_renewalDate),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(_renewalDate),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  );
                  if (date != null) {
                    setState(() {
                      _renewalDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                    });
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
            final updatedSubscription = Map<String, dynamic>.from(widget.subscription);
            updatedSubscription['price'] = double.tryParse(_priceController.text) ?? widget.subscription['price'];
            updatedSubscription['status'] = _selectedStatus;
            updatedSubscription['renewalDate'] = _renewalDate;

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

// Dialog for editing plan
class EditPlanDialog extends StatefulWidget {
  final Map<String, dynamic> plan;
  final Function(Map<String, dynamic>) onSave;

  const EditPlanDialog({
    super.key,
    required this.plan,
    required this.onSave,
  });

  @override
  State<EditPlanDialog> createState() => _EditPlanDialogState();
}

class _EditPlanDialogState extends State<EditPlanDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late String _billingCycle;
  final List<String> _features = [];
  final List<String> _limitations = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plan['name'] as String);
    _descriptionController = TextEditingController(text: widget.plan['description'] as String);
    _priceController = TextEditingController(text: (widget.plan['price'] as double).toStringAsFixed(2));
    _billingCycle = widget.plan['billingCycle'] as String;

    // Initialize features and limitations
    if (widget.plan['features'] is List) {
      _features.addAll((widget.plan['features'] as List<dynamic>).map((e) => e.toString()));
    }
    if (widget.plan['limitations'] is List) {
      _limitations.addAll((widget.plan['limitations'] as List<dynamic>).map((e) => e.toString()));
    }
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
                    keyboardType: TextInputType.number,
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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _features.map((feature) => Chip(
                label: Text(feature),
                onDeleted: () {
                  setState(() {
                    _features.remove(feature);
                  });
                },
              )).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Add new feature...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _features.add(value);
                        });
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final controller = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Add Feature'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Enter feature...',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (controller.text.isNotEmpty) {
                                setState(() {
                                  _features.add(controller.text);
                                });
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    );
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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _limitations.map((limitation) => Chip(
                label: Text(limitation),
                onDeleted: () {
                  setState(() {
                    _limitations.remove(limitation);
                  });
                },
              )).toList(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Add new limitation...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _limitations.add(value);
                        });
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final controller = TextEditingController();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Add Limitation'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: 'Enter limitation...',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (controller.text.isNotEmpty) {
                                setState(() {
                                  _limitations.add(controller.text);
                                });
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    );
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
            final updatedPlan = Map<String, dynamic>.from(widget.plan);
            updatedPlan['name'] = _nameController.text;
            updatedPlan['description'] = _descriptionController.text;
            updatedPlan['price'] = double.tryParse(_priceController.text) ?? widget.plan['price'];
            updatedPlan['billingCycle'] = _billingCycle;
            updatedPlan['features'] = List<String>.from(_features);
            updatedPlan['limitations'] = List<String>.from(_limitations);

            widget.onSave(updatedPlan);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Plan updated successfully')),
            );
          },
          child: const Text('Save Changes'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}

// Dialog for assigning plan to schools
class AssignPlanDialog extends StatefulWidget {
  final Map<String, dynamic> plan;

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
    _customPriceController.text = (widget.plan['price'] as double).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Assign ${widget.plan['name']} Plan'),
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
                      widget.plan['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.plan['description'] as String,
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
                          '\$${(widget.plan['price'] as double).toStringAsFixed(2)}/${widget.plan['billingCycle']}',
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
        ? double.tryParse(_customPriceController.text) ?? widget.plan['price'] as double
        : widget.plan['price'] as double;

    // Here you would implement the actual assignment logic
    // For now, we'll just print the details
    print('Assigning plan to schools: $_selectedSchools');
    print('Price: \$$price per $_billingCycle');
    print('Plan: ${widget.plan['name']}');
  }

  @override
  void dispose() {
    _customPriceController.dispose();
    super.dispose();
  }
}

// Dialog for invoice details
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
// Other dialog classes (EditPlanDialog, AssignPlanDialog, InvoiceDetailsDialog)
// should be similarly updated with proper type annotations

