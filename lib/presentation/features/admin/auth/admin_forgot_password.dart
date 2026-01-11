import 'package:flutter/material.dart';

class AdminForgotPasswordScreen extends StatefulWidget {
  const AdminForgotPasswordScreen({super.key});

  @override
  State<AdminForgotPasswordScreen> createState() => _AdminForgotPasswordScreenState();
}

class _AdminForgotPasswordScreenState extends State<AdminForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _securityQuestionsController = TextEditingController();
  final _newPasswordController = TextEditingController();

  int _currentStep = 0;
  final List<String> _securityQuestions = [
    'What is your mother\'s maiden name?',
    'What was the name of your first pet?',
    'What city were you born in?',
  ];
  String _selectedQuestion = 'What is your mother\'s maiden name?';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Password Recovery'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(32),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Admin Password Recovery',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentStep == 0
                        ? 'Enter your admin email address'
                        : _currentStep == 1
                        ? 'Answer your security question'
                        : 'Set your new password',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Step indicator
                  Row(
                    children: [
                      _buildStepIndicator(0, 'Email'),
                      _buildStepDivider(),
                      _buildStepIndicator(1, 'Security'),
                      _buildStepDivider(),
                      _buildStepIndicator(2, 'Password'),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Step content
                  if (_currentStep == 0) ...[
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Admin Email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ] else if (_currentStep == 1) ...[
                    DropdownButtonFormField<String>(
                      value: _selectedQuestion,
                      decoration: const InputDecoration(
                        labelText: 'Security Question',
                        prefixIcon: Icon(Icons.help_outline),
                        border: OutlineInputBorder(),
                      ),
                      items: _securityQuestions.map((question) {
                        return DropdownMenuItem(
                          value: question,
                          child: Text(question),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedQuestion = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _securityQuestionsController,
                      decoration: const InputDecoration(
                        labelText: 'Your Answer',
                        prefixIcon: Icon(Icons.question_answer_outlined),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                  ] else ...[
                    TextFormField(
                      controller: _newPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'New Password',
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                        hintText: 'Minimum 12 characters with special characters',
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Password must contain:',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    _buildPasswordRequirement('At least 12 characters', true),
                    _buildPasswordRequirement('One uppercase letter', false),
                    _buildPasswordRequirement('One lowercase letter', false),
                    _buildPasswordRequirement('One number', false),
                    _buildPasswordRequirement('One special character', false),
                  ],

                  const SizedBox(height: 32),

                  Row(
                    children: [
                      if (_currentStep > 0)
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _currentStep--;
                            });
                          },
                          child: const Text('Back'),
                        ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (_currentStep < 2) {
                            setState(() {
                              _currentStep++;
                            });
                          } else {
                            // Complete password reset
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password reset successfully'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Text(_currentStep == 2 ? 'Reset Password' : 'Continue'),
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

  Widget _buildStepIndicator(int step, String label) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _currentStep >= step
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                color: _currentStep >= step ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontWeight: _currentStep >= step ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Expanded(
      child: Divider(
        thickness: 2,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildPasswordRequirement(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.circle_outlined,
            color: isMet ? Colors.green : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isMet ? Colors.green : Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}