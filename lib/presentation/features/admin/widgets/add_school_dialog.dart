import 'package:bustracker_007/data/models/web/school_subscription.dart';
import 'package:flutter/material.dart';
import 'package:bustracker_007/data/models/web/school.dart';
import 'package:bustracker_007/core/repositories/school_repository.dart';
import 'package:bustracker_007/core/services/api_service.dart';

class AddSchoolDialog extends StatefulWidget {
  final School? school;

  const AddSchoolDialog({super.key, this.school});

  @override
  State<AddSchoolDialog> createState() => _AddSchoolDialogState();
}

class _AddSchoolDialogState extends State<AddSchoolDialog> {
  final _formKey = GlobalKey<FormState>();
  final SchoolRepository _repository = SchoolRepository();
  final ApiService _apiService = ApiService();

  List<SchoolSubscription> _subscriptions = [];
  SchoolSubscription? _selectedSubscription;
  bool _isLoadingSubscriptions = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _contactPersonController;
  late TextEditingController _studentsController;
  late TextEditingController _busesController;

  String _status = 'active';
  final List<String> _statuses = ['active', 'inactive', 'trial', 'expiring'];

  @override
  void initState() {
    super.initState();
    final school = widget.school;

    _nameController = TextEditingController(text: school?.name ?? '');
    _emailController = TextEditingController(text: school?.email ?? '');
    _phoneController = TextEditingController(text: school?.phone ?? '');
    _addressController = TextEditingController(text: school?.address ?? '');
    _cityController = TextEditingController(text: school?.city ?? '');
    _countryController = TextEditingController(text: school?.country ?? '');
    _contactPersonController = TextEditingController(text: school?.contactPerson ?? '');
    _studentsController = TextEditingController(text: school?.totalStudents.toString() ?? '0');
    _busesController = TextEditingController(text: school?.totalBuses.toString() ?? '0');

    if (school != null) {
      _status = school.status;
    }

    _loadSubscriptions();
  }

  Future<void> _loadSubscriptions() async {
    setState(() {
      _isLoadingSubscriptions = true;
    });
    try {
      final subscriptions = await _apiService.getSubscriptions();
      setState(() {
        _subscriptions = subscriptions;
      });
    } catch (e) {
      print('Error loading subscriptions: $e');
    } finally {
      setState(() {
        _isLoadingSubscriptions = false;
      });
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.school == null ? 'Add New School' : 'Edit School',
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

                if (widget.school == null) ...[
                  _buildSubscriptionDropdown(),
                  const SizedBox(height: 16),
                ],

                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'School Name *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'School name is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        if (!value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      controller: _contactPersonController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Person',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      controller: _countryController,
                      decoration: const InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: _status,
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
                          _status = value!;
                        });
                      },
                    ),
                    TextFormField(
                      controller: _studentsController,
                      decoration: const InputDecoration(
                        labelText: 'Total Students',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      readOnly: widget.school == null,
                    ),
                    TextFormField(
                      controller: _busesController,
                      decoration: const InputDecoration(
                        labelText: 'Total Buses',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      readOnly: widget.school == null,
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _saveSchool();
                          }
                        },
                        child: Text(widget.school == null ? 'Add School' : 'Update School'),
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

  Widget _buildSubscriptionDropdown() {
    if (_isLoadingSubscriptions) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_subscriptions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange),
        ),
        child: const Text(
          'No existiing subscriptions found. Please create a subscription first.',
          style: TextStyle(color: Colors.orange),
        ),
      );
    }

    return DropdownButtonFormField<SchoolSubscription>(
      decoration: const InputDecoration(
        labelText: 'Copy from Existing Subscription *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.subscriptions),
        helperText: 'Select a subscription',
      ),
      value: _selectedSubscription,
      items: _subscriptions.map((subscription) {
        final school = subscription.school;
        return DropdownMenuItem<SchoolSubscription>(
          value: subscription,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(school?.name ?? 'Unknown School'),
              Text(
                'Subscription ID: ${subscription.subscriptionCode}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (SchoolSubscription? subscription) {
        setState(() {
          _selectedSubscription = subscription;
          if (subscription != null && subscription.school != null) {
            final school = subscription.school!;

            _nameController.text = school.name;
            _emailController.text = school.email;
            _phoneController.text = school.phone ?? '';
            _addressController.text = school.address ?? '';
            _studentsController.text = school.totalStudents.toString();
            _busesController.text = school.totalBuses.toString();
            _status = school.status;
          }
        });
      },
      validator: widget.school == null ? (value) {
        if (value == null) {
          return 'Please select a subscription to copy data from';
        }
        return null;
      } : null,
    );
  }

  Future<void> _saveSchool() async {
    try {
      int parseIntField(TextEditingController controller) =>
          int.tryParse(controller.text.trim()) ?? 0;

      final school = School(
        id: widget.school?.id,
        schoolCode: widget.school?.schoolCode ??
            'SCH-${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        address: _addressController.text.isNotEmpty ? _addressController.text : null,
        city: _cityController.text.isNotEmpty ? _cityController.text : null,
        country: _countryController.text.isNotEmpty ? _countryController.text : null,
        contactPerson:
        _contactPersonController.text.isNotEmpty ? _contactPersonController.text : null,
        totalStudents: parseIntField(_studentsController),
        totalBuses: parseIntField(_busesController),
        status: _status,
        createdAt: widget.school?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.school == null) {
        await _repository.createSchool(school);
      } else {
        await _repository.updateSchool(school.id!, school);
      }

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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