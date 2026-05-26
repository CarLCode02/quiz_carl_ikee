import 'package:flutter/material.dart';
import 'package:quizcarl_ikee/login_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/examination_management_page.dart';
import 'pages/user_management_page.dart';
import 'pages/office_management_page.dart';
import 'pages/settings_page.dart';
import 'admin_profile_page.dart';

// ── Nav items ─────────────────────────────────────────────────────────────────

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);
const Color kGreenDark = Color(0xFF2A6B43);
const Color kGreenLight = Color(0xFF56B87A);

class NavItem {
  final IconData icon;
  final String label;
  const NavItem(this.icon, this.label);
}

const navItems = [
  NavItem(Icons.dashboard_rounded,        'Dashboard'),
  NavItem(Icons.quiz_rounded,             'Examination Management'),
  NavItem(Icons.people_rounded,           'User Management'),
  NavItem(Icons.business_rounded,         'Office Management'),
  NavItem(Icons.settings_rounded,         'Settings'),
];

// ── Admin Dashboard shell ─────────────────────────────────────────────────────

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final _pages = const [
    DashboardPage(),
    ExaminationManagementPage(),
    UserManagementPage(),
    OfficeManagementPage(),
    AdminSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w >= 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      drawer: isWide ? null : _buildDrawer(),
      body: Column(
        children: [
          // ── Header ───────────────────────────────────────────────────
          _AdminHeader(
            isWide: isWide,
            selectedIndex: _selectedIndex,
          ),
          // ── Body ─────────────────────────────────────────────────────
          Expanded(
            child: isWide
                ? Row(
                    children: [
                      _SideRail(
                        selectedIndex: _selectedIndex,
                        onSelect: (i) =>
                            setState(() => _selectedIndex = i),
                      ),
                      Expanded(child: _pages[_selectedIndex]),
                    ],
                  )
                : _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: kGreenDark,
      child: SafeArea(
        child: Column(
          children: [
            _DrawerHeader(),
            const Divider(color: Colors.white12),
            ...navItems.asMap().entries.map((e) => _DrawerNavTile(
                  item: e.value,
                  selected: _selectedIndex == e.key,
                  onTap: () {
                    setState(() => _selectedIndex = e.key);
                    Navigator.pop(context);
                  },
                )),
            const Spacer(),
            const Divider(color: Colors.white12),
            _DrawerNavTile(
              item: const NavItem(Icons.logout_rounded, 'Logout'),
              selected: false,
              isLogout: true,
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _AdminHeader extends StatelessWidget {
  final bool isWide;
  final int selectedIndex;
  const _AdminHeader(
      {required this.isWide, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreenDark, kGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? 24 : 12, vertical: 0),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              if (!isWide)
                Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu_rounded,
                        color: Colors.white, size: 26),
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                  ),
                ),
              Image.asset(
                'assets/BRGHGMC.png',
                height: 40,
                width: 40,
                errorBuilder: (_, __, ___) => const Icon(
                    Icons.local_hospital_rounded,
                    color: kGold,
                    size: 36),
              ),
              const SizedBox(width: 10),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('BRGHGMC',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          letterSpacing: 0.4)),
                  Text('Admin Panel',
                      style: TextStyle(
                          color: Colors.white60, fontSize: 11)),
                ],
              ),
              const Spacer(),
              if (isWide)
                Text(navItems[selectedIndex].label,
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500)),
              const SizedBox(width: 16),
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined,
                        color: Colors.white, size: 24),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                            color: kGold, shape: BoxShape.circle),
                      ),
                    ),
                  ],
                ),
                onPressed: () {},
              ),
              Container(
                margin: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kGold, width: 2),
                ),
                child: GestureDetector(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                          builder: (_) => const AdminProfilePage())),
                  child: const CircleAvatar(
                    radius: 16,
                    backgroundColor: kGreenDark,
                    child: Icon(Icons.person_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Side rail ─────────────────────────────────────────────────────────────────

class _SideRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  const _SideRail(
      {required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: kGreen.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kGreen.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: kGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.business_rounded,
                      color: kGreen, size: 16),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Internal Medicine',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: kGreenDark)),
                      Text('Office Admin',
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),
          ...navItems.asMap().entries.map((e) => _RailTile(
                item: e.value,
                selected: selectedIndex == e.key,
                onTap: () => onSelect(e.key),
              )),
          const Spacer(),
          const Divider(height: 1),
          _RailTile(
            item: const NavItem(Icons.logout_rounded, 'Logout'),
            selected: false,
            isLogout: true,
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _RailTile extends StatelessWidget {
  final NavItem item;
  final bool selected;
  final VoidCallback onTap;
  final bool isLogout;
  const _RailTile({
    required this.item,
    required this.selected,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isLogout
        ? Colors.red.shade400
        : selected
            ? kGreen
            : Colors.black54;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: selected
                ? kGreen.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(item.icon, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(item.label,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: color)),
              ),
              if (selected)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                      color: kGreen, shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Drawer widgets ────────────────────────────────────────────────────────────

class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kGold, width: 2),
            ),
            child: const CircleAvatar(
              radius: 22,
              backgroundColor: kGreen,
              child: Icon(Icons.person_rounded,
                  color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Office Admin',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
              Text('Internal Medicine',
                  style: TextStyle(
                      color: Colors.white60, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawerNavTile extends StatelessWidget {
  final NavItem item;
  final bool selected;
  final VoidCallback onTap;
  final bool isLogout;
  const _DrawerNavTile({
    required this.item,
    required this.selected,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isLogout
        ? Colors.red.shade300
        : selected
            ? Colors.white
            : Colors.white70;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? Colors.white.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(item.icon, color: color, size: 20),
              const SizedBox(width: 12),
              Text(item.label,
                  style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }
}
