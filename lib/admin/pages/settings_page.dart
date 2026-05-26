import 'package:flutter/material.dart';

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);
const Color kGreenDark = Color(0xFF2A6B43);

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageTitle(
              title: 'Settings',
              subtitle: 'Manage your office preferences'),
          const SizedBox(height: 24),
          _SectionCard(
            title: 'Office',
            icon: Icons.business_rounded,
            children: const [
              _SettingsTile(
                icon: Icons.business_outlined,
                label: 'Office Information',
                subtitle: 'Update office name and details',
              ),
              _SettingsTile(
                icon: Icons.category_outlined,
                label: 'Exam Categories',
                subtitle: 'Manage exam types and categories',
              ),
              _SettingsTile(
                icon: Icons.schedule_outlined,
                label: 'Exam Schedule',
                subtitle: 'Set default exam time windows',
              ),
            ],
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
                fontSize: 24, fontWeight: FontWeight.w800, color: kGreenDark)),
        const SizedBox(height: 4),
        Text(subtitle,
            style: const TextStyle(fontSize: 13, color: Colors.grey)),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _SectionCard(
      {required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4)),
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
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                      color: kGold, borderRadius: BorderRadius.circular(4)),
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
          ...children.asMap().entries.map((e) => Column(
                children: [
                  e.value,
                  if (e.key < children.length - 1)
                    const Divider(
                        height: 1,
                        thickness: 0.6,
                        indent: 20,
                        endIndent: 20),
                ],
              )),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  const _SettingsTile(
      {required this.icon, required this.label, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kGreen.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: kGreen, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.chevron_right_rounded,
                  color: Colors.grey, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
