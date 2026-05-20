import 'package:flutter/material.dart';

const Color kGreen = Color.fromARGB(255, 76, 175, 80);

class SuperAdmin extends StatefulWidget {
  const SuperAdmin({super.key});

  @override
  State<SuperAdmin> createState() => _SuperAdminState();
}

class _SuperAdminState extends State<SuperAdmin> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Side Navigation
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: kGreen,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  //child:Text('SUPER ADMIN'), 
                ), 
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('assets/BRGHGMC.png', height: 80, width: 80),
                ),
                const Divider(color: Colors.white30),
                _buildNavItem('Dashboard', 0, Icons.dashboard),
                _buildNavItem('Users Management', 1, Icons.people),
                _buildNavItem('Office Management', 2, Icons.assessment),
                _buildNavItem('Settings', 3, Icons.settings),
               // _buildNavItem('User View', 3, Icons.user),
                _buildNavItem('Logout', 4, Icons.logout),
                const Spacer(),
              ],
            ),
          ),
          // 
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: _buildContentArea(_selectedIndex),
            ),
          ),
        ],
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
    }
    return Center(
      child: Text(
        _getPageTitle(index),
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  Widget _buildDashboard() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Analytics',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                  title: 'Total Users',
                  number: '1,234',
                  icon: Icons.people,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildAnalyticsCard(
                  title: 'Total Quizzes',
                  number: '45',
                  icon: Icons.quiz,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildAnalyticsCard(
                  title: 'Total Examiners',
                  number: '28',
                  icon: Icons.person_add,
                  color: Colors.purple,
                ),

              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildAnalyticsCard(
                  title: 'Total Offices',
                  number: '28',
                  icon: Icons.work,
                  color: const Color.fromARGB(255, 39, 176, 92),
                ),

              ),
              
            ],
          ),
        ],

      ),
    );
  }

  Widget _buildUsersManagement() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Users Management',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add User'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
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
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: [
                    _buildUserTableRow('001', 'John Doe', 'john@example.com', 'Admin', 'Active'),
                    _buildUserTableRow('002', 'Jane Smith', 'jane@example.com', 'Examiner', 'Active'),
                    _buildUserTableRow('003', 'Mike Johnson', 'mike@example.com', 'User', 'Inactive'),
                    _buildUserTableRow('004', 'Sarah Williams', 'sarah@example.com', 'Examiner', 'Active'),
                    _buildUserTableRow('005', 'Robert Brown', 'robert@example.com', 'User', 'Active'),
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
    String status,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(id)),
        DataCell(Text(name)),
        DataCell(Text(email)),
        DataCell(Text(role)),
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
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Office Management',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Office'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ],
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

  Widget _buildNavItem(String label, int index, IconData icon) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        hoverColor: Colors.green[700],
        child: Container(
          color: _selectedIndex == index ? Colors.green[800] : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
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
}

