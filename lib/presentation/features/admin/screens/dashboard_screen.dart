import 'package:flutter/material.dart';
import '../admin_home.dart';
import '../admin_responsive_layout.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back, Admin',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Here\'s what\'s happening with your platform today',
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
                      label: const Text('Export Report'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text('Quick Add'),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats Grid - Responsive
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop
                  ? 4
                  : isTablet
                  ? 3
                  : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isDesktop ? 1.2 : 1,
            ),
            itemCount: _stats.length,
            itemBuilder: (context, index) {
              final stat = _stats[index];
              return _buildStatCard(
                context,
                stat['title']!,
                stat['value']!,
                stat['icon'] as IconData,
                stat['color'] as Color,
                stat['change'] as String?,
              );
            },
          ),
          const SizedBox(height: 24),

          // Charts and Recent Activity Row
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildRevenueChart(context),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: _buildRecentActivity(context),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildRevenueChart(context),
                const SizedBox(height: 24),
                _buildRecentActivity(context),
              ],
            ),
          const SizedBox(height: 24),

          // Recent Subscriptions and System Health
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildRecentSubscriptions(context),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _buildSystemHealth(context),
                ),
              ],
            )
          else
            Column(
              children: [
                _buildRecentSubscriptions(context),
                const SizedBox(height: 24),
                _buildSystemHealth(context),
              ],
            ),
        ],
      ),
    );
  }

  final List<Map<String, dynamic>> _stats = [
    {
      'title': 'Total Revenue',
      'value': '\$42,580',
      'icon': Icons.attach_money,
      'color': Colors.green,
      'change': '+12.5%',
    },
    {
      'title': 'Active Schools',
      'value': '42',
      'icon': Icons.school,
      'color': Colors.blue,
      'change': '+3',
    },
    {
      'title': 'Total Users',
      'value': '2,847',
      'icon': Icons.people,
      'color': Colors.purple,
      'change': '+125',
    },
    {
      'title': 'Active Subscriptions',
      'value': '38',
      'icon': Icons.subscriptions,
      'color': Colors.orange,
      'change': '+2',
    },
    {
      'title': 'Total Buses',
      'value': '156',
      'icon': Icons.directions_bus,
      'color': Colors.indigo,
      'change': '+8',
    },
    {
      'title': 'Live Routes',
      'value': '89',
      'icon': Icons.route,
      'color': Colors.teal,
      'change': '+12',
    },
    {
      'title': 'Support Tickets',
      'value': '14',
      'icon': Icons.support,
      'color': Colors.red,
      'change': '-3',
    },
    {
      'title': 'System Uptime',
      'value': '99.9%',
      'icon': Icons.cloud,
      'color': Colors.cyan,
      'change': '99.95%',
    },
  ];

  Widget _buildStatCard(
      BuildContext context,
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
                  child: Icon(icon, color: color, size: 24),
                ),
                if (change != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: change.contains('+') || change.contains('%')
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      change,
                      style: TextStyle(
                        color: change.contains('+') || change.contains('%')
                            ? Colors.green
                            : Colors.red,
                        fontSize: 12,
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
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Revenue Overview',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: 'This Month',
                  items: ['This Week', 'This Month', 'This Year']
                      .map((period) => DropdownMenuItem(
                    value: period,
                    child: Text(period),
                  ))
                      .toList(),
                  onChanged: (value) {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Mock chart (in real app, use charts_flutter or similar)
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Revenue Chart',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildActivityItem(
                  _activities[index]['title']!,
                  _activities[index]['time']!,
                  _activities[index]['type']!,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  final List<Map<String, String>> _activities = [
    {'title': 'Greenwood High renewed subscription', 'time': '10 min ago', 'type': 'subscription'},
    {'title': 'New school registered: Sunrise Academy', 'time': '25 min ago', 'type': 'school'},
    {'title': 'Payment received from Central School', 'time': '1 hour ago', 'type': 'payment'},
    {'title': 'System maintenance completed', 'time': '2 hours ago', 'type': 'system'},
    {'title': '5 new users registered', 'time': '3 hours ago', 'type': 'user'},
  ];

  Widget _buildActivityItem(String title, String time, String type) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getActivityColor(type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getActivityIcon(type),
            color: _getActivityColor(type),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'subscription':
        return Icons.subscriptions;
      case 'school':
        return Icons.school;
      case 'payment':
        return Icons.payment;
      case 'system':
        return Icons.build;
      case 'user':
        return Icons.person_add;
      default:
        return Icons.notifications;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'subscription':
        return Colors.green;
      case 'school':
        return Colors.blue;
      case 'payment':
        return Colors.purple;
      case 'system':
        return Colors.orange;
      case 'user':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRecentSubscriptions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Subscriptions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('School')),
                  DataColumn(label: Text('Plan')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Renewal')),
                ],
                rows: List.generate(4 , (index) {
                  final subscription = _subscriptions[index];
                  return DataRow(
                    cells: [
                      DataCell(Text(subscription['school']!)),
                      DataCell(
                        Chip(
                          label: Text(subscription['plan']!),
                          backgroundColor: _getPlanColor(subscription['plan']!).withOpacity(0.1),
                          labelStyle: TextStyle(
                            color: _getPlanColor(subscription['plan']!),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataCell(
                        Chip(
                          label: Text(subscription['status']!),
                          backgroundColor: _getStatusColor(subscription['status']!).withOpacity(0.1),
                          labelStyle: TextStyle(
                            color: _getStatusColor(subscription['status']!),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      DataCell(Text(subscription['renewal']!)),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Map<String, String>> _subscriptions = [
    {'school': 'Greenwood High', 'plan': 'Premium', 'status': 'Active', 'renewal': '2024-02-15'},
    {'school': 'Sunrise Academy', 'plan': 'Basic', 'status': 'Active', 'renewal': '2024-02-20'},
    {'school': 'Central School', 'plan': 'Premium', 'status': 'Expiring', 'renewal': '2024-01-30'},
    {'school': 'Northwood School', 'plan': 'Enterprise', 'status': 'Active', 'renewal': '2024-03-10'},
    {'school': 'Valley Prep', 'plan': 'Basic', 'status': 'Trial', 'renewal': '2024-02-28'},
  ];

  Widget _buildSystemHealth(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Health',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(_systemHealth.length, (index) {
              final health = _systemHealth[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildHealthItem(
                  health['service']!,
                  health['status']!,
                  health['value']!,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  final List<Map<String, String>> _systemHealth = [
    {'service': 'API Service', 'status': 'Operational', 'value': '99.9%'},
    {'service': 'Database', 'status': 'Operational', 'value': '99.8%'},
    {'service': 'Map Service', 'status': 'Operational', 'value': '99.7%'},
    {'service': 'Notification', 'status': 'Degraded', 'value': '95.2%'},
    {'service': 'File Storage', 'status': 'Operational', 'value': '99.5%'},
  ];

  Widget _buildHealthItem(String service, String status, String value) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(
                  color: status == 'Operational' ? Colors.green : Colors.orange,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 80,
          child: LinearProgressIndicator(
            value: double.parse(value.replaceAll('%', '')) / 100,
            backgroundColor: Colors.grey[200],
            color: status == 'Operational' ? Colors.green : Colors.orange,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Color _getPlanColor(String plan) {
    switch (plan) {
      case 'Premium':
        return Colors.purple;
      case 'Enterprise':
        return Colors.blue;
      case 'Basic':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Expiring':
        return Colors.orange;
      case 'Trial':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}