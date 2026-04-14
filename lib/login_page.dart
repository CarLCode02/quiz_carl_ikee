import 'package:flutter/material.dart';

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage()));
}

BoxDecoration get _gradientBg => const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF1a3a2a), kGreen, Color(0xFF5ab87a)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );

Widget _buildLogo() {
  return Column(
    children: [
      Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8)),
          ],
        ),
        child: const Icon(Icons.quiz_rounded, size: 48, color: kGold),
      ),
      const SizedBox(height: 12),
      const Text('Quiz App',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
      const Text('Test your knowledge',
          style: TextStyle(fontSize: 13, color: Colors.white70)),
    ],
  );
}

InputDecoration _fieldDecoration(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: kGreen),
    filled: true,
    fillColor: const Color(0xFFF0FAF4),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kGreen, width: 2)),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _username = TextEditingController();
  final _password = TextEditingController();

  void _login() {
    if (_username.text == 'admin' && _password.text == 'password123') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Login successful!')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Wrong credentials')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _gradientBg,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildLogo(),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Welcome back 👋',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F1F14))),
                        const SizedBox(height: 4),
                        const Text('Sign in to your account',
                            style: TextStyle(fontSize: 13, color: Colors.black45)),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _username,
                          decoration: _fieldDecoration('Username', Icons.person_outline_rounded),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _password,
                          obscureText: true,
                          decoration: _fieldDecoration('Password', Icons.lock_outline_rounded),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kGold,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Login',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? ",
                                style: TextStyle(color: Colors.black54)),
                            GestureDetector(
                              onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const RegisterPage())),
                              child: const Text('Register',
                                  style: TextStyle(color: kGreen, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  void _register() {
    if (_password.text != _confirm.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Account created!')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: _gradientBg,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildLogo(),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Create account ✨',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F1F14))),
                        const SizedBox(height: 4),
                        const Text('Fill in the details below',
                            style: TextStyle(fontSize: 13, color: Colors.black45)),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _name,
                          decoration: _fieldDecoration('Full Name', Icons.badge_outlined),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _username,
                          decoration: _fieldDecoration('Username', Icons.person_outline_rounded),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _password,
                          obscureText: true,
                          decoration: _fieldDecoration('Password', Icons.lock_outline_rounded),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _confirm,
                          obscureText: true,
                          decoration: _fieldDecoration('Confirm Password', Icons.lock_outline_rounded),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Create Account',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account? ',
                                style: TextStyle(color: Colors.black54)),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text('Login',
                                  style: TextStyle(color: kGold, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
