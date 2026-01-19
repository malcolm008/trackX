import 'package:flutter/material.dart';
import 'package:bustracker_007/data/models/web/school_subscription.dart';
import 'package:bustracker_007/data/models/web/school.dart';
import 'package:bustracker_007/data/models/web/subscription_plan.dart';

class SubscriptionDetailsDialog extends StatelessWidget {
  final SchoolSubscription subscription;
  final School school;
  final SubscriptionPlan plan;

  const SubscriptionDetailsDialog({
    super.key,
    required this.subscription,
    required this.school,
    required this.plan,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
                    'Subscription Details',
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

              // School Info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(0.1),
                        child: const Icon(Icons.school, color: Colors.blue),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              school.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              school.email,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Subscription Details
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3,
                children: [
                  _buildDetailItem('Subscription ID', subscription.subscriptionCode),
                  _buildDetailItem('Plan', plan.name),
                  _buildDetailItem('Amount', '\$${subscription.amount.toStringAsFixed(2)}'),
                  _buildDetailItem('Status', subscription.status.toUpperCase()),
                  _buildDetailItem('Start Date', _formatDate(subscription.startDate)),
                  _buildDetailItem('End Date', _formatDate(subscription.endDate)),
                  _buildDetailItem('Auto Renew', subscription.autoRenew ? 'Yes' : 'No'),
                  _buildDetailItem('Payment Method', subscription.paymentMethod ?? 'Not specified'),
                ],
              ),
              const SizedBox(height: 24),

              // Plan Features
              if (plan.features != null && plan.features!.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Plan Features:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: plan.features!.keys.map((feature) {
                            return Chip(
                              label: Text(feature),
                              backgroundColor: Colors.green.withOpacity(0.1),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // Handle renew action
                      },
                      icon: const Icon(Icons.autorenew),
                      label: const Text('Renew Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}