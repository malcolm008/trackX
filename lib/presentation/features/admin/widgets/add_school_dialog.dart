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
  List<School> _availableSchools = []; // Extracted unique schools from subscriptions
  School? _selectedSchool;
  bool _isLoading = false;

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
      _selectedSchool = school;
    }

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load subscriptions to get schools from them
      final subscriptions = await _apiService.getSubscriptions();
      setState(() {
        _subscriptions = subscriptions;

        // Extract unique schools from subscriptions
        final Map<String, School> uniqueSchools = {};
        for (final subscription in subscriptions) {
          if (!uniqueSchools.containsKey(subscription.schoolCode)) {
            uniqueSchools[subscription.schoolCode] = School(
              schoolCode: subscription.schoolCode,
              name: subscription.schoolName,
              email: subscription.schoolEmail ?? '',
              phone: subscription.schoolPhone ?? '',
              address: subscription.schoolAddress ?? '',
              totalStudents: subscription.totalStudents,
              totalBuses: subscription.totalBuses,
              createdAt: subscription.createdAt,
              updatedAt: DateTime.now(),
            );
          }
        }
        _availableSchools = uniqueSchools.values.toList();

        // If we're adding a new school and have schools available, select the first one
        if (widget.school == null && _availableSchools.isNotEmpty) {
          _selectedSchool = _availableSchools.first;
          _populateFieldsFromSelectedSchool();
        }
      });
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _populateFieldsFromSelectedSchool() {
    if (_selectedSchool != null) {
      final school = _selectedSchool!;
      setState(() {
        _nameController.text = school.name;
        _emailController.text = school.email;
        _phoneController.text = school.phone ?? '';
        _addressController.text = school.address ?? '';
        _cityController.text = school.city ?? '';
        _countryController.text = school.country ?? '';
        _contactPersonController.text = school.contactPerson ?? '';
        _studentsController.text = school.totalStudents.toString();
        _busesController.text = school.totalBuses.toString();
        _status = school.status;
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
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

                // SCHOOL NAME DROPDOWN (FETCHED FROM SUBSCRIPTIONS)
                if (widget.school == null && _availableSchools.isNotEmpty) ...[
                  DropdownButtonFormField<School>(
                    decoration: const InputDecoration(
                      labelText: 'Select School from Subscriptions *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                    value: _selectedSchool,
                    items: _availableSchools.map((school) {
                      return DropdownMenuItem<School>(
                        value: school,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(school.name),
                            Text(
                              '${school.schoolCode} • Students: ${school.totalStudents} • Buses: ${school.totalBuses}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (School? school) {
                      setState(() {
                        _selectedSchool = school;
                        if (school != null) {
                          _populateFieldsFromSelectedSchool();
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null) return 'Please select a school';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ] else if (widget.school == null && _availableSchools.isEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Text(
                      'No schools found in subscriptions. Please create a subscription first.',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // If editing an existing school, show text field instead
                if (widget.school != null) ...[
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
                  const SizedBox(height: 16),
                ],

                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 3,
                  children: [
                    // Email field
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
                    // Phone field
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // Contact Person field
                    TextFormField(
                      controller: _contactPersonController,
                      decoration: const InputDecoration(
                        labelText: 'Contact Person',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // Address field
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // City field
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // Country field
                    TextFormField(
                      controller: _countryController,
                      decoration: const InputDecoration(
                        labelText: 'Country',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    // Status dropdown
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
                    // Students field (auto-populated, read-only)
                    TextFormField(
                      controller: _studentsController,
                      decoration: const InputDecoration(
                        labelText: 'Total Students',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      readOnly: widget.school == null && _availableSchools.isNotEmpty,
                    ),
                    // Buses field (auto-populated, read-only)
                    TextFormField(
                      controller: _busesController,
                      decoration: const InputDecoration(
                        labelText: 'Total Buses',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      readOnly: widget.school == null && _availableSchools.isNotEmpty,
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