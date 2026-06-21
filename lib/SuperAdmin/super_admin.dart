import 'package:flutter/material.dart';
import 'package:quizcarl_ikee/login_page.dart';

const Color kGreen = Color.fromARGB(255, 76, 175, 80);
const Color kGreenDark = Color(0xFF2A6B43);

const _navItems = <({String label, IconData icon})>[
  (label: 'Dashboard', icon: Icons.dashboard_rounded),
  (label: 'Users Management', icon: Icons.people_rounded),
  (label: 'Office Management', icon: Icons.business_rounded),
  (label: 'Settings', icon: Icons.settings_rounded),
];

class SuperAdmin extends StatefulWidget {
  const SuperAdmin({super.key});

  @override
  State<SuperAdmin> createState() => _SuperAdminState();
}

class _SuperAdminState extends State<SuperAdmin> {
  int _selectedIndex = 0;
  bool notificationsEnabled = true;
  bool maintenanceMode = false;

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 900;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: isWide ? null : _buildDrawer(),
      body: Column(
        children: [
          _SuperAdminHeader(
            isWide: isWide,
            pageTitle: _navItems[_selectedIndex].label,
          ),
          Expanded(
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SuperAdminSideNav(
                        selectedIndex: _selectedIndex,
                        onSelect: (i) => setState(() => _selectedIndex = i),
                        onLogout: _logout,
                      ),
                      Expanded(child: _buildContentArea(_selectedIndex)),
                    ],
                  )
                : _buildContentArea(_selectedIndex),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SuperAdminDrawerHeader(),
            const Divider(color: Colors.white24),
            ...List.generate(_navItems.length, (i) {
              return _SuperAdminNavTile(
                label: _navItems[i].label,
                icon: _navItems[i].icon,
                selected: _selectedIndex == i,
                onTap: () {
                  setState(() => _selectedIndex = i);
                  Navigator.pop(context);
                },
              );
            }),
            const Spacer(),
            const Divider(color: Colors.white24),
            _SuperAdminNavTile(
              label: 'Logout',
              icon: Icons.logout_rounded,
              selected: false,
              isLogout: true,
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildContentArea(int index) {
    if (index == 0) {
      return _buildDashboard();
    } else if (index == 1) {
      return _buildUsersManagement();
    } else if (index == 2) {
      return _buildOfficeManagement();
    } else if (index == 3) {
      return _buildSettings();
    }
    return Center(
      child: Text(
        _getPageTitle(index),
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  Widget _buildDashboard() {
    final pad = _pagePadding(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Analytics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth > 1100
                  ? 4
                  : constraints.maxWidth > 700
                      ? 2
                      : 1;
              final cards = [
                _buildAnalyticsCard(
                  title: 'Total Users',
                  number: '1,234',
                  icon: Icons.people,
                  color: Colors.blue,
                ),
                _buildAnalyticsCard(
                  title: 'Total Quizzes',
                  number: '45',
                  icon: Icons.quiz,
                  color: Colors.orange,
                ),
                _buildAnalyticsCard(
                  title: 'Total Examiners',
                  number: '28',
                  icon: Icons.person_add,
                  color: Colors.purple,
                ),
                _buildAnalyticsCard(
                  title: 'Total Offices',
                  number: '28',
                  icon: Icons.work,
                  color: const Color.fromARGB(255, 39, 176, 92),
                ),
              ];
              return GridView.count(
                crossAxisCount: cols,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: cols == 1 ? 2.4 : 1.35,
                children: cards,
              );
            },
          ),
        ],
      ),
    );
  }

  double _pagePadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1200) return 28;
    if (w >= 600) return 20;
    return 14;
  }

  Widget _buildUsersManagement() {
    final pad = _pagePadding(context);
    return Padding(
      padding: EdgeInsets.all(pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 520;
              final title = Text(
                'Users Management',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              );
              final addBtn = ElevatedButton.icon(
                onPressed: _showAddUserModal,
                icon: const Icon(Icons.add),
                label: const Text('Add User'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              );
              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [title, const SizedBox(height: 12), addBtn],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Expanded(child: title), addBtn],
              );
            },
          ),
          const SizedBox(height: 24),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search users...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Role')),
                    DataColumn(label: Text('Office')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: [

                  _buildUserTableRow('001', 'John Doe', 'john@example.com', 'Examiner', 'Sanitary', 'Active'),
_buildUserTableRow('002', 'Jane Smith', 'jane@example.com', 'User', 'IMIS Office', 'Active'),
_buildUserTableRow('003', 'Mike Johnson', 'mike@example.com', 'Admin', 'SAO', 'Inactive'),
_buildUserTableRow('004', 'Sarah Williams', 'sarah@example.com', 'User', 'MCC', 'Active'),
_buildUserTableRow('005', 'Robert Brown', 'robert@example.com', 'User', 'PETRU', 'Active'),
_buildUserTableRow('006', 'Emily Davis', 'emily@example.com', 'User', 'Registrar', 'Active'),
_buildUserTableRow('007', 'Daniel Wilson', 'daniel@example.com', 'User', 'Library', 'Inactive'),
_buildUserTableRow('008', 'Sophia Martinez', 'sophia@example.com', 'Examiner', 'Guidance', 'Active'),
_buildUserTableRow('009', 'James Anderson', 'james@example.com', 'User', 'Cashier', 'Active'),
_buildUserTableRow('010', 'Olivia Taylor', 'olivia@example.com', 'Admin', 'Accounting', 'Active'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildUserTableRow(
    String id,
    String name,
    String email,
    String role,
    String office,
    String status,
  ) {
    return DataRow(
      onSelectChanged: (selected) {
        if (selected == true) {
          _showUserDetailsModal(id, name, email, role, office, status);
        }
      },
      cells: [
        DataCell(Text(id)),
        DataCell(Text(name)),
        DataCell(Text(email)),
        DataCell(Text(role)),
        DataCell(Text(office)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: status == 'Active' ? Colors.green[100] : Colors.red[100],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: status == 'Active' ? Colors.green[700] : Colors.red[700],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.visibility, size: 18),
                onPressed: () {
                  _showUserDetailsModal(id, name, email, role, office, status);
                },
                color: Colors.green,
                tooltip: 'View',
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: () {},
                color: Colors.blue,
                tooltip: 'Edit',
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 18),
                onPressed: () {},
                color: Colors.red,
                tooltip: 'Delete',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOfficeManagement() {
    final pad = _pagePadding(context);
    return Padding(
      padding: EdgeInsets.all(pad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 520;
              final title = Text(
                'Office Management',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              );
              final addBtn = ElevatedButton.icon(
                onPressed: _showAddOfficeModal,
                icon: const Icon(Icons.add),
                label: const Text('Add Office'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              );
              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [title, const SizedBox(height: 12), addBtn],
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Expanded(child: title), addBtn],
              );
            },
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOfficeCategory('Medical Offices', Colors.blue, [
                    {'name': 'Cardiology Wing', 'location': 'Building A', 'staff': '12'},
                    {'name': 'General Medicine', 'location': 'Building B', 'staff': '8'},
                    {'name': 'Pediatrics', 'location': 'Building A', 'staff': '6'},
                  ]),
                  const SizedBox(height: 32),
                  _buildOfficeCategory('Administrative Offices', Colors.orange, [
                    {'name': 'Human Resources', 'location': 'Building C', 'staff': '5'},
                    {'name': 'Finance Department', 'location': 'Building C', 'staff': '7'},
                    {'name': 'Management Office', 'location': 'Building D', 'staff': '4'},
                  ]),
                  const SizedBox(height: 32),
                  _buildOfficeCategory('Support Services', Colors.purple, [
                    {'name': 'IT Services', 'location': 'Building B', 'staff': '9'},
                    {'name': 'Maintenance', 'location': 'Building E', 'staff': '6'},
                    {'name': 'Security', 'location': 'Ground Floor', 'staff': '8'},
                    {'name': 'Sanitary', 'location': 'Ground Floor', 'staff': '8'},
                    {'name': 'WhiteHouse', 'location': 'Ground Floor', 'staff': '8'},
                  ]),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    final pad = _pagePadding(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(pad),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            // General Settings
            _buildSettingsCard(
              title: 'General Settings',
              icon: Icons.settings,
              color: Colors.blue,
              children: [
                _buildSettingsItem(
                  label: 'Application Name',
                  value: 'Quiz Management System',
                  icon: Icons.app_settings_alt,
                ),
                const Divider(),
                _buildSettingsItem(
                  label: 'Version',
                  value: '1.0.0',
                  icon: Icons.info,
                ),
                const Divider(),
                _buildSettingsItem(
                  label: 'Last Updated',
                  value: 'May 21, 2026',
                  icon: Icons.update,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Security Settings
            _buildSettingsCard(
              title: 'Security Settings',
              icon: Icons.security,
              color: Colors.red,
              children: [
                _buildSettingsItemWithButton(
                  label: 'Change Admin Password',
                  icon: Icons.lock,
                  buttonLabel: 'Change',
                  onPressed: () {
                    _showChangePasswordModal();
                  },
                ),
                const Divider(),
                _buildSettingsItemWithButton(
                  label: 'Two-Factor Authentication',
                  icon: Icons.verified_user,
                  buttonLabel: 'Enable',
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            // System Settings
            _buildSettingsCard(
              title: 'System Settings',
              icon: Icons.tune,
              color: Colors.orange,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.notifications, color: Colors.orange),
                        const SizedBox(width: 12),
                        const Text('Enable Notifications'),
                      ],
                    ),
                    Switch(
                      value: notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          notificationsEnabled = value;
                        });
                      },
                      activeColor: kGreen,
                    ),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.construction, color: Colors.orange),
                        const SizedBox(width: 12),
                        const Text('Maintenance Mode'),
                      ],
                    ),
                    Switch(
                      value: maintenanceMode,
                      onChanged: (value) {
                        setState(() {
                          maintenanceMode = value;
                        });
                      },
                      activeColor: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Database Settings
            _buildSettingsCard(
              title: 'Database & Backup',
              icon: Icons.storage,
              color: Colors.green,
              children: [
                _buildSettingsItemWithButton(
                  label: 'Backup Database',
                  icon: Icons.backup,
                  buttonLabel: 'Backup',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Backup started...'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
                const Divider(),
                _buildSettingsItemWithButton(
                  label: 'Last Backup',
                  value: 'May 20, 2026 - 10:30 PM',
                  icon: Icons.history,
                  buttonLabel: 'View',
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            // About
            _buildSettingsCard(
              title: 'About',
              icon: Icons.info_outline,
              color: Colors.purple,
              children: [
                _buildSettingsItem(
                  label: 'Organization',
                  value: 'BICOL REGION GENERAL HOSPITAL AND GERIATRIC MEDICAL CENTER',
                  icon: Icons.business,
                ),
                const Divider(),
                _buildSettingsItem(
                  label: 'Support Email',
                  value: 'PETRU@brghgmc.com',
                  icon: Icons.email,
                ),
              ],
            ),
          ],
        ),
    );
  }

  Widget _buildOfficeCategory(String categoryName, Color categoryColor, List<Map<String, String>> offices) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: categoryColor, width: 2),
          ),
          child: Text(
            categoryName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: categoryColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final cols = constraints.maxWidth > 900
                ? 3
                : constraints.maxWidth > 560
                    ? 2
                    : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols,
                childAspectRatio: cols == 1 ? 1.5 : 1.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: offices.length,
              itemBuilder: (context, index) {
                return _buildOfficeCard(
                  offices[index]['name']!,
                  offices[index]['location']!,
                  offices[index]['staff']!,
                  categoryColor,
                );
              },
            );
          },
        ),
      ],
    );
  }
