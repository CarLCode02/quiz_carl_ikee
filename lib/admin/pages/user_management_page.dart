import 'package:flutter/material.dart';
import 'exam_history_page.dart';

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);
const Color kGreenDark = Color(0xFF2A6B43);

// Sample users — names match userHistoryMap in exam_history_page.dart
const _sampleUsers = [
  _SampleUser('Juan Dela Cruz', 'juan@brghgmc.com', 'Examinee', kGreen),
  _SampleUser('Maria Santos', 'maria@brghgmc.com', 'Examinee', kGreen),
  _SampleUser('Pedro Reyes', 'pedro@brghgmc.com', 'Examinee', kGreen),
  _SampleUser('Ana Gonzales', 'ana@brghgmc.com', 'Examinee', kGreen),
  _SampleUser('pony mo', 'jose@brghgmc.com', 'Examinee', kGreen),
  _SampleUser('Crisostomo Ibarra', 'cris@brghgmc.com', 'Examinee', kGreen),
  _SampleUser('Sisa Maranion', 'sisa@brghgmc.com', 'Examinee', kGreen),
  _SampleUser('Basilio Cruz', 'basilio@brghgmc.com', 'Office Admin', Color(0xFF5B8DD9)),
];

class _SampleUser {
  final String name;
  final String email;
  final String role;
  final Color roleColor;
  const _SampleUser(this.name, this.email, this.role, this.roleColor);
}

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('User Management',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: kGreenDark)),
                    SizedBox(height: 3),
                    Text('Manage examinees and office admins',
                        style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add_rounded, size: 20),
                label: const Text('Add User',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search users...',
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              prefixIcon: const Icon(Icons.search_rounded,
                  color: Colors.grey, size: 22),
              filled: true,
              fillColor: const Color(0xFFF4F6F9),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: _sampleUsers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _UserCard(user: _sampleUsers[i]),
          ),
        ),
      ],
    );
  }
}

class _UserCard extends StatelessWidget {
  final _SampleUser user;
  const _UserCard({required this.user});

  int get _examCount => userHistoryMap[user.name]?.length ?? 0;

  void _openHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExamHistoryPage(filterUser: user.name),
      ),
    );
  }

  void _openProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(user.name,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileRow(Icons.email_outlined, user.email),
            _ProfileRow(Icons.badge_outlined, user.role),
            _ProfileRow(Icons.quiz_outlined, '$_examCount exam(s) taken'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openHistory(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Exam History'),
          ),
        ],
      ),
    );
  }

  void _onMenuSelected(BuildContext context, String value) {
    switch (value) {
      case 'view':
        _openProfile(context);
        break;
      case 'history':
        _openHistory(context);
        break;
      case 'edit':
      case 'remove':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = user.name
        .split(' ')
        .where((p) => p.isNotEmpty)
        .map((p) => p[0])
        .take(2)
        .join()
        .toUpperCase();

    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: kGreen.withOpacity(0.12),
                child: Text(
                  initials,
                  style: const TextStyle(
                      color: kGreen,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    const SizedBox(height: 3),
                    Text(user.email,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: user.roleColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(user.role,
                              style: TextStyle(
                                  fontSize: 11,
                                  color: user.roleColor,
                                  fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: kGold.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.history_rounded,
                                  size: 12, color: kGold),
                              const SizedBox(width: 4),
                              Text(
                                '$_examCount exam${_examCount == 1 ? '' : 's'}',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: kGold,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 4),
                              const Text('Active',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded,
                    color: Colors.grey, size: 22),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onSelected: (v) => _onMenuSelected(context, v),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                      value: 'view',
                      child: Row(children: [
                        Icon(Icons.visibility_outlined, size: 18),
                        SizedBox(width: 10),
                        Text('View Profile'),
                      ])),
                  const PopupMenuItem(
                      value: 'history',
                      child: Row(children: [
                        Icon(Icons.history_rounded, size: 18),
                        SizedBox(width: 10),
                        Text('Exam History'),
                      ])),
                  const PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [
                        Icon(Icons.edit_outlined, size: 18),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ])),
                  PopupMenuItem(
                      value: 'remove',
                      child: Row(children: [
                        Icon(Icons.person_remove_outlined,
                            size: 18, color: Colors.red.shade400),
                        const SizedBox(width: 10),
                        Text('Remove',
                            style: TextStyle(color: Colors.red.shade400)),
                      ])),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => _openProfile(context),
                icon: const Icon(Icons.person_outline_rounded, size: 16),
                label: const Text('View Profile',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kGreenDark,
                  side: BorderSide(color: kGreen.withOpacity(0.4)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _openHistory(context),
                icon: const Icon(Icons.history_rounded, size: 16),
                label: const Text('Exam History',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ProfileRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
              child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
