import 'package:flutter/material.dart';
import '../auth_layout.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _otpSent = false;
  bool _otpVerified = false;
  int _resendTimer = 60;

  @override
  void initState() {
    super.initState();
    // Start resend timer if OTP is sent
    _startResendTimer();
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendTimer > 0) {
        setState(() => _resendTimer--);
        _startResendTimer();
      }
    });
  }

  void _sendOTP() {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        _otpSent = true;
        _resendTimer = 60;
      });
      _startResendTimer();
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent to your email'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _verifyOTP() {
    if (_otpController.text.isNotEmpty) {
      setState(() {
        _otpVerified = true;
      });
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP verified successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _resetPassword() {
    if (_newPasswordController.text == _confirmPasswordController.text) {
      // Show success message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Reset Password',
      subtitle: _otpVerified
          ? 'Enter your new password'
          : _otpSent
          ? 'Enter the OTP sent to your email'
          : 'Enter your email to reset password',
      child: Column(
        children: [
          if (!_otpSent) ...[
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _sendOTP,
                child: const Text('Send OTP'),
              ),
            ),
          ] else if (!_otpVerified) ...[
            TextFormField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: 'OTP',
                prefixIcon: Icon(Icons.lock_clock_outlined),
                hintText: 'Enter 6-digit code',
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _resendTimer > 0
                      ? 'Resend OTP in $_resendTimer seconds'
                      : 'Didn\'t receive OTP?',
                  style: const TextStyle(fontSize: 14),
                ),
                TextButton(
                  onPressed: _resendTimer == 0 ? _sendOTP : null,
                  child: const Text('Resend OTP'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verifyOTP,
                child: const Text('Verify OTP'),
              ),
            ),
          ] else ...[
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: Icon(Icons.lock_reset_outlined),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _resetPassword,
                child: const Text('Reset Password'),
              ),
            ),
          ],
          const SizedBox(height: 32),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }
}