Widget _buildSettingsCategory(String categoryName, Color categoryColor, List<Map<String, String>> offices) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: categoryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: categoryColor, width: 2),
          ),
          child: Text(
            categoryName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: categoryColor,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: offices.length,
          itemBuilder: (context, index) {
            return _buildOfficeCard(
              offices[index]['name']!,
              offices[index]['location']!,
              offices[index]['staff']!,
              categoryColor,
            );
          },
        ),
      ],
    );
  }

  Widget _buildOfficeCard(String name, String location, String staff, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.location_city, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    location,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.people, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '$staff Staff',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      _showEditOfficeModal(name, location, staff);
                    },
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('Delete'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUserDetailsModal(String id, String name, String email, String role, String office, String status) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('User Details'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 400,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('User ID', id),
                      const SizedBox(height: 12),
                      _buildDetailRow('Full Name', name),
                      const SizedBox(height: 12),
                      _buildDetailRow('Email', email),
                      const SizedBox(height: 12),
                      _buildDetailRow('Role', role),
                      const SizedBox(height: 12),
                      _buildDetailRow('Office', office),
                      const SizedBox(height: 12),
                      _buildDetailRow('Status', status, 
                        statusColor: status == 'Active' ? Colors.green : Colors.red),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Edit user logic
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? statusColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: statusColor != null
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: statusColor,
                    ),
                  ),
                )
              : Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
        ),
      ],
    );
  }

  void _showEditOfficeModal(String officeName, String location, String staff) {
    final nameController = TextEditingController(text: officeName);
    final locationController = TextEditingController(text: location);
    final staffController = TextEditingController(text: staff);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Office'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField( 
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Office Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.location_city),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: staffController,
                  decoration: InputDecoration(
                    labelText: 'Number of Staff',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.people),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle save logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Office "${nameController.text}" updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
              ),
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }
  Widget _buildAnalyticsCard({
    required String title,
    required String number,
    required IconData icon,
    required Color color, 
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              number,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Manage Users';
      case 2:
        return 'Reports';
      case 3:
        return 'Settings';
      case 4:
        return 'Logout';
      default:
        return 'Super Admin';
    }
  }

  Widget _buildSettingsCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(color: color, width: 4),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required String label,
    String? value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value ?? 'N/A',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsItemWithButton({
    required String label,
    String? value,
    required IconData icon,
    required String buttonLabel,
    required VoidCallback onPressed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            if (value != null) ...[
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ]
          ],
        ),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: kGreen,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(buttonLabel),
        ),
      ],
    );
  }

  void _showAddUserModal() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final roleController = TextEditingController();
    final officeController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New User'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: roleController,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.assignment),
                    hintText: 'e.g., Admin, User, Examiner',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: officeController,
                  decoration: InputDecoration(
                    labelText: 'Office',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.location_city),
                    hintText: 'e.g., Sanitary, IMIS Office',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    roleController.text.isEmpty ||
                    officeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'User "${nameController.text}" added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add User'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddOfficeModal() {
    final nameController = TextEditingController();
    final locationController = TextEditingController();
    final staffController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Office'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Office Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.location_city),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.location_on),
                    hintText: 'e.g., Building A, Ground Floor',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: staffController,
                  decoration: InputDecoration(
                    labelText: 'Number of Staff',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.people),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    locationController.text.isEmpty ||
                    staffController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Office "${nameController.text}" added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Office'),
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordModal() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password changed successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kGreen,
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}

