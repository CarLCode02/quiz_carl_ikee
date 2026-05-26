import 'package:flutter/material.dart';

const Color kGold = Color(0xFFE7AB38);
const Color kGreen = Color(0xFF3D925F);
const Color kGreenDark = Color(0xFF2A6B43);

// ── Office model ──────────────────────────────────────────────────────────────

class Office {
  final String id;
  String name;
  String description;
  String adminName;
  int examCount;
  int userCount;
  bool isActive;

  Office({
    required this.id,
    required this.name,
    required this.description,
    required this.adminName,
    required this.examCount,
    required this.userCount,
    this.isActive = true,
  });
}

// ── Page ──────────────────────────────────────────────────────────────────────

class OfficeManagementPage extends StatefulWidget {
  const OfficeManagementPage({super.key});

  @override
  State<OfficeManagementPage> createState() => _OfficeManagementPageState();
}

class _OfficeManagementPageState extends State<OfficeManagementPage> {
  // stub offices — replace with real data source later
  final List<Office> _offices = [
    Office(id: '1', name: 'Internal Mrdicine',          description: 'General health and safety department',       adminName: 'Admin A', examCount: 8,  userCount: 42),
    Office(id: '2', name: 'Hospital Essentials',  description: 'Medical equipment and supply management',    adminName: 'Admin B', examCount: 5,  userCount: 28),
    Office(id: '3', name: 'Midterm Exam',         description: 'Periodic academic examination office',       adminName: 'Admin C', examCount: 12, userCount: 86),
    Office(id: '4', name: 'Patient Care',         description: 'Patient services and care coordination',     adminName: 'Admin D', examCount: 6,  userCount: 34, isActive: false),
    Office(id: '5', name: 'ICU',                  description: 'Intensive care unit training and protocols', adminName: 'Admin E', examCount: 4,  userCount: 19),
  ];

  String _search = '';

  List<Office> get _filtered => _offices
      .where((o) =>
          o.name.toLowerCase().contains(_search.toLowerCase()) ||
          o.adminName.toLowerCase().contains(_search.toLowerCase()))
      .toList();

  // ── Add / Edit dialog ───────────────────────────────────────────────────────

  void _showDialog({Office? office}) {
    final nameCtrl =
        TextEditingController(text: office?.name ?? '');
    final descCtrl =
        TextEditingController(text: office?.description ?? '');
    final adminCtrl =
        TextEditingController(text: office?.adminName ?? '');
    bool isActive = office?.isActive ?? true;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: 480,
            padding: const EdgeInsets.all(28),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // dialog title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          office == null
                              ? Icons.add_business_rounded
                              : Icons.edit_rounded,
                          color: kGreen,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        office == null ? 'Add New Office' : 'Edit Office',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: kGreenDark),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: Colors.grey),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Office name
                  _DialogField(
                    controller: nameCtrl,
                    label: 'Office Name',
                    icon: Icons.business_rounded,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),

                  // Description
                  _DialogField(
                    controller: descCtrl,
                    label: 'Description',
                    icon: Icons.description_outlined,
                    maxLines: 2,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 14),

                  // Admin name
                  _DialogField(
                    controller: adminCtrl,
                    label: 'Office Admin',
                    icon: Icons.person_outlined,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Active toggle
                  Row(
                    children: [
                      const Icon(Icons.toggle_on_outlined,
                          color: Colors.grey, size: 20),
                      const SizedBox(width: 10),
                      const Text('Active',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      const Spacer(),
                      Switch(
                        value: isActive,
                        activeColor: kGreen,
                        onChanged: (v) => setDlg(() => isActive = v),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;
                            setState(() {
                              if (office == null) {
                                // add
                                _offices.add(Office(
                                  id: DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString(),
                                  name: nameCtrl.text.trim(),
                                  description: descCtrl.text.trim(),
                                  adminName: adminCtrl.text.trim(),
                                  examCount: 0,
                                  userCount: 0,
                                  isActive: isActive,
                                ));
                              } else {
                                // edit
                                office.name = nameCtrl.text.trim();
                                office.description = descCtrl.text.trim();
                                office.adminName = adminCtrl.text.trim();
                                office.isActive = isActive;
                              }
                            });
                            Navigator.pop(ctx);
                            _showSnack(office == null
                                ? 'Office added successfully'
                                : 'Office updated successfully');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            office == null ? 'Add Office' : 'Save Changes',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Delete confirm ──────────────────────────────────────────────────────────

  void _confirmDelete(Office office) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 380,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete_outline_rounded,
                    color: Colors.red.shade400, size: 32),
              ),
              const SizedBox(height: 16),
              const Text('Delete Office',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(
                'Are you sure you want to delete "${office.name}"? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 13, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => _offices.remove(office));
                        Navigator.pop(ctx);
                        _showSnack('Office deleted');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Delete',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      behavior: SnackBarBehavior.floating,
      backgroundColor: kGreen,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Header ───────────────────────────────────────────────────────
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Office Management',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: kGreenDark)),
                    SizedBox(height: 3),
                    Text('Add, edit or remove office departments',
                        style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showDialog(),
                icon: const Icon(Icons.add_business_rounded, size: 20),
                label: const Text('Add Office',
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

        // ── Search + summary ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (v) => setState(() => _search = v),
                  decoration: InputDecoration(
                    hintText: 'Search offices...',
                    hintStyle:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: Colors.grey, size: 22),
                    filled: true,
                    fillColor: const Color(0xFFF4F6F9),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // total count pill
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: kGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kGreen.withOpacity(0.2)),
                ),
                child: Text(
                  '${_filtered.length} office${_filtered.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                      fontSize: 13,
                      color: kGreen,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),

        // ── Office list ───────────────────────────────────────────────────
        Expanded(
          child: _filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 56, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      Text('No offices found',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 15)),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, i) => _OfficeCard(
                    office: _filtered[i],
                    onEdit: () => _showDialog(office: _filtered[i]),
                    onDelete: () => _confirmDelete(_filtered[i]),
                    onToggle: () => setState(
                        () => _filtered[i].isActive = !_filtered[i].isActive),
                  ),
                ),
        ),
      ],
    );
  }
}

