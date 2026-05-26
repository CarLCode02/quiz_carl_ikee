import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizcarl_ikee/about_page.dart';
import 'package:quizcarl_ikee/admin/admin_dashboard.dart';
import 'package:quizcarl_ikee/login_page.dart';
import 'package:quizcarl_ikee/profile_page.dart';
import 'package:quizcarl_ikee/quiz_list_page.dart';

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);

class Landingpage extends StatefulWidget {
  const Landingpage({super.key});

  @override
  State<Landingpage> createState() => _LandingpageState();
}

class _LandingpageState extends State<Landingpage> {
  // needed to open drawer on phones
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    // landscapeing na habang lumiliit nagkaka hamburger,
    // so switch to hamburger drawer earlier
    final isPhone = w < 900;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      key: _scaffoldKey,
      // drawer only appears on phones palit sa nav links
      drawer: isPhone ? _MobileDrawer() : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a3a2a), kGreen],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Nav bar
              _buildNav(context, w, isPhone),

              const Divider(
                color: Colors.black,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),

              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: isLandscape ? 24 : 60),

                      // wrapping title
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: isPhone ? 16 : 32),
                        child: Text(
                          'BRGHGMC\n Examination Portal',
                          style: GoogleFonts.inter(
                            fontSize: w < 400
                                ? 38
                                : w < 600
                                    ? 48
                                    : w < 900
                                        ? 72
                                        : 100,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFF4F3EA),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // subtitle — scales font size
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: isPhone ? 16 : 32),
                        child: Text(
                          'Professional Education, Training and Research Unit (PETRU)',
                          style: GoogleFonts.inter(
                            fontSize: isPhone ? 13 : w < 900 ? 16 : 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFF4F3EA),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: isLandscape ? 24 : 60),

                      // wrpped na button
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 0,
                        runSpacing: 12,
                        children: [
                          _goldButton(
                            label: "I'm a Examinee",
                            onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const QuizListPage())),
                            margin: EdgeInsets.all(isPhone ? 10 : 20),
                            padding: EdgeInsets.all(isPhone ? 12 : 16),
                          ),
                          _goldButton(
                            label: "I'm a Test Administrator",
                             onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AdminDashboard())),
                            margin: EdgeInsets.all(isPhone ? 10 : 20),
                            padding: EdgeInsets.all(isPhone ? 12 : 16),
                          ),
                        ],
                      ),

                      SizedBox(height: isLandscape ? 24 : 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Nav bar 

  Widget _buildNav(BuildContext context, double w, bool isPhone) {
    // logo shrink para amg kasya nava bars
    final logoSize = w < 1000 ? 64.0 : 95.0;

    return Container(
      padding: EdgeInsets.all(isPhone ? 4 : 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
// logo still same sa size
          Container(
            margin: EdgeInsets.only(left: isPhone ? 8 : 15),
            child: Image.asset(
              'assets/BRGHGMC.png',
              height: isPhone ? 56 : logoSize,
              width: isPhone ? 56 : logoSize,
              errorBuilder: (_, __, ___) => Icon(Icons.local_hospital_rounded,
                  color: kGold, size: isPhone ? 40 : logoSize * 0.75),
            ),
          ),

          if (!isPhone)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _navButton(context, 'Quizes', () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const QuizListPage()))),
                  _navButton(context, 'Profile', () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()))),
                  _navButton(context, 'About', () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AboutPage()))),
                ],
              ),
            ),

          if (isPhone)
            IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _goldButton(
                  label: 'Register',
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const RegisterPage())),
                  margin: EdgeInsets.zero,
                  padding: const EdgeInsets.all(16),
                ),
                _goldButton(
                  label: 'Login',
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const LoginPage())),
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: IconButton(
                    icon: const Icon(Icons.account_circle),
                    iconSize: 43,
                    color: const Color(0xFFFFECEC),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ProfilePage())),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _navButton(BuildContext context, String label, VoidCallback onTap) {
    return TextButton(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      onPressed: onTap,
      child: Text(label,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Widget _goldButton({
    required String label,
    required VoidCallback onTap,
    required EdgeInsets margin,
    required EdgeInsets padding,
  }) {
    return Container(
      margin: margin,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: padding,
          backgroundColor: kGold,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero),
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

// Mobile drawer su sa burger

class _MobileDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1a3a2a),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Image.asset('assets/BRGHGMC.png',
                  height: 60,
                  errorBuilder: (_, __, ___) => const Icon(
                      Icons.local_hospital_rounded,
                      color: kGold,
                      size: 48)),
            ),
            const Divider(color: Colors.white24),
            _tile(context, 'Quizes', Icons.eco_outlined, () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const QuizListPage()));
            }),
            _tile(context, 'About', Icons.info_outline_rounded, () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AboutPage()));
            }),
            const Divider(color: Colors.white24),
            _tile(context, 'Register', Icons.person_add_outlined, () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()));
            }),
            _tile(context, 'Login', Icons.login_rounded, () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LoginPage()));
            }),
            _tile(context, 'Profile', Icons.account_circle_outlined, () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, String label, IconData icon,
      VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 20),
      title: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 14)),
      onTap: onTap,
    );
  }
}
