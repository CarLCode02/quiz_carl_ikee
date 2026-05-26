import 'package:flutter/material.dart';

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);
const Color kGreenDark = Color(0xFF2A6B43);

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // page title
          const _PageTitle(
              title: 'Dashboard',
              subtitle: 'Welcome back! Here\'s what\'s happening today.'),
          const SizedBox(height: 24),

          // stat cards
          LayoutBuilder(builder: (context, c) {
            final cols = c.maxWidth > 700 ? 4 : 2;
            return GridView.count(
              crossAxisCount: cols,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.5,
              children: const [
                _StatCard(label: 'Total Exams',  value: '24',  icon: Icons.quiz_rounded,         color: kGreen,              trend: '+3 this week'),
                _StatCard(label: 'Active Users', value: '156', icon: Icons.people_rounded,        color: Color(0xFF5B8DD9),   trend: '+12 this month'),
                _StatCard(label: 'Completed',    value: '89',  icon: Icons.check_circle_rounded,  color: kGold,               trend: '74% pass rate'),
                _StatCard(label: 'Pending',      value: '12',  icon: Icons.pending_rounded,       color: Colors.deepOrange,   trend: '5 due today'),
              ],
            );
          }),

          const SizedBox(height: 24),

          // recent activity
          _SectionCard(
            title: 'Recent Activity',
            icon: Icons.history_rounded,
            child: Column(
              children: List.generate(5, (i) {
                final actions = [
                  'Published "Hospital Safety Protocols"',
                  'Added 12 new users to Internal Medicine',
                  'Updated "Midterm Unit 1" questions',
                  'Reviewed 34 exam submissions',
                  'Created "Patient Care Procedures"',
                ];
                final times = [
                  '2 hours ago', 'Yesterday', 'May 3', 'May 2', 'May 1'
                ];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: kGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.quiz_outlined,
                                color: kGreen, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(actions[i],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 3),
                                Text(times[i],
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (i < 4) const Divider(height: 1, thickness: 0.6),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _PageTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _PageTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: kGreenDark)),
        const SizedBox(height: 4),
        Text(subtitle,
            style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  const _StatCard({
    required this.label, required this.value,
    required this.icon, required this.color, required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06),
              blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(trend,
                    style: TextStyle(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: color)),
              Text(label,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SectionCard(
      {required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06),
              blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Row(
              children: [
                Container(
                  width: 4, height: 20,
                  decoration: BoxDecoration(
                      color: kGold,
                      borderRadius: BorderRadius.circular(4)),
                ),
                const SizedBox(width: 10),
                Icon(icon, color: kGreenDark, size: 20),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: kGreenDark)),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.6),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: child,
          ),
        ],
      ),
    );
  }
}
