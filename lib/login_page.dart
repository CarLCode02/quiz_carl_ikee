import 'package:flutter/material.dart';
import 'package:quizcarl_ikee/homepage/landingpage.dart';


const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage()));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;


  late final AnimationController _entryCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _logoScaleAnim;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeAnim = CurvedAnimation(
        parent: _entryCtrl, curve: const Interval(0.0, 0.6, curve: Curves.easeOut));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.35), end: Offset.zero).animate(
        CurvedAnimation(
            parent: _entryCtrl,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic)));
    _logoScaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _entryCtrl,
            curve: const Interval(0.0, 0.5, curve: Curves.elasticOut)));
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }


 
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final hPad = w > 600 ? w * 0.22 : 24.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1a3a2a), kGreen, Color(0xFF5ab87a)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 32),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    ScaleTransition(
                      scale: _logoScaleAnim,
                      child: _buildLogo(),
                    ),
                    const SizedBox(height: 32),
                    SlideTransition(
                      position: _slideAnim,
                      child: _buildCard(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: kGreen.withOpacity(0.3),
                  blurRadius: 28,
                  offset: const Offset(0, 10)),
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/BRGHGMC.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: kGreen,
                child: const Icon(Icons.quiz_rounded, size: 48, color: kGold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text('BRGHGMC Examination Portal',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.3)),
        const SizedBox(height: 4),
        const Text('Test your knowledge',
            style: TextStyle(fontSize: 13, color: Colors.white70)),
      ],
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 40,
              offset: const Offset(0, 16)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Welcome back ',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F1F14))),
            const SizedBox(height: 6),
            const Text('Sign in to your account',
                style: TextStyle(fontSize: 13.5, color: Colors.black45)),
            const SizedBox(height: 28),
            GlowField(
              child: TextFormField(
                controller: _username,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Please enter your username' : null,
                decoration: _fieldDecoration('Username', Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 16),
            GlowField(
              child: TextFormField(
                controller: _password,
                obscureText: _obscure,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Please enter your password' : null,
                decoration: _fieldDecoration('Password', Icons.lock_outline_rounded).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: kGreen,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                    foregroundColor: kGreen, padding: EdgeInsets.zero),
                child: const Text('Forgot password?',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 52,
              child: ElevatedButton(

                 style: ElevatedButton.styleFrom(
                          
                          side: BorderSide(color: Colors.green.shade700),
                          backgroundColor: kGreen,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                 onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Landingpage(),
                    ),
                  );
                },
                
                child: const Text('Login ', style: TextStyle(color: Colors.white),),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade200)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('OR',
                      style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
                Expanded(child: Divider(color: Colors.grey.shade200)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?  ",
                    style: TextStyle(color: Colors.black54, fontSize: 13.5)),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 450),
                      pageBuilder: (_, __, ___) => const RegisterPage(),
                      transitionsBuilder: (_, anim, __, child) => SlideTransition(
                        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                        child: child,
                      ),
                    ),
                  ),
                  child: const Text('Register',
                      style: TextStyle(
                          color: kGreen, fontWeight: FontWeight.w700, fontSize: 13.5)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: kGreen, size: 20),
      filled: true,
      fillColor: const Color(0xFFF7F8FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.2)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kGreen, width: 1.8)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.8)),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  late final AnimationController _entryCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _logoScaleAnim;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim = CurvedAnimation(
        parent: _entryCtrl, curve: const Interval(0.0, 0.6, curve: Curves.easeOut));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
        CurvedAnimation(
            parent: _entryCtrl,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic)));
    _logoScaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _entryCtrl,
            curve: const Interval(0.0, 0.5, curve: Curves.elasticOut)));
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _name.dispose();
    _username.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: kGreen,
      content: const Row(children: [
        Icon(Icons.check_circle_outline_rounded, color: Colors.white, size: 20),
        SizedBox(width: 10),
        Text('Account created! Please login.',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      ]),
    ));

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, __, ___) => const LoginPage(),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final hPad = w > 600 ? w * 0.22 : 24.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1a3a2a), kGreen, Color(0xFF5ab87a)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 32),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    ScaleTransition(
                      scale: _logoScaleAnim,
                      child: _buildLogo(),
                    ),
                    const SizedBox(height: 32),
                    SlideTransition(
                      position: _slideAnim,
                      child: _buildCard(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: kGreen.withOpacity(0.3),
                  blurRadius: 28,
                  offset: const Offset(0, 10)),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/BRGHGMC.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: kGreen,
                child: const Icon(Icons.quiz_rounded, size: 48, color: kGold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text('Quiz App',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.3)),
        const SizedBox(height: 4),
        const Text('Test your knowledge',
            style: TextStyle(fontSize: 13, color: Colors.white70)),
      ],
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 40,
              offset: const Offset(0, 16)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Create account ',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F1F14))),
            const SizedBox(height: 6),
            const Text('Fill in the details below to get started',
                style: TextStyle(fontSize: 13.5, color: Colors.black45)),
            const SizedBox(height: 28),
            GlowField(
              child: TextFormField(
                controller: _name,
                validator: (v) => (v == null || v.isEmpty) ? 'Enter your name' : null,
                decoration: _fieldDecoration('Full Name', Icons.badge_outlined),
              ),
            ),
            const SizedBox(height: 16),
            GlowField(
              child: TextFormField(
                controller: _username,
                validator: (v) => (v == null || v.isEmpty) ? 'Enter a username' : null,
                decoration: _fieldDecoration('Username', Icons.person_outline_rounded),
              ),
            ),
            const SizedBox(height: 16),
            GlowField(
              child: TextFormField(
                controller: _password,
                obscureText: _obscurePass,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter a password';
                  if (v.length < 6) return 'Minimum 6 characters';
                  return null;
                },
                decoration: _fieldDecoration('Password', Icons.lock_outline_rounded).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: kGreen,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePass = !_obscurePass),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GlowField(
              child: TextFormField(
                controller: _confirm,
                obscureText: _obscureConfirm,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Confirm your password';
                  if (v != _password.text) return 'Passwords do not match';
                  return null;
                },
                decoration:
                    _fieldDecoration('Confirm Password', Icons.lock_outline_rounded).copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: kGreen,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  disabledBackgroundColor: kGreen.withOpacity(0.7),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                    : const Text('Create Account'),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?  ',
                    style: TextStyle(color: Colors.black54, fontSize: 13.5)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Login',
                      style: TextStyle(
                          color: kGold, fontWeight: FontWeight.w700, fontSize: 13.5)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: kGreen, size: 20),
      filled: true,
      fillColor: const Color(0xFFF7F8FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.2)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kGreen, width: 1.8)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.8)),
    );
  }
}

class GlowField extends StatefulWidget {
  final Widget child;
  const GlowField({super.key, required this.child});
  @override
  State<GlowField> createState() => _GlowFieldState();
}

class _GlowFieldState extends State<GlowField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (v) => setState(() => _focused = v),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: _focused
              ? [BoxShadow(
                  color: kGreen.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4))]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}
