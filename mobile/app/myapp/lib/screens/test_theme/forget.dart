import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int step = 1;

  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String error = '';
  String success = '';

  void nextStep() {
    setState(() {
      error = '';
      success = '';
      step++;
    });
  }

  void prevStep() {
    setState(() {
      error = '';
      success = '';
      step--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: 380,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF020617),
                  Color(0xFF020617),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(.25),
                  blurRadius: 40,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _icon(),
                  const SizedBox(height: 16),
                  Text(
                    _title(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _description(),
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  if (error.isNotEmpty) _alert(error, Colors.red),
                  if (success.isNotEmpty) _alert(success, Colors.green),

                  if (step == 1) _emailStep(),
                  if (step == 2) _codeStep(),
                  if (step == 3) _passwordStep(),

                  const SizedBox(height: 16),
                  Text(
                    _footer(),
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _icon() {
    IconData icon =
        step == 1 ? Icons.email : step == 2 ? Icons.key : Icons.lock;

    return Container(
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.blue, Colors.cyan],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(icon, color: Colors.white, size: 40),
    );
  }

  Widget _alert(String msg, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(msg, style: TextStyle(color: color)),
    );
  }

  Widget _emailStep() {
    return Column(
      children: [
        _input(emailController, 'Email address', Icons.email),
        const SizedBox(height: 16),
        _primaryButton('Send verification code', () {
          if (!emailController.text.contains('@')) {
            setState(() => error = 'Invalid email address');
            return;
          }
          setState(() => success = 'Verification code sent!');
          Future.delayed(const Duration(seconds: 1), nextStep);
        }),
      ],
    );
  }

  Widget _codeStep() {
    return Column(
      children: [
        _input(codeController, '8-digit code', Icons.key, maxLength: 8),
        const SizedBox(height: 16),
        _primaryButton('Verify code', nextStep),
        _secondaryButton('Back', prevStep),
      ],
    );
  }

  Widget _passwordStep() {
    return Column(
      children: [
        _input(passwordController, 'New password', Icons.lock,
            obscure: true),
        const SizedBox(height: 12),
        _input(confirmPasswordController, 'Confirm password', Icons.lock,
            obscure: true),
        const SizedBox(height: 16),
        _primaryButton('Reset password', () {
          if (passwordController.text !=
              confirmPasswordController.text) {
            setState(() => error = 'Passwords do not match');
            return;
          }
          setState(() => success = 'Password reset successfully');
        }),
        _secondaryButton('Back', prevStep),
      ],
    );
  }

  Widget _input(TextEditingController controller, String hint, IconData icon,
      {bool obscure = false, int? maxLength}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      maxLength: maxLength,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        counterText: '',
        prefixIcon: Icon(icon, color: Colors.white54),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white.withOpacity(.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _primaryButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.blue, Colors.cyan],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(text,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _secondaryButton(String text, VoidCallback onTap) {
    return TextButton(onPressed: onTap, child: Text(text));
  }

  String _title() =>
      step == 1 ? 'Reset Password' : step == 2 ? 'Verify Code' : 'New Password';

  String _description() => step == 1
      ? 'Enter your email to receive a code'
      : step == 2
          ? 'Enter the verification code'
          : 'Create a strong new password';

  String _footer() => step == 1
      ? 'You will receive a verification code'
      : step == 2
          ? 'Code expires in 10 minutes'
          : 'Your password will be reset securely';
}