// ── Office card ───────────────────────────────────────────────────────────────

class _OfficeCard extends StatelessWidget {
  final Office office;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const _OfficeCard({
    required this.office,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.business_rounded,
                    color: kGreen, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(office.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(office.description,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            height: 1.4)),
                  ],
                ),
              ),
              // active badge
              GestureDetector(
                onTap: onToggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: office.isActive
                        ? Colors.green.shade50
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: office.isActive
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        office.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: office.isActive
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // action menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded,
                    color: Colors.grey, size: 22),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onSelected: (v) {
                  if (v == 'edit') onEdit();
                  if (v == 'delete') onDelete();
                  if (v == 'toggle') onToggle();
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(children: [
                      Icon(Icons.edit_outlined, size: 18),
                      SizedBox(width: 10),
                      Text('Edit Office'),
                    ]),
                  ),
                  PopupMenuItem(
                    value: 'toggle',
                    child: Row(children: [
                      Icon(
                        office.isActive
                            ? Icons.toggle_off_outlined
                            : Icons.toggle_on_outlined,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Text(office.isActive ? 'Deactivate' : 'Activate'),
                    ]),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                      Icon(Icons.delete_outline,
                          size: 18, color: Colors.red.shade400),
                      const SizedBox(width: 10),
                      Text('Delete',
                          style:
                              TextStyle(color: Colors.red.shade400)),
                    ]),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 0.6),
          const SizedBox(height: 12),

          // meta row
          Row(
            children: [
              _MetaPill(
                icon: Icons.person_outlined,
                label: office.adminName,
                color: kGreenDark,
              ),
              const SizedBox(width: 10),
              _MetaPill(
                icon: Icons.quiz_outlined,
                label: '${office.examCount} exams',
                color: const Color(0xFF5B8DD9),
              ),
              const SizedBox(width: 10),
              _MetaPill(
                icon: Icons.people_outline_rounded,
                label: '${office.userCount} users',
                color: kGold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Meta pill ─────────────────────────────────────────────────────────────────

class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _MetaPill(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── Dialog field ──────────────────────────────────────────────────────────────

class _DialogField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final String? Function(String?)? validator;

  const _DialogField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kGreen, size: 20),
        filled: true,
        fillColor: const Color(0xFFF4F6F9),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                BorderSide(color: Colors.grey.shade200, width: 1.2)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kGreen, width: 1.8)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Colors.redAccent, width: 1.5)),
      ),
    );
  }
}
