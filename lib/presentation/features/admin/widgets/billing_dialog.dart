import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bustracker_007/core/services/api_service.dart';
import 'package:bustracker_007/data/models/web/subscription/subscription_model.dart';
import 'package:bustracker_007/data/models/web/subscription/billing_plan_model.dart';


class BillingPlansDialog extends StatefulWidget {
  final ApiService apiService;
  final Function() onPlanAdded;

  const BillingPlansDialog({
    Key? key,
    required this.apiService,
    required this.onPlanAdded,
  }) : super(key: key);

  @override
  _BillingPlansDialogState createState() => _BillingPlansDialogState();
}

class _BillingPlansDialogState extends State<BillingPlansDialog> {
  List<BillingPlan> _plans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    try {
      final plans = await widget.apiService.getBillingPlans();
      setState(() {
        _plans = plans;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddPlanDialog() {
    showDialog(
      context: context,
      builder: (context) => AddBillingPlanDialog(
        apiService: widget.apiService,
        onPlanAdded: () {
          _loadPlans();
          widget.onPlanAdded();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Billing Plans',
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

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Column(
              children: [
                // Plan cards
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: _plans.length,
                  itemBuilder: (context, index) {
                    final plan = _plans[index];
                    return _buildPlanCard(plan);
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _showAddPlanDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Plan'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BillingPlan plan) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  plan.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text('\$${plan.price.toStringAsFixed(0)}/${plan.billingPeriod}'),
                  backgroundColor: Colors.blue.shade50,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              plan.description,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Features:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...plan.features.take(3).map((feature) => Text(
                    '• $feature',
                    style: const TextStyle(fontSize: 12),
                  )).toList(),
                  if (plan.features.length > 3)
                    Text(
                      '+ ${plan.features.length - 3} more',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Edit plan
                    },
                    child: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Delete plan
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Add Billing Plan Dialog
class AddBillingPlanDialog extends StatefulWidget {
  final ApiService apiService;
  final Function() onPlanAdded;

  const AddBillingPlanDialog({
    Key? key,
    required this.apiService,
    required this.onPlanAdded,
  }) : super(key: key);

  @override
  _AddBillingPlanDialogState createState() => _AddBillingPlanDialogState();
}

class _AddBillingPlanDialogState extends State<AddBillingPlanDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _maxStudentsController = TextEditingController(text: '0');
  final TextEditingController _maxBusesController = TextEditingController(text: '0');
  final List<TextEditingController> _featureControllers = [TextEditingController()];

  String _billingPeriod = 'monthly';
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _maxStudentsController.dispose();
    _maxBusesController.dispose();
    for (var controller in _featureControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addFeatureField() {
    setState(() {
      _featureControllers.add(TextEditingController());
    });
  }

  void _removeFeatureField(int index) {
    if (_featureControllers.length > 1) {
      setState(() {
        _featureControllers.removeAt(index);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final plan = BillingPlan(
          planId: '',
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          price: double.parse(_priceController.text),
          billingPeriod: _billingPeriod,
          maxStudents: int.parse(_maxStudentsController.text),
          maxBuses: int.parse(_maxBusesController.text),
          features: _featureControllers
              .map((c) => c.text.trim())
              .where((feature) => feature.isNotEmpty)
              .toList(),
          isActive: true,
          createdAt: DateTime.now(),
        );

        await widget.apiService.addBillingPlan(plan);

        widget.onPlanAdded();
        Navigator.pop(context); // Close add plan dialog
        Navigator.pop(context); // Close billing plans dialog

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Billing plan added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add billing plan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Billing Plan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Basic information
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Plan Name *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Price and billing period
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Price *',
                            prefixText: '\$',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) return 'Required';
                            final price = double.tryParse(value);
                            if (price == null || price < 0) return 'Invalid price';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _billingPeriod,
                          decoration: const InputDecoration(
                            labelText: 'Billing Period',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'monthly',
                              child: const Text('Monthly'),
                            ),
                            DropdownMenuItem(
                              value: 'yearly',
                              child: const Text('Yearly'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _billingPeriod = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Limits
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _maxStudentsController,
                          decoration: const InputDecoration(
                            labelText: 'Max Students',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final students = int.tryParse(value ?? '0');
                            if (students == null || students < 0) return 'Invalid number';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _maxBusesController,
                          decoration: const InputDecoration(
                            labelText: 'Max Buses',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final buses = int.tryParse(value ?? '0');
                            if (buses == null || buses < 0) return 'Invalid number';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Features
                  const Text(
                    'Plan Features',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._featureControllers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final controller = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: controller,
                              decoration: InputDecoration(
                                labelText: 'Feature ${index + 1}',
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          if (_featureControllers.length > 1)
                            IconButton(
                              icon: const Icon(Icons.remove, color: Colors.red),
                              onPressed: () => _removeFeatureField(index),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                  TextButton.icon(
                    onPressed: _addFeatureField,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Feature'),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitForm,
                          child: _isSubmitting
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : const Text('Add Plan'),
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
}

