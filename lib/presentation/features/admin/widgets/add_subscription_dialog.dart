import 'package:flutter/material.dart';
import 'package:bustracker_007/data/models/web/school.dart';
import 'package:bustracker_007/data/models/web/subscription_plan.dart';
import 'package:bustracker_007/data/models/web/school_subscription.dart';

class AddSubscriptionDialog extends StatefulWidget {
  final List<School> schools;
  final List<SubscriptionPlan> plans;
  final SchoolSubscription? subscription;

  const AddSubscriptionDialog({
    super.key,
    required this.schools,
    required this.plans,
    this.subscription,
  });

  @override
  State<AddSubscriptionDialog> createState() => _AddSubscriptionDialogState();
}

class _AddSubscriptionDialogState extends State<AddSubscriptionDialog> {
  final _formKey = GlobalKey<FormState>();

  School? _selectedSchool;
  SubscriptionPlan? _selectedPlan;
  final TextEditingController _amountController = TextEditingController();
  String _status = 'active';
  bool _autoRenew = true;
  String? _paymentMethod;

  late DateTime _startDate;
  late DateTime _endDate;

  final List<String> _statuses = ['active', 'trial', 'pending', 'cancelled'];
  final List<String> _paymentMethods = ['Credit Card', 'Bank Transfer', 'Cash', 'Other'];

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(const Duration(days: 30));

    if (widget.subscription != null) {
      final subscription = widget.subscription!;
      _selectedSchool = widget.schools.firstWhere(
            (s) => s.id == subscription.schoolId,
        orElse: () => widget.schools.first,
      );
      _selectedPlan = widget.plans.firstWhere(
            (p) => p.id == subscription.planId,
        orElse: () => widget.plans.first,
      );
      _amountController.text = subscription.amount.toStringAsFixed(2);
      _status = subscription.status;
      _autoRenew = subscription.autoRenew;
      _paymentMethod = subscription.paymentMethod;
      _startDate = subscription.startDate;
      _endDate = subscription.endDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
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
                        widget.subscription == null
                            ? 'Add New Subscription'
                            : 'Edit Subscription',
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

                  // School Selection
                  DropdownButtonFormField<School>(
                    decoration: const InputDecoration(
                      labelText: 'Select School *',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedSchool,
                    items: widget.schools.map((school) {
                      return DropdownMenuItem(
                        value: school,
                        child: Text('${school.name} (${school.schoolCode})'),
                      );
                    }).toList(),
                    onChanged: (school) {
                      setState(() {
                        _selectedSchool = school;
                      });
                    },
                    validator: (value) {
                      if (value == null) return 'Please select a school';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Plan Selection
                  DropdownButtonFormField<SubscriptionPlan>(
                    decoration: const InputDecoration(
                      labelText: 'Select Plan *',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedPlan,
                    items: widget.plans.map((plan) {
                      return DropdownMenuItem(
                        value: plan,
                        child: Text('${plan.name} - \$${plan.price}/${plan.billingCycle}'),
                      );
                    }).toList(),
                    onChanged: (plan) {
                      setState(() {
                        _selectedPlan = plan;
                        if (plan != null) {
                          _amountController.text = plan.price.toStringAsFixed(2);
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null) return 'Please select a plan';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Amount
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount *',
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter amount';
                      if (double.tryParse(value) == null) return 'Please enter a valid amount';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Status
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    value: _status,
                    items: _statuses.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(_capitalize(status)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _status = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Dates
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, isStartDate: true),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Start Date',
                              border: OutlineInputBorder(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_formatDate(_startDate)),
                                const Icon(Icons.calendar_today, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectDate(context, isStartDate: false),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'End Date',
                              border: OutlineInputBorder(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_formatDate(_endDate)),
                                const Icon(Icons.calendar_today, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Auto Renew
                  CheckboxListTile(
                    title: const Text('Auto Renew'),
                    value: _autoRenew,
                    onChanged: (value) {
                      setState(() {
                        _autoRenew = value ?? true;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  // Payment Method
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Payment Method',
                      border: OutlineInputBorder(),
                    ),
                    value: _paymentMethod,
                    items: _paymentMethods.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value;
                      });
                    },
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
                          onPressed: _saveSubscription,
                          child: Text(widget.subscription == null
                              ? 'Create Subscription'
                              : 'Update Subscription'),
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

  Future<void> _selectDate(BuildContext context, {required bool isStartDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void _saveSubscription() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSchool == null || _selectedPlan == null) return;

    final subscription = SchoolSubscription(
      id: widget.subscription?.id,
      subscriptionCode: widget.subscription?.subscriptionCode
          ?? 'SUB-${DateTime.now().millisecondsSinceEpoch}',
      schoolId: _selectedSchool!.id!,
      planId: _selectedPlan!.id!,
      amount: double.parse(_amountController.text),
      status: _status,
      startDate: _startDate,
      endDate: _endDate,
      autoRenew: _autoRenew,
      paymentMethod: _paymentMethod,
      createdAt: widget.subscription?.createdAt ?? DateTime.now(),
    );

    Navigator.pop(context, subscription);
  }
}