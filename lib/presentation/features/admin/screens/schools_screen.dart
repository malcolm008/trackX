import 'package:flutter/material.dart';
import 'package:bustracker_007/core/utils/string_extensions.dart';

class SchoolsScreen extends StatefulWidget {
  const SchoolsScreen({super.key});

  @override
  State<SchoolsScreen> createState() => _SchoolsScreenState();
}

class _SchoolsScreenState extends State<SchoolsScreen> {
  final List<Map<String, dynamic>> _schools = [
    {
      'id': 'SCH-001',
      'name': 'Greenwood High',
      'email': 'contact@greenwood.edu',
      'phone': '+1 (555) 123-4567',
      'address': '123 Main St, Greenwood City',
      'students': 500,
      'buses': 10,
      'status': 'active',
      'subscription': 'Premium',
      'created': '2023-12-01',
    },
    {
      'id': 'SCH-002',
      'name': 'Sunrise Academy',
      'email': 'info@sunrise.edu',
      'phone': '+1 (555) 234-5678',
      'address': '456 Oak Ave, Sunrise Town',
      'students': 200,
      'buses': 5,
      'status': 'active',
      'subscription': 'Basic',
      'created': '2024-01-05',
    },
    {
      'id': 'SCH-003',
      'name': 'Central School',
      'email': 'admin@central.edu',
      'phone': '+1 (555) 345-6789',
      'address': '789 Central Blvd, Metro City',
      'students': 450,
      'buses': 8,
      'status': 'expiring',
      'subscription': 'Premium',
      'created': '2023-11-15',
    },
    {
      'id': 'SCH-004',
      'name': 'Northwood School',
      'email': 'support@northwood.edu',
      'phone': '+1 (555) 456-7890',
      'address': '101 Pine Rd, Northwood',
      'students': 1000,
      'buses': 25,
      'status': 'active',
      'subscription': 'Enterprise',
      'created': '2024-01-10',
    },
    {
      'id': 'SCH-005',
      'name': 'Valley Prep',
      'email': 'hello@valleyprep.edu',
      'phone': '+1 (555) 567-8901',
      'address': '202 Valley Dr, Valley Town',
      'students': 150,
      'buses': 4,
      'status': 'trial',
      'subscription': 'Basic',
      'created': '2024-01-22',
    },
  ];

  String _selectedStatus = 'all';
  String _selectedSubscription = 'all';
  final List<String> _statuses = ['all', 'active', 'expiring', 'trial', 'inactive'];
  final List<String> _subscriptions = ['all', 'premium', 'basic', 'enterprise', 'trial'];

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
            if (isDesktop)
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

        // Quick Stats
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildSchoolStat('Total Schools', '42', Icons.school, Colors.blue),
            _buildSchoolStat('Active Today', '38', Icons.today, Colors.green),
            _buildSchoolStat('New This Month', '5', Icons.new_releases, Colors.orange),
            _buildSchoolStat('Total Students', '2,300', Icons.people, Colors.purple),
            _buildSchoolStat('Total Buses', '52', Icons.directions_bus, Colors.indigo),
            _buildSchoolStat('Revenue/Month', '\$12,450', Icons.attach_money, Colors.teal),
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
                          hintText: 'Search schools by name, location, or ID...',
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
                      DropdownButton<String>(
                        value: _selectedSubscription,
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
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.filter_alt),
                        label: const Text('Advanced'),
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedSubscription,
                          decoration: const InputDecoration(
                            labelText: 'Subscription',
                            border: OutlineInputBorder(),
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
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddSchoolDialog();
                    },
                    icon: const Icon(Icons.add_business),
                    label: const Text('Add School'),
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

        // Schools Table/List
        Expanded(
          child: isDesktop
              ? _buildDesktopTable()
              : _buildMobileList(),
        ),
      ],
    );
  }

  Widget _buildSchoolStat(String title, String value, IconData icon, Color color) {
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
    return Card(
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('School')),
            DataColumn(label: Text('Contact')),
            DataColumn(label: Text('Stats')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Subscription')),
            DataColumn(label: Text('Created')),
            DataColumn(label: Text('Actions')),
          ],
          rows: _schools.map((school) {
            return DataRow(
              cells: [
                DataCell(
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: const Icon(Icons.school, size: 20, color: Colors.blue),
                    ),
                    title: Text(school['name']),
                    subtitle: Text(school['address']),
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(school['email']),
                      Text(school['phone']),
                    ],
                  ),
                ),
                DataCell(
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            school['students'].toString(),
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
                        children: [
                          Text(
                            school['buses'].toString(),
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
                    label: Text(school['status'].toString().capitalize()),
                    backgroundColor: _getStatusColor(school['status']).withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: _getStatusColor(school['status']),
                      fontSize: 12,
                    ),
                  ),
                ),
                DataCell(
                  Chip(
                    label: Text(school['subscription']),
                    backgroundColor: _getSubscriptionColor(school['subscription']).withOpacity(0.1),
                    labelStyle: TextStyle(
                      color: _getSubscriptionColor(school['subscription']),
                      fontSize: 12,
                    ),
                  ),
                ),
                DataCell(Text(school['created'])),
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
                          title: Text('Edit School'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'subscription',
                        child: ListTile(
                          leading: Icon(Icons.subscriptions),
                          title: Text('Manage Subscription'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'users',
                        child: ListTile(
                          leading: Icon(Icons.people),
                          title: Text('Manage Users'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'buses',
                        child: ListTile(
                          leading: Icon(Icons.directions_bus),
                          title: Text('Manage Buses'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Delete', style: TextStyle(color: Colors.red)),
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
    );
  }

  Widget _buildMobileList() {
    return ListView.builder(
      itemCount: _schools.length,
      itemBuilder: (context, index) {
        final school = _schools[index];
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
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: const Icon(Icons.school, size: 20, color: Colors.blue),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            school['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            school['address'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Chip(
                      label: Text(school['status'].toString().capitalize()),
                      backgroundColor: _getStatusColor(school['status']).withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: _getStatusColor(school['status']),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            school['email'],
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            school['phone'],
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      children: [
                        Row(
                          children: [
                            _buildMobileStat('Students', school['students'].toString()),
                            const SizedBox(width: 16),
                            _buildMobileStat('Buses', school['buses'].toString()),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(school['subscription']),
                          backgroundColor: _getSubscriptionColor(school['subscription']).withOpacity(0.1),
                          labelStyle: TextStyle(
                            color: _getSubscriptionColor(school['subscription']),
                            fontSize: 12,
                          ),
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
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
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
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  void _showAddSchoolDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24),
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
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'School Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Contact Person',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Subscription Plan',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Basic', 'Premium', 'Enterprise', 'Trial']
                          .map((plan) => DropdownMenuItem(
                        value: plan,
                        child: Text(plan),
                      ))
                          .toList(),
                      onChanged: (value) {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('School added successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
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
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'expiring':
        return Colors.orange;
      case 'trial':
        return Colors.blue;
      case 'inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getSubscriptionColor(String subscription) {
    switch (subscription) {
      case 'Premium':
        return Colors.purple;
      case 'Enterprise':
        return Colors.blue;
      case 'Basic':
        return Colors.green;
      case 'Trial':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}