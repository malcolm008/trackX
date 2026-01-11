import 'package:bustracker_007/presentation/features/driver/dashboard_screen.dart';
import 'package:bustracker_007/presentation/features/parent/screens/dashboard_screen.dart';
import 'package:bustracker_007/presentation/features/school_manager/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import '../auth_layout.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Common fields
  String _selectedRole = 'Parent';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();

  // Parent-specific fields
  final _childNameController = TextEditingController();
  final _childGradeController = TextEditingController();
  final _addressController = TextEditingController();

  // School Manager-specific fields
  final _schoolNameController = TextEditingController();
  final _schoolAddressController = TextEditingController();
  final _schoolPhoneController = TextEditingController();
  final _positionController = TextEditingController();

  // Driver-specific fields
  final _licenseNumberController = TextEditingController();
  final _experienceController = TextEditingController();
  final _vehicleTypeController = TextEditingController();
  final _emergencyContactController = TextEditingController();

  bool _termsAccepted = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> _roles = [
    'Parent',
    'School Manager',
    'Driver',
  ];

  Widget _buildParentFields() {
    return Column(
      children: [
        TextFormField(
          controller: _childNameController,
          decoration: const InputDecoration(
            labelText: 'Child\'s Full Name',
            prefixIcon: Icon(Icons.child_care_outlined),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter child\'s name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Child\'s Grade',
            prefixIcon: Icon(Icons.school_outlined),
          ),
          items: ['Pre-K', 'Kindergarten', 'Grade 1', 'Grade 2', 'Grade 3',
            'Grade 4', 'Grade 5', 'Grade 6', 'Grade 7', 'Grade 8',
            'Grade 9', 'Grade 10', 'Grade 11', 'Grade 12']
              .map((grade) => DropdownMenuItem(
            value: grade,
            child: Text(grade),
          ))
              .toList(),
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Home Address',
            prefixIcon: Icon(Icons.home_outlined),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildSchoolManagerFields() {
    return Column(
      children: [
        TextFormField(
          controller: _schoolNameController,
          decoration: const InputDecoration(
            labelText: 'School Name',
            prefixIcon: Icon(Icons.school_outlined),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter school name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _schoolAddressController,
          decoration: const InputDecoration(
            labelText: 'School Address',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
          maxLines: 2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter school address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _schoolPhoneController,
          decoration: const InputDecoration(
            labelText: 'School Phone',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _positionController,
          decoration: const InputDecoration(
            labelText: 'Your Position',
            prefixIcon: Icon(Icons.work_outline),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverFields() {
    return Column(
      children: [
        TextFormField(
          controller: _licenseNumberController,
          decoration: const InputDecoration(
            labelText: 'Driver\'s License Number',
            prefixIcon: Icon(Icons.card_membership_outlined),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter license number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _experienceController,
          decoration: const InputDecoration(
            labelText: 'Years of Experience',
            prefixIcon: Icon(Icons.timelapse_outlined),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Vehicle Type',
            prefixIcon: Icon(Icons.directions_bus_outlined),
          ),
          items: ['Mini Bus', 'Standard Bus', 'Large Bus', 'Van', 'Minivan']
              .map((type) => DropdownMenuItem(
            value: type,
            child: Text(type),
          ))
              .toList(),
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emergencyContactController,
          decoration: const InputDecoration(
            labelText: 'Emergency Contact',
            prefixIcon: Icon(Icons.emergency_outlined),
          ),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  void _submitRegistration() {
    if (_formKey.currentState!.validate() && _termsAccepted) {
      // Process registration based on role
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful for $_selectedRole'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to appropriate home screen
      switch (_selectedRole) {
        case 'Parent':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ParentHomeScreen()),
          );
          break;
        case 'School Manager':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SchoolManagerHome()),
          );
          break;
        case 'Driver':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DriverHomeScreen()),
          );
          break;
      }
    } else if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept terms and conditions'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Create Account',
      subtitle: 'Join our school transport system',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Register As',
                prefixIcon: Icon(Icons.person_add_outlined),
              ),
              items: _roles.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Common fields
            TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_reset_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Role-specific fields
            if (_selectedRole == 'Parent') _buildParentFields(),
            if (_selectedRole == 'School Manager') _buildSchoolManagerFields(),
            if (_selectedRole == 'Driver') _buildDriverFields(),

            const SizedBox(height: 24),

            // Terms and conditions
            Row(
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (value) {
                    setState(() {
                      _termsAccepted = value!;
                    });
                  },
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.grey[700],
                      ),
                      children: [
                        const TextSpan(text: 'I agree to the '),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitRegistration,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Create Account'),
              ),
            ),

            const SizedBox(height: 24),

            // Already have account
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Sign In'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}