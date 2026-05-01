import 'package:flutter/material.dart';

const Color kGreen = Color(0xFF3D925F);
const Color kGreenDark = Color(0xFF2A6B43);

class MyTry extends StatefulWidget {
  const MyTry({super.key});

  @override
  State<MyTry> createState() => _MyTryState();
}

class _MyTryState extends State<MyTry> {
  late TextEditingController emailController;
  late TextEditingController officeController;
  late TextEditingController designationController;
  late TextEditingController locationController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: 'Carl@gmal.com');
    officeController = TextEditingController(text: 'IT WorkShop2/IMIS');
    designationController = TextEditingController(text: 'IT Dev. Intern');
    locationController = TextEditingController(text: 'Camarines Sur, Philippines');
  }

  @override
  void dispose() {
    emailController.dispose();
    officeController.dispose();
    designationController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kGreenDark, kGreen],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text('Account Settings',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Info Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.person_outline,
                              color: kGreen, size: 24),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Carl Lawrence S. Maranion',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87)),
                              SizedBox(height: 4),
                              Text('@Carllawrence',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 20),
                    // Contact Information Section
                    const Text('CONTACT INFORMATION',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                            letterSpacing: 0.5)),
                    const SizedBox(height: 16),
                    _EditableField(
                      icon: Icons.email_outlined,
                      label: 'Email Address',
                      controller: emailController,
                      isEditing: isEditing,
                    ),
                    const SizedBox(height: 16),
                    _EditableField(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      controller: locationController,
                      isEditing: isEditing,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Work Information Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('WORK INFORMATION',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                            letterSpacing: 0.5)),
                    const SizedBox(height: 16),
                    _EditableField(
                      icon: Icons.work_outline,
                      label: 'Designation',
                      controller: designationController,
                      isEditing: isEditing,
                    ),
                    const SizedBox(height: 16),
                    _EditableField(
                      icon: Icons.home_outlined,
                      label: 'Office',
                      controller: officeController,
                      isEditing: isEditing,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isEditing ? 'Edit mode ON' : 'Changes saved!'),
                        backgroundColor: kGreen,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                      isEditing ? Icons.check_circle_outline : Icons.edit_outlined,
                      color: kGreen,
                      size: 20),
                  label: Text(
                      isEditing ? 'Save Changes' : 'Edit Profile',
                      style: const TextStyle(
                          color: kGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditableField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final bool isEditing;

  const _EditableField({
    required this.icon,
    required this.label,
    required this.controller,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: kGreen, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3)),
              const SizedBox(height: 6),
              isEditing
                  ? TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: kGreen, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: kGreen, width: 2),
                        ),
                      ),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    )
                  : Text(controller.text,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }
}
