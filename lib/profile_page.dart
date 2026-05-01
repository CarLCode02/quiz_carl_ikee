import 'package:flutter/material.dart';
import 'package:quizcarl_ikee/login_page.dart';
import 'homepage/user_settings.dart';

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);
const Color kGreenDark = Color(0xFF2A6B43);
const Color kGreenLight = Color(0xFF56B87A);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: CustomScrollView(
        slivers: [
          // ── Gradient App Bar ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: kGreenDark,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.white),
                onPressed: (


                ) {

                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                  
                },
              ),
              const SizedBox(width: 4),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kGreenDark, kGreen, kGreenLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Decorative circles
                  Positioned(
                    top: -40,
                    right: -40,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: -30,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  // Avatar + name
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [ 
                        const SizedBox(height: 32),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: kGold, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundColor: Color(0xFF2A6B43),
                            backgroundImage: AssetImage('assets/me.png'),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Carl Lawrence S. Maranion',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '@Carllawrence',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                letterSpacing: 0.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ── Body ─────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                  child: Column(
                    children: [
                      // Stats card
                      _Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            _StatItem(label: 'Quizzes', value: '0',
                                icon: Icons.book),
                            _VertDivider(),
                            _StatItem(label: 'Score', value: '0',
                                icon: Icons.scoreboard),
                            _VertDivider(),
                            _StatItem(label: 'Rank', value: '#10',
                                icon: Icons.leaderboard),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Level / progress card
                      _Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('Level Progress',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15)),
                                Text('Level 0',
                                    style: TextStyle(
                                        color: kGreen,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Info card
                      _Card(
                        child: Column(
                          children: const [
                            _InfoRow(
                                icon: Icons.email_outlined,
                                label: 'Email',
                                value: 'Carl@gmal.com'),
                            Divider(height: 20, thickness: 0.8),
                            _InfoRow(
                                icon: Icons.home,
                                label: 'Office',
                                value: 'IT WorkShop2/IMIS'),
                                Divider(height: 20, thickness: 0.8),
                                 _InfoRow(
                                icon: Icons.person_2_rounded,
                                label: 'Designation',
                                value: 'IT Dev. Intern'),
                                Divider(height: 20, thickness: 0.8),
                            _InfoRow(
                                icon: Icons.calendar_today_outlined,
                                label: 'Member since',
                                value: 'April 2026'),
                            Divider(height: 20, thickness: 0.8),
                            _InfoRow(
                                icon: Icons.location_on_outlined,
                                label: 'Location',
                                value: 'Camarines Sur, Philippines'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Action buttons card
                      _Card(
                        child: Column(
                          children: [
                            _MenuTile(
                              icon: Icons.history_rounded,
                              label: 'Quiz History',
                              subtitle: 'View your past quizzes',
                              onTap: () {},
                            ),
                            const Divider(height: 1, thickness: 0.8),
                            _MenuTile(
                              icon: Icons.bar_chart_rounded,
                              label: 'Statistics',
                              subtitle: 'Detailed performance stats',
                              onTap: () {},
                            ),
                            const Divider(height: 1, thickness: 0.8),
                            _MenuTile(
                              icon: Icons.settings_outlined,
                              label: 'Settings',
                              subtitle: 'Account & preferences',
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const MyTry(),),);
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Logout
                      _Card(
                        child: _MenuTile(
                          icon: Icons.logout_rounded,
                          label: 'Logout',
                          subtitle: 'Sign out of your account',
                          iconColor: Colors.red.shade400,
                          labelColor: Colors.red.shade400,
                          onTap: () {
                             Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                          },
                          showArrow: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable widgets ────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatItem(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: kGold, size: 22),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: kGreenDark,
                letterSpacing: 0.2)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

class _VertDivider extends StatelessWidget {
  const _VertDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 48, width: 1, color: Colors.grey.shade200);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: kGreen, size: 18),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;
  final bool showArrow;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.labelColor,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    final ic = iconColor ?? kGreen;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: ic.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: ic, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: labelColor ?? Colors.black87)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            if (showArrow)
              const Icon(Icons.chevron_right_rounded,
                  color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
