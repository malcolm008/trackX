import 'package:flutter/material.dart';
import 'package:bustracker_007/data/models/web/school/school_model.dart';
import 'package:bustracker_007/core/services/api_service.dart';

class EditSchoolDialog extends StatefulWidget {
  final School school;
  final ApiService apiService;
  final Function(School) onSchoolUpdated;
  final Function() onRefreshData;

  const EditSchoolDialog({
    Key? key,
    required this.school,
    required this.apiService,
    required this.onSchoolUpdated,
    required this.onRefreshData,
  }) : super(key: key);

  @override
  _EditSchoolDialogState createState() => _EditSchoolDialogState();
}

class _EditSchoolDialogState extends State<EditSchoolDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _contactPersonController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _studentsController;
  late TextEditingController _busesController;

  late String _selectedStatus;
  late String _selectedSubscription;
  bool _isSubmitting = false;

  // Parse address into components
  void _parseAddress(String address) {
    final parts = address.split(',');
    if (parts.length >= 3) {
      _addressController.text = parts[0].trim();
      _cityController.text = parts[1].trim();
      _countryController.text = parts[2].trim();
    } else {
      _addressController.text = address;
    }
  }

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing school data
    _nameController = TextEditingController(text: widget.school.name);
    _emailController = TextEditingController(text: widget.school.email);
    _phoneController = TextEditingController(text: widget.school.phone);
    _contactPersonController = TextEditingController(); // Not in model yet
    _studentsController = TextEditingController(text: widget.school.students.toString());
    _busesController = TextEditingController(text: widget.school.buses.toString());

    // Address components
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _countryController = TextEditingController();

    _parseAddress(widget.school.address);

    // Dropdown values
    _selectedStatus = widget.school.status;
    _selectedSubscription = widget.school.subscription;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _contactPersonController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _studentsController.dispose();
    _busesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        // Create updated school object
        final updatedSchool = widget.school.copyWith(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          address: '${_addressController.text.trim()}, ${_cityController.text.trim()}, ${_countryController.text.trim()}',
          students: int.parse(_studentsController.text),
          buses: int.parse(_busesController.text),
          status: _selectedStatus,
          subscription: _selectedSubscription,
          updatedAt: DateTime.now(),
        );

        // Call API to update school
        final success = await widget.apiService.updateSchool(updatedSchool);

        if (success) {
          // Callback to parent
          widget.onSchoolUpdated(updatedSchool);
          widget.onRefreshData();

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('School updated successfully'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          throw Exception('Failed to update school');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildFormFields(),
                  ),
                ),
                const SizedBox(height: 24),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit School',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.school.schoolId,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 3,
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'School Name *',
          icon: Icons.school,
          validator: (value) => value!.isEmpty ? 'Required' : null,
        ),
        _buildTextField(
          controller: _emailController,
          label: 'Email *',
          icon: Icons.email,
          validator: (value) {
            if (value!.isEmpty) return 'Required';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Invalid email';
            }
            return null;
          },
        ),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone *',
          icon: Icons.phone,
          validator: (value) => value!.isEmpty ? 'Required' : null,
        ),
        _buildTextField(
          controller: _contactPersonController,
          label: 'Contact Person',
          icon: Icons.person,
        ),
        _buildTextField(
          controller: _addressController,
          label: 'Address *',
          icon: Icons.location_on,
          maxLines: 2,
          validator: (value) => value!.isEmpty ? 'Required' : null,
        ),
        _buildTextField(
          controller: _cityController,
          label: 'City *',
          icon: Icons.location_city,
          validator: (value) => value!.isEmpty ? 'Required' : null,
        ),
        _buildTextField(
          controller: _countryController,
          label: 'Country *',
          icon: Icons.public,
          validator: (value) => value!.isEmpty ? 'Required' : null,
        ),
        _buildStatusDropdown(),
        _buildSubscriptionDropdown(),
        _buildNumberField(
          controller: _studentsController,
          label: 'Number of Students',
          icon: Icons.people,
        ),
        _buildNumberField(
          controller: _busesController,
          label: 'Number of Buses',
          icon: Icons.directions_bus,
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedStatus,
      decoration: const InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.circle),
      ),
      items: [
        DropdownMenuItem(
          value: 'active',
          child: Row(
            children: [
              Icon(Icons.circle, size: 12, color: Colors.green),
              const SizedBox(width: 8),
              const Text('Active'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'trial',
          child: Row(
            children: [
              Icon(Icons.circle, size: 12, color: Colors.orange),
              const SizedBox(width: 8),
              const Text('Trial'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'expiring',
          child: Row(
            children: [
              Icon(Icons.circle, size: 12, color: Colors.yellow[700]),
              const SizedBox(width: 8),
              const Text('Expiring'),
            ],
          ),
        ),
        DropdownMenuItem(
          value: 'inactive',
          child: Row(
            children: [
              Icon(Icons.circle, size: 12, color: Colors.red),
              const SizedBox(width: 8),
              const Text('Inactive'),
            ],
          ),
        ),
      ],
      onChanged: _isSubmitting ? null : (value) {
        if (value != null) {
          setState(() {
            _selectedStatus = value;
          });
        }
      },
    );
  }

  Widget _buildSubscriptionDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedSubscription,
      decoration: const InputDecoration(
        labelText: 'Subscription Plan *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.subscriptions),
      ),
      items: ['Basic', 'Premium', 'Enterprise', 'Trial']
          .map((plan) => DropdownMenuItem(
        value: plan,
        child: Text(plan),
      ))
          .toList(),
      validator: (value) => value == null ? 'Required' : null,
      onChanged: _isSubmitting ? null : (value) {
        if (value != null) {
          setState(() {
            _selectedSubscription = value;
          });
        }
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        alignLabelWithHint: maxLines > 1,
      ),
      validator: validator,
      enabled: !_isSubmitting,
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Required';
        final int? number = int.tryParse(value);
        if (number == null || number < 0) return 'Invalid number';
        return null;
      },
      enabled: !_isSubmitting,
    );
  }

  Widget _buildFooter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.info, size: 16, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Fields marked with * are required',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.calendar_today, size: 14, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              'Created: ${_formatDate(widget.school.createdAt)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (widget.school.updatedAt != null) ...[
              const SizedBox(width: 16),
              Icon(Icons.update, size: 14, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                'Updated: ${_formatDate(widget.school.updatedAt!)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.save, size: 18),
                    SizedBox(width: 8),
                    Text('Save Changes'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}