import 'package:flutter/material.dart';

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);
const Color kGreenDark = Color(0xFF2A6B43);
const Color kGreenLight = Color(0xFF56B87A);

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<Animation<double>> _fades;
  late List<Animation<Offset>> _slides;

  static const int _cardCount = 5;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    _fades = List.generate(_cardCount, (i) {
      final start = i * 0.12;
      return Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _ctrl,
          curve: Interval(start, (start + 0.5).clamp(0, 1),
              curve: Curves.easeOut)));
    });

    _slides = List.generate(_cardCount, (i) {
      final start = i * 0.12;
      return Tween<Offset>(
              begin: const Offset(0, 0.15), end: Offset.zero)
          .animate(CurvedAnimation(
              parent: _ctrl,
              curve: Interval(start, (start + 0.5).clamp(0, 1),
                  curve: Curves.easeOut)));
    });

    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _animated(int index, Widget child) => FadeTransition(
        opacity: _fades[index],
        child: SlideTransition(position: _slides[index], child: child),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: CustomScrollView(
        slivers: [
          //  Hero App Bar
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: kGreenDark,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: _HeroHeader(),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              child: Column(
                children: [
                  // 0 — About banner
                  _animated(0, _AboutBanner()),

                  const SizedBox(height: 16),

                  // 1 — Features
                  _animated(1, _FeaturesCard()),

                  const SizedBox(height: 16),

                  // 2 — Developer
                  _animated(2, _DeveloperCard()),

                  const SizedBox(height: 16),

                  // 4 — App info + footer
                  _animated(
                    4,
                    Column(
                      children: [
                        _AppInfoCard(),
                        const SizedBox(height: 28),
                        _Footer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Hero header 

class _HeroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Gradient
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
          top: -60, right: -60,
          child: _Circle(size: 220, opacity: 0.07),
        ),
        Positioned(
          bottom: -20, left: -50,
          child: _Circle(size: 160, opacity: 0.05),
        ),
        Positioned(
          top: 60, left: 30,
          child: _Circle(size: 60, opacity: 0.06),
        ),
        // Content
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 24),
              // Icon with glow ring
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                  border: Border.all(color: kGold, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: kGold.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.quiz_rounded,
                    size: 42, color: Colors.white),
              ),
              const SizedBox(height: 14),
              const Text(
                'Examination Portal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.2), width: 1),
                ),
                child: const Text(
                  'Smart Quiz Platform  •  v1.0.0',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Circle extends StatelessWidget {
  final double size;
  final double opacity;
  const _Circle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(opacity),
        ),
      );
}

//  About banner

class _AboutBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kGreenDark, kGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kGreen.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.info_outline_rounded,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About the App',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15)),
                SizedBox(height: 4),
                Text(
                  'An examination portal for offices, categorized by department and quiz type.',
                  style: TextStyle(
                      color: Colors.white70, fontSize: 13, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Features card 

class _FeaturesCard extends StatelessWidget {
  static const _features = [
    (Icons.category_outlined, 'Office Categories',
        'Quizzes organized by department'),
    (Icons.check_circle_outline_rounded, 'Multiple Choice',
        'Pick the correct answer from options'),
    (Icons.format_list_numbered_rounded, 'Enumeration',
        'List answers in the correct order'),
    (Icons.edit_outlined, 'Fill in the Blank',
        'Complete the missing word or phrase'),
    (Icons.emoji_events_outlined, 'Leaderboard & XP',
        'Earn points and climb the ranks'),
  ];

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(label: 'Features'),
          const SizedBox(height: 16),
          ..._features.asMap().entries.map((e) {
            final i = e.key;
            final f = e.value;
            return Column(
              children: [
                _FeatureRow(icon: f.$1, title: f.$2, desc: f.$3),
                if (i < _features.length - 1)
                  const Divider(height: 20, thickness: 0.6),
              ],
            );
          }),
        ],
      ),
    );
  }
}

//  Developer card 

class _DeveloperCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(label: 'Developers'),
          const SizedBox(height: 12),
          _DevRow(
            name: 'Carl Lawrence S. Maranion',
            role: 'IT Dev. Intern  •  IMIS',
            image: 'assets/me.png',
          ),
          const Divider(height: 20, thickness: 0.6),
          _DevRow(
            name: 'Ike Renson S. Landong',
            role: 'IT Dev. Intern  •  IMIS',
            image: null,
          ),
        ],
      ),
    );
  }
}

class _DevRow extends StatelessWidget {
  final String name;
  final String role;
  final String? image;
  const _DevRow({required this.name, required this.role, this.image});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kGold, width: 2),
          ),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: kGreenDark,
            backgroundImage:
                image != null ? AssetImage(image!) : null,
            child: image == null
                ? const Icon(Icons.person_rounded,
                    color: Colors.white, size: 20)
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13)),
              const SizedBox(height: 2),
              Text(role,
                  style: const TextStyle(
                      fontSize: 11, color: Colors.grey)),
            ],
          ),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: kGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: kGreen.withOpacity(0.3), width: 1),
          ),
          child: const Text('Flutter Dev',
              style: TextStyle(
                  fontSize: 10,
                  color: kGreen,
                  fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

//  App info card 

class _AppInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        children: const [
          _InfoRow(
              icon: Icons.tag_rounded, label: 'Version', value: '1.0.0'),
          Divider(height: 20, thickness: 0.6),
          _InfoRow(
              icon: Icons.build_circle_outlined,
              label: 'Build',
              value: 'Flutter 3.x  •  Dart 3.x'),
          Divider(height: 20, thickness: 0.6),
          _InfoRow(
              icon: Icons.gavel_outlined, label: 'License', value: 'MIT'),
          Divider(height: 20, thickness: 0.6),
          _InfoRow(
              icon: Icons.business_outlined,
              label: 'Organization',
              value: 'IMIS / IT Workshop2'),
        ],
      ),
    );
  }
}

// Footer 

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == 1 ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: i == 1 ? kGold : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '© 2026 Examination Portal',
          style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 2),
        Text(
          'Built with using Flutter',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
        ),
      ],
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────

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

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
              color: kGold, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: kGreenDark)),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  const _FeatureRow(
      {required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: kGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: kGreen, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(desc,
                  style:
                      const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
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
