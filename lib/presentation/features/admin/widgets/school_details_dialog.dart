import 'package:flutter/material.dart';
import 'package:bustracker_007/data/models/web/school/school_model.dart';
import 'package:bustracker_007/core/utils/string_extensions.dart';

class SchoolDetailsDialog extends StatelessWidget {
  final School school;

  const SchoolDetailsDialog({
    Key? key,
    required this.school,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 3),
                _buildSchoolInfo(context),
                const SizedBox(height: 0),
                _buildStatistics(),
                const SizedBox(height: 0),
                _buildSubscriptionInfo(),
                const SizedBox(height: 0),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              radius: 24,
              child: const Icon(Icons.school, size: 28, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  school.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  school.schoolId,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildSchoolInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'School Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.email,
              label: 'Email',
              value: school.email,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.phone,
              label: 'Phone',
              value: school.phone,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.location_on,
              label: 'Address',
              value: school.address,
              multiline: true,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Registered',
              value: _formatDate(school.createdAt),
            ),
            if (school.updatedAt != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow(
                icon: Icons.update,
                label: 'Last Updated',
                value: _formatDate(school.updatedAt!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Statistics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  icon: Icons.people,
                  value: school.students.toString(),
                  label: 'Students',
                  color: Colors.blue,
                ),
                _buildStatCard(
                  icon: Icons.directions_bus,
                  value: school.buses.toString(),
                  label: 'Buses',
                  color: Colors.green,
                ),
                _buildStatCard(
                  icon: Icons.speed,
                  value: '${(school.students / (school.buses == 0 ? 1 : school.buses)).toStringAsFixed(1)}',
                  label: 'Students per Bus',
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subscription Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Chip(
                  label: Text(
                    school.subscription,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: _getSubscriptionColor(school.subscription).withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: _getSubscriptionColor(school.subscription),
                  ),
                ),
                const SizedBox(width: 16),
                Chip(
                  label: Text(
                    school.status.capitalize(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: _getStatusColor(school.status).withOpacity(0.1),
                  labelStyle: TextStyle(
                    color: _getStatusColor(school.status),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildSubscriptionFeatures(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionFeatures() {
    final features = _getSubscriptionFeatures(school.subscription);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Features:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        ...features.map((feature) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 16,
                color: Colors.green,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  feature,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back),
            label: const Text('Close'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // This would be handled by the parent widget
              // Close details dialog first
            },
            icon: const Icon(Icons.edit),
            label: const Text('Edit School'),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool multiline = false,
  }) {
    return Row(
      crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: multiline ? 3 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
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

  List<String> _getSubscriptionFeatures(String subscription) {
    switch (subscription) {
      case 'Premium':
        return [
          'Up to 50 buses',
          'Advanced tracking features',
          'Priority support',
          'Custom reports',
          'API access'
        ];
      case 'Enterprise':
        return [
          'Unlimited buses',
          'All premium features',
          'Dedicated account manager',
          'Custom development',
          '24/7 phone support'
        ];
      case 'Basic':
        return [
          'Up to 10 buses',
          'Basic tracking',
          'Email support',
          'Standard reports'
        ];
      case 'Trial':
        return [
          '14-day trial period',
          'Basic features',
          'Limited to 5 buses',
          'Email support'
        ];
      default:
        return ['Basic tracking features'];
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.teal;
      case 'expiring':
        return Colors.orange;
      case 'trial':
        return Colors.purple;
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
        return Colors.deepPurple;
      case 'Basic':
        return Colors.blue;
      case 'Trial':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}