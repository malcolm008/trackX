import 'package:flutter/material.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );
  String _selectedMetric = 'users';
  String _selectedChartType = 'line';

  // Mock data
  final List<Map<String, dynamic>> _revenueData = [
    {'month': 'Jan', 'revenue': 45000},
    {'month': 'Feb', 'revenue': 52000},
    {'month': 'Mar', 'revenue': 48000},
    {'month': 'Apr', 'revenue': 61000},
    {'month': 'May', 'revenue': 55000},
    {'month': 'Jun', 'revenue': 72000},
    {'month': 'Jul', 'revenue': 68000},
    {'month': 'Aug', 'revenue': 75000},
    {'month': 'Sep', 'revenue': 82000},
    {'month': 'Oct', 'revenue': 78000},
    {'month': 'Nov', 'revenue': 85000},
    {'month': 'Dec', 'revenue': 92000},
  ];

  final List<Map<String, dynamic>> _userGrowthData = [
    {'month': 'Jan', 'users': 1500},
    {'month': 'Feb', 'users': 1800},
    {'month': 'Mar', 'users': 2200},
    {'month': 'Apr', 'users': 2500},
    {'month': 'May', 'users': 3000},
    {'month': 'Jun', 'users': 3500},
    {'month': 'Jul', 'users': 4200},
    {'month': 'Aug', 'users': 5000},
    {'month': 'Sep', 'users': 5800},
    {'month': 'Oct', 'users': 6500},
    {'month': 'Nov', 'users': 7200},
    {'month': 'Dec', 'users': 8000},
  ];

  final List<Map<String, dynamic>> _subscriptionData = [
    {'plan': 'Basic', 'count': 12, 'color': Colors.blue},
    {'plan': 'Pro', 'count': 25, 'color': Colors.green},
    {'plan': 'Enterprise', 'count': 8, 'color': Colors.purple},
  ];

  final List<Map<String, dynamic>> _regionalData = [
    {'region': 'North Region', 'schools': 45, 'revenue': 120000, 'growth': 12.5},
    {'region': 'South Region', 'schools': 28, 'revenue': 85000, 'growth': 8.2},
    {'region': 'East Region', 'schools': 32, 'revenue': 95000, 'growth': 10.3},
    {'region': 'West Region', 'schools': 39, 'revenue': 110000, 'growth': 15.7},
    {'region': 'Central Region', 'schools': 51, 'revenue': 135000, 'growth': 18.9},
  ];

  final List<Map<String, dynamic>> _dailyActiveUsers = [
    {'date': '2024-01-01', 'users': 3200},
    {'date': '2024-01-02', 'users': 3500},
    {'date': '2024-01-03', 'users': 3800},
    {'date': '2024-01-04', 'users': 4200},
    {'date': '2024-01-05', 'users': 4000},
    {'date': '2024-01-06', 'users': 4500},
    {'date': '2024-01-07', 'users': 4800},
    {'date': '2024-01-08', 'users': 5200},
    {'date': '2024-01-09', 'users': 5500},
    {'date': '2024-01-10', 'users': 5800},
  ];

  final List<Map<String, dynamic>> _performanceMetrics = [
    {'name': 'Conversion Rate', 'value': 3.8, 'change': 0.4, 'isPositive': true},
    {'name': 'Bounce Rate', 'value': 28.5, 'change': -2.1, 'isPositive': false},
    {'name': 'Avg. Order Value', 'value': 1245, 'change': 12.8, 'isPositive': true},
    {'name': 'Retention Rate', 'value': 84.3, 'change': 3.2, 'isPositive': true},
    {'name': 'Support Tickets', 'value': 128, 'change': -15.6, 'isPositive': false},
    {'name': 'Satisfaction Score', 'value': 4.8, 'change': 0.3, 'isPositive': true},
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;
        final isTablet = constraints.maxWidth >= 768;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 0 : 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with filters
              _buildFiltersHeader(isDesktop, isTablet),
              const SizedBox(height: 24),

              // Key metrics
              _buildKeyMetrics(isDesktop, isTablet),
              const SizedBox(height: 24),

              // Charts
              _buildChartsSection(isDesktop, isTablet),
              const SizedBox(height: 24),

              // Regional data
              _buildRegionalData(isDesktop, isTablet),
              const SizedBox(height: 24),

              // Performance metrics
              _buildPerformanceMetrics(isDesktop, isTablet),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFiltersHeader(bool isDesktop, bool isTablet) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 16 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics Dashboard',
              style: TextStyle(
                fontSize: isDesktop ? 24 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterButton('Date Range', Icons.calendar_today, () => _selectDateRange()),
                _buildFilterButton('Metrics', Icons.analytics, () => _selectMetric()),
                _buildFilterButton('Export', Icons.download, () => _exportData()),
                _buildFilterButton('Refresh', Icons.refresh, () => _refreshData()),
              ],
            ),
            if (isDesktop || isTablet) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () => _generateReport(),
                  icon: const Icon(Icons.insights),
                  label: const Text('Generate Report'),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Showing data from ${_dateRange.start.day}/${_dateRange.start.month}/${_dateRange.start.year} to ${_dateRange.end.day}/${_dateRange.end.month}/${_dateRange.end.year}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, IconData icon, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
    );
  }

  Widget _buildKeyMetrics(bool isDesktop, bool isTablet) {
    final totalRevenue = _revenueData.fold(0.0, (sum, item) => sum + (item['revenue'] as double));
    final totalUsers = _userGrowthData.fold(0, (sum, item) => sum + (item['users'] as int));
    final totalSchools = _regionalData.fold(0, (sum, item) => sum + (item['schools'] as int));
    final avgSession = '24m 36s';
    final churnRate = 2.4;
    final arr = totalRevenue * 12;
    final ltv = 2450;
    final cac = 450;

    // Responsive grid count
    final crossAxisCount = isDesktop ? 4 : (isTablet ? 2 : 1);

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: isDesktop ? 1.2 : 1.5,
      children: [
        _buildMetricCard(
          'Total Revenue',
          '\$${totalRevenue.toStringAsFixed(0)}',
          '+12.5%',
          Icons.attach_money,
          Colors.green,
        ),
        _buildMetricCard(
          'Active Users',
          totalUsers.toString(),
          '+8.2%',
          Icons.people,
          Colors.blue,
        ),
        _buildMetricCard(
          'New Schools',
          totalSchools.toString(),
          '+15.3%',
          Icons.school,
          Colors.purple,
        ),
        _buildMetricCard(
          'Avg. Session',
          avgSession,
          '+2.4%',
          Icons.timer,
          Colors.orange,
        ),
        _buildMetricCard(
          'Churn Rate',
          '$churnRate%',
          '-0.8%',
          Icons.trending_down,
          Colors.red,
        ),
        _buildMetricCard(
          'ARR',
          '\$${arr.toStringAsFixed(0)}',
          '+18.7%',
          Icons.bar_chart,
          Colors.teal,
        ),
        _buildMetricCard(
          'LTV',
          '\$$ltv',
          '+5.6%',
          Icons.currency_exchange,
          Colors.indigo,
        ),
        _buildMetricCard(
          'CAC',
          '\$$cac',
          '-3.2%',
          Icons.account_balance_wallet,
          Colors.amber,
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, String change, IconData icon, Color color) {
    final isPositive = change.contains('+');

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
                Text(
                  change,
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection(bool isDesktop, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Performance Overview',
              style: TextStyle(
                fontSize: isDesktop ? 20 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isDesktop || isTablet)
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Line'),
                    selected: _selectedChartType == 'line',
                    onSelected: (selected) {
                      setState(() {
                        _selectedChartType = 'line';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Bar'),
                    selected: _selectedChartType == 'bar',
                    onSelected: (selected) {
                      setState(() {
                        _selectedChartType = 'bar';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Area'),
                    selected: _selectedChartType == 'area',
                    onSelected: (selected) {
                      setState(() {
                        _selectedChartType = 'area';
                      });
                    },
                  ),
                ],
              )
            else
              DropdownButton<String>(
                value: _selectedChartType,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'line',
                    child: Text('Line Chart'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'bar',
                    child: Text('Bar Chart'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'area',
                    child: Text('Area Chart'),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    _selectedChartType = value!;
                  });
                },
              ),
          ],
        ),
        const SizedBox(height: 16),

        // First row of charts
        if (isDesktop)
          Row(
            children: [
              Expanded(child: _buildRevenueChart(isDesktop)),
              const SizedBox(width: 16),
              Expanded(child: _buildUserGrowthChart(isDesktop)),
            ],
          )
        else
          Column(
            children: [
              _buildRevenueChart(isDesktop),
              const SizedBox(height: 16),
              _buildUserGrowthChart(isDesktop),
            ],
          ),
        const SizedBox(height: 16),

        // Second row of charts
        if (isDesktop)
          Row(
            children: [
              Expanded(child: _buildSubscriptionChart(isDesktop)),
              const SizedBox(width: 16),
              Expanded(child: _buildDailyUsersChart(isDesktop)),
            ],
          )
        else
          Column(
            children: [
              _buildSubscriptionChart(isDesktop),
              const SizedBox(height: 16),
              _buildDailyUsersChart(isDesktop),
            ],
          ),
      ],
    );
  }

  Widget _buildRevenueChart(bool isDesktop) {
    final maxRevenue = _revenueData.fold(0.0, (max, item) {
      final revenue = item['revenue'] as double;
      return revenue > max ? revenue : max;
    });

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 16 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Revenue Trend',
                  style: TextStyle(
                    fontSize: isDesktop ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: isDesktop ? 300 : 200,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: _revenueData.map((item) {
                        final revenue = item['revenue'] as double;
                        final percentage = revenue / maxRevenue;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: percentage * (isDesktop ? 200 : 120),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['month'].toString().substring(0, 3),
                                  style: const TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Revenue (\$ in thousands)',
                    style: TextStyle(
                      fontSize: isDesktop ? 12 : 10,
                      color: Colors.grey,
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

  Widget _buildUserGrowthChart(bool isDesktop) {
    final maxUsers = _userGrowthData.fold(0, (max, item) {
      final users = item['users'] as int;
      return users > max ? users : max;
    });

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 16 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'User Growth',
                  style: TextStyle(
                    fontSize: isDesktop ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: isDesktop ? 300 : 200,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: CustomPaint(
                  painter: SimpleLineChartPainter(
                    data: _userGrowthData,
                    valueKey: 'users',
                    color: Colors.green,
                  ),
                  child: Container(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jan',
                    style: TextStyle(
                      fontSize: isDesktop ? 12 : 10,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Dec',
                    style: TextStyle(
                      fontSize: isDesktop ? 12 : 10,
                      color: Colors.grey,
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

  Widget _buildSubscriptionChart(bool isDesktop) {
    final total = _subscriptionData.fold(0, (sum, item) => sum + (item['count'] as int));

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 16 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subscription Distribution',
                  style: TextStyle(
                    fontSize: isDesktop ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: isDesktop ? 300 : 200,
              child: Row(
                children: [
                  // Chart visualization
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _subscriptionData.map((item) {
                        final percentage = ((item['count'] as int) / total * 100).toStringAsFixed(1);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                color: item['color'] as Color,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${item['plan']} ($percentage%)',
                                  style: TextStyle(
                                    fontSize: isDesktop ? 12 : 10,
                                  ),
                                ),
                              ),
                              Text(
                                '${item['count']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isDesktop ? 12 : 10,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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

  Widget _buildDailyUsersChart(bool isDesktop) {
    final maxUsers = _dailyActiveUsers.fold(0, (max, item) {
      final users = item['users'] as int;
      return users > max ? users : max;
    });

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 16 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Active Users',
                  style: TextStyle(
                    fontSize: isDesktop ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: isDesktop ? 300 : 200,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: _dailyActiveUsers.map((item) {
                        final users = item['users'] as int;
                        final percentage = users / maxUsers;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: percentage * (isDesktop ? 200 : 120),
                                  decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  (item['date'] as String).substring(8, 10),
                                  style: const TextStyle(fontSize: 8),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Date (Day of Month)',
                    style: TextStyle(
                      fontSize: isDesktop ? 12 : 10,
                      color: Colors.grey,
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

  Widget _buildRegionalData(bool isDesktop, bool isTablet) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 16 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Regional Performance',
              style: TextStyle(
                fontSize: isDesktop ? 20 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            if (isDesktop)
              _buildDesktopRegionalTable()
            else
              _buildMobileRegionalList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopRegionalTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Region')),
          DataColumn(label: Text('Schools'), numeric: true),
          DataColumn(label: Text('Revenue'), numeric: true),
          DataColumn(label: Text('Growth'), numeric: true),
          DataColumn(label: Text('Actions')),
        ],
        rows: _regionalData.map((region) {
          final growth = (region['growth'] as double).toStringAsFixed(1);
          return DataRow(cells: [
            DataCell(Text(region['region'] as String)),
            DataCell(Text(region['schools'].toString())),
            DataCell(Text('\$${(region['revenue'] as double).toStringAsFixed(0)}')),
            DataCell(Text('$growth%')),
            DataCell(
              IconButton(
                icon: const Icon(Icons.insights, size: 20),
                onPressed: () => _viewRegionDetails(region),
              ),
            ),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildMobileRegionalList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _regionalData.length,
      itemBuilder: (context, index) {
        final region = _regionalData[index];
        final growth = (region['growth'] as double).toStringAsFixed(1);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(region['region'] as String),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Schools: ${region['schools']}'),
                Text('Revenue: \$${(region['revenue'] as double).toStringAsFixed(0)}'),
                Text('Growth: $growth%'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.insights, size: 20),
              onPressed: () => _viewRegionDetails(region),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPerformanceMetrics(bool isDesktop, bool isTablet) {
    // Responsive grid count
    final crossAxisCount = isDesktop ? 3 : (isTablet ? 2 : 1);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 16 : 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Metrics',
              style: TextStyle(
                fontSize: isDesktop ? 20 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2,
              children: _performanceMetrics.map((metric) {
                return _buildKPI(
                  metric['name'] as String,
                  metric['name'] == 'Satisfaction Score'
                      ? '${metric['value']}/5'
                      : metric['name'] == 'Avg. Order Value'
                      ? '\$${metric['value']}'
                      : '${metric['value']}${metric['name'] == 'Conversion Rate' || metric['name'] == 'Retention Rate' ? '%' : ''}',
                  '${(metric['change'] as double) > 0 ? '+' : ''}${metric['change']}${metric['name'] == 'Satisfaction Score' ? '' : '%'}',
                  metric['isPositive'] as bool ? Icons.trending_up : Icons.trending_down,
                  metric['isPositive'] as bool ? Colors.green : Colors.red,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPI(String title, String value, String change, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            change,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );

    if (picked != null && picked != _dateRange) {
      setState(() {
        _dateRange = picked;
      });
    }
  }

  void _selectMetric() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Metric'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('User Metrics'),
                value: 'users',
                groupValue: _selectedMetric,
                onChanged: (String? value) {
                  setState(() {
                    _selectedMetric = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('Revenue Metrics'),
                value: 'revenue',
                groupValue: _selectedMetric,
                onChanged: (String? value) {
                  setState(() {
                    _selectedMetric = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('Growth Metrics'),
                value: 'growth',
                groupValue: _selectedMetric,
                onChanged: (String? value) {
                  setState(() {
                    _selectedMetric = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('Performance Metrics'),
                value: 'performance',
                groupValue: _selectedMetric,
                onChanged: (String? value) {
                  setState(() {
                    _selectedMetric = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting analytics data...')),
    );
  }

  void _refreshData() {
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data refreshed')),
    );
  }

  void _generateReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Report Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Report Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem<String>(
                  value: 'summary',
                  child: Text('Summary Report'),
                ),
                DropdownMenuItem<String>(
                  value: 'detailed',
                  child: Text('Detailed Report'),
                ),
                DropdownMenuItem<String>(
                  value: 'custom',
                  child: Text('Custom Report'),
                ),
              ],
              onChanged: (String? value) {},
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
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
                const SnackBar(content: Text('Report generated and sent')),
              );
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _viewRegionDetails(Map<String, dynamic> region) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${region['region']} Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Number of Schools'),
                trailing: Text(region['schools'].toString()),
              ),
              ListTile(
                title: const Text('Total Revenue'),
                trailing: Text('\$${(region['revenue'] as double).toStringAsFixed(0)}'),
              ),
              ListTile(
                title: const Text('Average Revenue per School'),
                trailing: Text('\$${((region['revenue'] as double) / (region['schools'] as int)).toStringAsFixed(0)}'),
              ),
              ListTile(
                title: const Text('Growth Rate'),
                trailing: Text('${(region['growth'] as double).toStringAsFixed(1)}%'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('View Full Report'),
          ),
        ],
      ),
    );
  }
}

class SimpleLineChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final String valueKey;
  final Color color;

  SimpleLineChartPainter({
    required this.data,
    required this.valueKey,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final maxValue = data.fold(0.0, (max, item) {
      final value = item[valueKey] is int ? (item[valueKey] as int).toDouble() : (item[valueKey] as double);
      return value > max ? value : max;
    });

    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final value = data[i][valueKey] is int ? (data[i][valueKey] as int).toDouble() : (data[i][valueKey] as double);
      final x = (size.width / (data.length - 1)) * i;
      final y = size.height - (value / maxValue) * size.height;
      points.add(Offset(x, y));
    }

    // Draw line
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    for (final point in points) {
      canvas.drawCircle(point, 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}