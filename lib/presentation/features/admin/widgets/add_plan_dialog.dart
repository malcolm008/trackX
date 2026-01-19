import 'package:flutter/material.dart';
import 'package:bustracker_007/data/models/web/subscription_plan.dart';

class AddPlanDialog extends StatefulWidget {
  final SubscriptionPlan? plan;
  final Function(SubscriptionPlan)? onPlanCreated;

  const AddPlanDialog({super.key, this.plan, this.onPlanCreated});

  @override
  State<AddPlanDialog> createState() => _AddPlanDialogState();
}

class _AddPlanDialogState extends State<AddPlanDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _maxStudentsController;
  late TextEditingController _maxBusesController;

  String _billingCycle = 'monthly';
  final List<String> _billingCycles = ['monthly', 'quarterly', 'annual'];

  final List<Map<String, dynamic>> _features = [];
  final List<Map<String, dynamic>> _limitations = [];

  final TextEditingController _featureController = TextEditingController();
  final TextEditingController _limitationController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final plan = widget.plan;
    _nameController = TextEditingController(text: plan?.name ?? '');
    _descriptionController = TextEditingController(text: plan?.description ?? '');
    _priceController = TextEditingController(text: plan?.price.toString() ?? '');
    _maxStudentsController = TextEditingController(text: plan?.maxStudents?.toString() ?? '');
    _maxBusesController = TextEditingController(text: plan?.maxBuses?.toString() ?? '');

    if (plan != null) {
      _billingCycle = plan.billingCycle;
      if (plan.features != null) {
        plan.features!.forEach((key, value) {
          _features.add({'key': key, 'value': value});
        });
      }
      if (plan.limitations != null) {
        plan.limitations!.forEach((key, value) {
          _limitations.add({'key': key, 'value': value});
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.plan == null ? 'Create New Plan' : 'Edit Plan',
                        style: const TextStyle(
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

                  // Basic Information
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Plan Name *',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter plan name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description *',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

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
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _billingCycle,
                          decoration: const InputDecoration(
                            labelText: 'Billing Cycle',
                            border: OutlineInputBorder(),
                          ),
                          items: _billingCycles.map((cycle) {
                            return DropdownMenuItem(
                              value: cycle,
                              child: Text(cycle.capitalize()),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _billingCycle = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Features
                  const Text(
                    'Features',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (_features.isNotEmpty)
                    Column(
                      children: _features.map((feature) {
                        return ListTile(
                          leading: const Icon(Icons.check, color: Colors.green),
                          title: Text(feature['key']),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, size: 18),
                            onPressed: () {
                              setState(() {
                                _features.remove(feature);
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),

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
                              _features.add({'key': _featureController.text, 'value': true});
                              _featureController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Limitations
                  const Text(
                    'Limitations',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),

                  if (_limitations.isNotEmpty)
                    Column(
                      children: _limitations.map((limitation) {
                        return ListTile(
                          leading: const Icon(Icons.close, color: Colors.red),
                          title: Text(limitation['key']),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, size: 18),
                            onPressed: () {
                              setState(() {
                                _limitations.remove(limitation);
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),

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
                              _limitations.add({'key': _limitationController.text, 'value': true});
                              _limitationController.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Actions
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
                          onPressed: () => _savePlan(),
                          child: Text(widget.plan == null ? 'Create Plan' : 'Update Plan'),
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

  Future<void> _savePlan() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final plan = SubscriptionPlan(
        id: widget.plan?.id,
        planCode: widget.plan?.planCode ?? 'PLAN-${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        billingCycle: _billingCycle,
        maxStudents: _maxStudentsController.text.isNotEmpty
            ? int.tryParse(_maxStudentsController.text)
            : null,
        maxBuses: _maxBusesController.text.isNotEmpty
            ? int.tryParse(_maxBusesController.text)
            : null,
        features: _features.isNotEmpty
            ? {for (var f in _features) f['key']: f['value']}
            : null,
        limitations: _limitations.isNotEmpty
            ? {for (var l in _limitations) l['key']: l['value']}
            : null,
        isActive: true,
        createdAt: widget.plan?.createdAt ?? DateTime.now(),
      );

      if (widget.onPlanCreated != null) {
        widget.onPlanCreated!(plan);
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.plan == null
                ? 'Plan created successfully'
                : 'Plan updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}