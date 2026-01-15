import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bustracker_007/core/services/api_service.dart';
import 'package:bustracker_007/data/models/web/subscription/subscription_model.dart';
import 'package:bustracker_007/data/models/web/subscription/billing_plan_model.dart';
import '../widgets/billing_dialog.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  List<Subscription> _subscriptions = [];
  List<Subscription> _filteredSubscriptions = [];
  SubscriptionStats? _stats;
  List<BillingPlan> _billingPlans = [];


  String _selectedPlan = 'all';
  String _selectedFilter = 'all';
  final List<String> _filters = ['all', 'active', 'expiring', 'trial', 'cancelled'];

  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadData();

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _apiService.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchDebounce?.isActive ?? false) {
      _searchDebounce?.cancel();
    }

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _applyFilters();
    });
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final subscriptions = await _apiService.getSubscriptions();
      final stats = await _apiService.getSubscriptionStats();
      final plans = await _apiService.getBillingPlans();

      setState(() {
        _subscriptions = subscriptions;
        _stats = stats;
        _billingPlans = plans;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      _loadMockData();
    }
  }

  void _loadMockData() {
    // Fallback mock data
    setState(() {
      _subscriptions = [
        Subscription(
          id: 'SUB-001',
          schoolId: 'SCH-001',
          schoolName: 'Greenwood High',
          plan: 'Premium',
          amount: 499.00,
          period: 'Monthly',
          status: 'active',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 1, 31),
          autoRenew: true,
          students: 500,
          buses: 10,
        ),
        // ... other mock subscriptions
      ];

      _stats = SubscriptionStats(
        totalRevenue: 12450.00,
        activeSubscriptions: 42,
        trialSubscriptions: 8,
        renewalRate: 94.0,
        expiringSoon: 2,
        cancelledThisMonth: 1,
      );

      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Subscription> filtered = List.from(_subscriptions);

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered.where((subscription) {
        return subscription.schoolName.toLowerCase().contains(searchTerm) ||
            subscription.id.toLowerCase().contains(searchTerm) ||
            subscription.schoolId.toLowerCase().contains(searchTerm);
      }).toList();
    }

    // Apply status filter
    if (_selectedFilter != 'all') {
      filtered = filtered.where((subscription) {
        return subscription.status.toLowerCase() == _selectedFilter.toLowerCase();
      }).toList();
    }

    // Apply plan filter
    if (_selectedPlan != 'all') {
      filtered = filtered.where((subscription) {
        return subscription.plan.toLowerCase() == _selectedPlan.toLowerCase();
      }).toList();
    }

    setState(() {
      _filteredSubscriptions = filtered;
    });
  }

  void _handleFilterChange(String? value) {
    if (value != null) {
      setState(() {
        _selectedFilter = value;
      });
      _applyFilters();
    }
  }

  void _handlePlanChange(String? value) {
    if (value != null) {
      setState(() {
        _selectedPlan = value;
      });
      _applyFilters();
    }
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedFilter = 'all';
      _selectedPlan = 'all';
    });
    _applyFilters();
  }

  void _showAddSubscriptionDialog() {
    // You'll need to implement this based on your school selection
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Subscription'),
        content: const Text('Select a school to add subscription'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          // Implement school selection and plan assignment
        ],
      ),
    );
  }

  void _showBillingPlansDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: BillingPlansDialog(
            apiService: _apiService,
            onPlanAdded: () => _loadData(),
          ),
        ),
      ),
    );
  }

  Future<void> _updateAutoRenew(Subscription subscription, bool value) async {
    try {
      final success = await _apiService.updateSubscriptionAutoRenew(subscription.id, value,);

      if (success) {
        setState(() {
          final index = _subscriptions.indexWhere((s) => s.id == subscription.id);
          if (index != -1) {
            _subscriptions[index] = subscription.copyWith(autoRenew: value);
            _applyFilters();
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Auto-renew ${value? 'enabled' : 'disabled'}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update auto-renew: $e'),
          backgroundColor: Colors.red,
        )
      );
    }
  }

  Future<void> _cancelSubscription(Subscription subscription) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Subscription'),
        content: Text('Are you sure you want to cancel subscription for ${subscription.schoolName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await _apiService.cancelSubscription(subscription.id);

        if (success) {
          setState(() {
            final index = _subscriptions.indexWhere((s) => s.id == subscription.id);
            if (index != -1) {
              _subscriptions[index] = subscription.copyWith(
                status: 'cancelled',
                autoRenew: false,
              );
              _applyFilters();
            }
          });

          // Refresh stats
          _loadData();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Subscription cancelled successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to cancel subscription: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _renewSubscription(Subscription subscription) async {
    final months = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Renew Subscription'),
        content: const Text('Select renewal period:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 1),
            child: const Text('1 Month'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 3),
            child: const Text('3 Months'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 6),
            child: const Text('6 Months'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 12),
            child: const Text('1 Year'),
          ),
        ],
      ),
    );

    if (months != null) {
      try {
        final success = await _apiService.renewSubscription(subscription.id, months);

        if (success) {
          setState(() {
            final index = _subscriptions.indexWhere((s) => s.id == subscription.id);
            if (index != -1) {
              final newEndDate = subscription.endDate.add(Duration(days: 30 * months));
              _subscriptions[index] = subscription.copyWith(
                endDate: newEndDate,
                status: 'active',
              );
              _applyFilters();
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Subscription renewed for $months months'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to renew subscription: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _changeSubscriptionPlan(Subscription subscription) async {
    final newPlan = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Plan'),
        content: const Text('Select new plan:'),
        actions: _billingPlans.map((plan) {
          return TextButton(
            onPressed: () => Navigator.pop(context, plan.name),
            child: Text(plan.name),
          );
        }).toList(),
      ),
    );

    if (newPlan != null && newPlan != subscription.plan) {
      try {
        final success = await _apiService.changeSubscriptionPlan(subscription.id, newPlan);

        if (success) {
          setState(() {
            final index = _subscriptions.indexWhere((s) => s.id == subscription.id);
            if (index != -1) {
              // Find new plan amount
              final newPlanAmount = _billingPlans
                  .firstWhere((plan) => plan.name == newPlan)
                  .price;

              _subscriptions[index] = subscription.copyWith(
                plan: newPlan,
                amount: newPlanAmount,
              );
              _applyFilters();
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Plan changed to $newPlan'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to change plan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


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
                    DataCell(Text(subscription.id)),
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
                            subscription.schoolName,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text('Expires: ${subscription.endDate}'),
                        ),
                      ),
                    ),
                    DataCell(
                      Chip(
                        label: Text(subscription.plan),
                        backgroundColor:
                        _getPlanColor(subscription.plan).withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: _getPlanColor(subscription.plan),
                        ),
                      ),
                    ),
                    DataCell(Text(subscription.status)),
                    DataCell(
                      Chip(
                        label: Text(subscription.status.toString().capitalize()),
                        backgroundColor:
                        _getStatusColor(subscription.status).withOpacity(0.1),
                        labelStyle: TextStyle(
                          color: _getStatusColor(subscription.status),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    DataCell(Text(subscription.students.toString())),
                    DataCell(Text(subscription.buses.toString())),
                    DataCell(
                      Switch(
                        value: subscription.autoRenew,
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
                      subscription.id,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Chip(
                      label: Text(subscription.status.toString().capitalize()),
                      backgroundColor:
                      _getStatusColor(subscription.status).withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: _getStatusColor(subscription.status),
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
                  title: Text(subscription.schoolName),
                  subtitle: Text('Plan: ${subscription.plan} • ${subscription.amount}'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildMobileStat('Students', subscription.students.toString()),
                    const SizedBox(width: 16),
                    _buildMobileStat('Buses', subscription.buses.toString()),
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
                          value: subscription.autoRenew,
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
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}