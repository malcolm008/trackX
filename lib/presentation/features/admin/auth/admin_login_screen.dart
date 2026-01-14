import 'package:bustracker_007/presentation/features/admin/admin_home.dart';
import 'package:bustracker_007/presentation/features/admin/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _twoFAController = TextEditingController();
  bool _showTwoFA = false;
  bool _rememberMe = false;

  void _handleLogin() {
    if (!_showTwoFA) {
      // First step: username/password
      setState(() {
        _showTwoFA = true;
      });
    } else {
      // Second step: 2FA verification
      // Navigate to admin home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1024;
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      body: isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Left panel - Branding
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Theme.of(context).colorScheme.primary,
                  Colors.black.withOpacity(0.1),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings,
                      size: 60,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'TrackX Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Complete Management System',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Wrap(
                    spacing: 24,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      FeatureChip(icon: Icons.security, text: 'Secure'),
                      FeatureChip(icon: Icons.analytics, text: 'Analytics'),
                      FeatureChip(icon: Icons.cloud, text: 'Cloud'),
                      FeatureChip(icon: Icons.support, text: '24/7 Support'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Right panel - Login form
        Expanded(
          flex: 2,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _showTwoFA ? 'Two-Factor Authentication' : 'Admin Login',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _showTwoFA
                          ? 'Enter the verification code from your authenticator app'
                          : 'Sign in to access the admin panel',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 48),

                    if (!_showTwoFA) ...[
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value!;
                              });
                            },
                          ),
                          const Text('Remember this device'),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Forgot Password?'),
                          ),
                        ],
                      ),
                    ] else ...[
                      TextFormField(
                        controller: _twoFAController,
                        decoration: const InputDecoration(
                          labelText: '6-digit Code',
                          prefixIcon: Icon(Icons.security_outlined),
                          border: OutlineInputBorder(),
                          hintText: '000000',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          // Resend code
                        },
                        child: const Text('Resend Code'),
                      ),
                    ],

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(_showTwoFA ? 'Verify & Login' : 'Login'),
                      ),
                    ),

                    if (!_showTwoFA) ...[
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // SSO Login
                          },
                          icon: const Icon(Icons.security),
                          label: const Text('Login with SSO'),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    if (_showTwoFA)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _showTwoFA = false;
                          });
                        },
                        child: const Text('← Back to Login'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 768;

    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          children: [
            // Top panel - Branding
            Expanded(
              flex: isTablet ? 2 : 3,
              child: Container(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: isTablet ? 100 : 80,
                      height: isTablet ? 100 : 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
                      ),
                      child: Icon(
                        Icons.admin_panel_settings,
                        size: isTablet ? 50 : 40,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'School Transport Admin',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 28 : 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Complete Management System',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        FeatureChip(icon: Icons.security, text: 'Secure'),
                        FeatureChip(icon: Icons.analytics, text: 'Analytics'),
                        FeatureChip(icon: Icons.cloud, text: 'Cloud'),
                        FeatureChip(icon: Icons.support, text: '24/7 Support'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bottom panel - Login form
            Expanded(
              flex: isTablet ? 3 : 4,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(isTablet ? 40 : 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _showTwoFA ? 'Two-Factor Authentication' : 'Admin Login',
                        style: TextStyle(
                          fontSize: isTablet ? 28 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _showTwoFA
                            ? 'Enter the verification code from your authenticator app'
                            : 'Sign in to access the admin panel',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 13,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 32),

                      if (!_showTwoFA) ...[
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                            const Text('Remember this device'),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Forgot?'),
                            ),
                          ],
                        ),
                      ] else ...[
                        TextFormField(
                          controller: _twoFAController,
                          decoration: const InputDecoration(
                            labelText: '6-digit Code',
                            prefixIcon: Icon(Icons.security_outlined),
                            border: OutlineInputBorder(),
                            hintText: '000000',
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            // Resend code
                          },
                          child: const Text('Resend Code'),
                        ),
                      ],

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(_showTwoFA ? 'Verify & Login' : 'Login'),
                        ),
                      ),

                      if (!_showTwoFA) ...[
                        const SizedBox(height: 28),
                        const Divider(),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // SSO Login
                            },
                            icon: const Icon(Icons.security),
                            label: const Text('Login with SSO'),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      if (_showTwoFA)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showTwoFA = false;
                            });
                          },
                          child: const Text('← Back to Login'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureChip({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      avatar: Icon(icon, size: 18),
      backgroundColor: Colors.white.withOpacity(0.1),
      labelStyle: const TextStyle(color: Colors.grey),
    );
  }
}