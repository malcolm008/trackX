import 'package:flutter/material.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  final List<Map<String, dynamic>> _subscriptions = [
    {
      'id': 'SUB-001',
      'school': 'Greenwood High',
      'plan': 'Premium',
      'amount': '\$499',
      'period': 'Monthly',
      'status': 'active',
      'startDate': '2024-01-01',
      'endDate': '2024-01-31',
      'autoRenew': true,
      'students': 500,
      'buses': 10,
    },
    {
      'id': 'SUB-002',
      'school': 'Sunrise Academy',
      'plan': 'Basic',
      'amount': '\$199',
      'period': 'Monthly',
      'status': 'active',
      'startDate': '2024-01-05',
      'endDate': '2024-02-05',
      'autoRenew': true,
      'students': 200,
      'buses': 5,
    },
    {
      'id': 'SUB-003',
      'school': 'Central School',
      'plan': 'Premium',
      'amount': '\$499',
      'period': 'Monthly',
      'status': 'expiring',
      'startDate': '2023-12-01',
      'endDate': '2024-01-31',
      'autoRenew': false,
      'students': 450,
      'buses': 8,
    },
    {
      'id': 'SUB-004',
      'school': 'Northwood School',
      'plan': 'Enterprise',
      'amount': '\$999',
      'period': 'Monthly',
      'status': 'active',
      'startDate': '2024-01-15',
      'endDate': '2024-02-15',
      'autoRenew': true,
      'students': 1000,
      'buses': 25,
    },
    {
      'id': 'SUB-005',
      'school': 'Valley Prep',
      'plan': 'Basic',
      'amount': '\$199',
      'period': 'Monthly',
      'status': 'trial',
      'startDate': '2024-01-20',
      'endDate': '2024-02-20',
      'autoRenew': false,
      'students': 150,
      'buses': 4,
    },
  ];

  String _selectedFilter = 'all';
  final List<String> _filters = ['all', 'active', 'expiring', 'trial', 'cancelled'];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    return SingleChildScrollView(
      child: Column(
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
                    'Subscriptions',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manage school subscriptions and billing',
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
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Export'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('Add Subscription'),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats Cards - Responsive
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop
                  ? 4
                  : isTablet
                  ? 2
                  : 2,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
              childAspectRatio: isDesktop ? 1.5 : 1,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final stats = [
                ['Total Revenue', '\$12,450', Icons.attach_money, Colors.teal, '+12% last month'],
                ['Active Subscriptions', '42', Icons.subscriptions, Colors.deepPurpleAccent.shade100, '+3 this month'],
                ['Trial Users', '8', Icons.timer, Colors.orange.shade200, '2 expiring soon'],
                ['Renewal Rate', '94%', Icons.autorenew, Colors.purpleAccent, '+2% last month'],
              ];
              return _buildSubscriptionStat(
                stats[index][0] as String,
                stats[index][1] as String,
                stats[index][2] as IconData,
                stats[index][3] as Color,
                stats[index][4] as String,
              );
            },
          ),
          const SizedBox(height: 24),

          // Filters and Search - Responsive
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (isDesktop)
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search subscriptions...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        DropdownButton<String>(
                          value: _selectedFilter,
                          items: _filters.map((filter) {
                            return DropdownMenuItem(
                              value: filter,
                              child: Text(filter.capitalize()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedFilter = value!;
                            });
                          },
                        ),
                        const SizedBox(width: 16),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.filter_list),
                          label: const Text('Filters'),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Search subscriptions...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedFilter,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                ),
                                items: _filters.map((filter) {
                                  return DropdownMenuItem(
                                    value: filter,
                                    child: Text(filter.capitalize()),
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
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.filter_list),
                              label: const Text('Filters'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  if (!isDesktop) ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('Add Subscription'),
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

          // Subscriptions Table/List - Responsive
          isDesktop
              ? _buildDesktopTable()
              : _buildMobileList(),
        ],
      ),
    );
  }

  Widget _buildSubscriptionStat(
      String title,
      String value,
      IconData icon,
      Color color,
      String subtitle,
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
                if (subtitle.isNotEmpty)
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
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 48, // Adjust for padding
            child: DataTable(
              dataRowHeight: 70,
              columnSpacing: 20,
              columns: const [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('School')),
                DataColumn(label: Text('Plan')),
                DataColumn(label: Text('Amount')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Students')),
                DataColumn(label: Text('Buses')),
                DataColumn(label: Text('Auto Renew')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _subscriptions.map((subscription) {
                return DataRow(
                  cells: [
                    DataCell(Text(subscription['id'])),
                    DataCell(
                      SizedBox(
                        width: 200,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.withOpacity(0.1),
                            child: const Icon(Icons.school, size: 16),
                          ),
                          title: Text(
                            subscription['school'],
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text('Expires: ${subscription['endDate']}'),
                        ),
                      ),
                    ),
                    DataCell(
                      Chip(
                        label: Text(subscription['plan']),
                        backgroundColor:
                        _getPlanColor(subscription['plan']).withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: _getPlanColor(subscription['plan']),
                        ),
                      ),
                    ),
                    DataCell(Text(subscription['amount'])),
                    DataCell(
                      Chip(
                        label: Text(subscription['status'].toString().capitalize()),
                        backgroundColor:
                        _getStatusColor(subscription['status']).withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: _getStatusColor(subscription['status']),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    DataCell(Text(subscription['students'].toString())),
                    DataCell(Text(subscription['buses'].toString())),
                    DataCell(
                      Switch(
                        value: subscription['autoRenew'],
                        onChanged: (value) {},
                      ),
                    ),
                    DataCell(
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'view',
                            child: ListTile(
                              leading: Icon(Icons.remove_red_eye),
                              title: Text('View Details'),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text('Edit'),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'renew',
                            child: ListTile(
                              leading: Icon(Icons.autorenew),
                              title: Text('Renew'),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'cancel',
                            child: ListTile(
                              leading: Icon(Icons.cancel),
                              title: Text('Cancel'),
                            ),
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
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _subscriptions.length,
      itemBuilder: (context, index) {
        final subscription = _subscriptions[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      subscription['id'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Chip(
                      label: Text(subscription['status'].toString().capitalize()),
                      backgroundColor:
                      _getStatusColor(subscription['status']).withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: _getStatusColor(subscription['status']),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: const Icon(Icons.school, size: 20),
                  ),
                  title: Text(subscription['school']),
                  subtitle: Text('Plan: ${subscription['plan']} • ${subscription['amount']}'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildMobileStat('Students', subscription['students'].toString()),
                    const SizedBox(width: 16),
                    _buildMobileStat('Buses', subscription['buses'].toString()),
                    const Spacer(),
                    Column(
                      children: [
                        Text(
                          'Auto Renew',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        Switch(
                          value: subscription['autoRenew'],
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_red_eye, size: 16),
                        label: const Text('View'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                      ),
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

  Widget _buildMobileStat(String label, String value) {
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.teal;
      case 'expiring':
        return Color(0xFFFFAB91);;
      case 'trial':
        return Colors.deepPurpleAccent.shade100;
      case 'cancelled':
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }

  Color _getPlanColor(String plan) {
    switch (plan) {
      case 'Premium':
        return Colors.purple;
      case 'Enterprise':
        return Colors.deepPurpleAccent.shade100;
      case 'Basic':
        return Colors.tealAccent;
      default:
        return Colors.orange;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}