// ── Responsive shell widgets ──────────────────────────────────────────────────

class _SuperAdminHeader extends StatelessWidget {
  final bool isWide;
  final String pageTitle;

  const _SuperAdminHeader({required this.isWide, required this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kGreenDark, kGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isWide ? 20 : 8),
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
                  height: 36,
                  width: 36,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.local_hospital_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isWide ? 'BRGHGMC Super Admin' : 'Super Admin',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        pageTitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuperAdminSideNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onLogout;

  const _SuperAdminSideNav({
    required this.selectedIndex,
    required this.onSelect,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: kGreen,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Image.asset(
              'assets/BRGHGMC.png',
              height: 72,
              width: 72,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
                size: 56,
              ),
            ),
          ),
          const Divider(color: Colors.white30),
          const SizedBox(height: 8),
          ...List.generate(_navItems.length, (i) {
            return _SuperAdminNavTile(
              label: _navItems[i].label,
              icon: _navItems[i].icon,
              selected: selectedIndex == i,
              onTap: () => onSelect(i),
            );
          }),
          const Spacer(),
          const Divider(color: Colors.white30),
          _SuperAdminNavTile(
            label: 'Logout',
            icon: Icons.logout_rounded,
            selected: false,
            isLogout: true,
            onTap: onLogout,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SuperAdminDrawerHeader extends StatelessWidget {
  const _SuperAdminDrawerHeader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: kGreen,
            child: Icon(Icons.admin_panel_settings,
                color: Colors.white, size: 24),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Super Admin',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                Text('BRGHGMC',
                    style: TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SuperAdminNavTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool isLogout;

  const _SuperAdminNavTile({
    required this.label,
    required this.icon,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.white.withOpacity(0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
