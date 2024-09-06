import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart'; // Add this package for image picking

import '../controller/auth_controller.dart'; // Import your AuthController

class ProfileManagementPage extends StatefulWidget {
  const ProfileManagementPage({super.key});

  @override
  State<ProfileManagementPage> createState() => _ProfileManagementPageState();
}

class _ProfileManagementPageState extends State<ProfileManagementPage> {
  final AuthController _authController = Get.find<AuthController>();
  final Color _primaryColor = const Color(0xFF0A0E21);
  final Color _secondaryColor = const Color(0xFFFFA726);
  final Color _cardColor = const Color(0xFFF7F7F7);
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Management', style: TextStyle(color: Colors.white)),
        backgroundColor: _primaryColor,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Get.back();
              },
            );
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Obx(() {
                if (_authController.user?.photoURL != null) {
                  return Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.network(
                            _authController.user!.photoURL!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        ),
                        radius: 50,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: _primaryColor),
                          onPressed: _updateProfilePicture,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.asset(
                            'asset/images/user.jpg',
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        ),
                        radius: 50,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: _primaryColor),
                          onPressed: _updateProfilePicture,
                        ),
                      ),
                    ],
                  );
                }
              }),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                _authController.user?.displayName ?? 'User Name',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                _authController.user?.email ?? 'email@example.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildProfileOption(
              icon: Icons.person,
              title: 'Edit Profile',
              onTap: () {
                // Navigate to Edit Profile screen
              },
            ),
            _buildProfileOption(
              icon: Icons.lock,
              title: 'Change Password',
              onTap: () {
                // Navigate to Change Password screen
              },
            ),
            _buildProfileOption(
              icon: Icons.email,
              title: 'Email Settings',
              onTap: () {
                // Navigate to Email Settings screen
              },
            ),
            _buildProfileOption(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {
                _authController.signOut();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'My Books',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 3,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.toNamed('/home'); // Navigate to Home
              break;
            case 1:
              Get.toNamed('/mybooks'); // Navigate to My Books
              break;
            case 2:
              Get.toNamed('/favorite');
            // Already on FavoritesPage
              break;
            case 3:
              // Already on FavoritesPage
              break;
          }
        },
      ),
    );
  }

  Future<void> _updateProfilePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await _authController.updateProfilePicture(image.path);
    }
  }


  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: _primaryColor),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: _primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
