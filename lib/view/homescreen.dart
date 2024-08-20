import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:read/controller/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final AuthController _authController = Get.find<AuthController>();
  final Color _primaryColor = const Color(0xFF0A0E21);
  final Color _secondaryColor = const Color(0xFFFFA726);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: _primaryColor.withOpacity(0.7)),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton.icon(
              icon: const Icon(Icons.upload, color: Colors.white),
              label: const Text('Publish', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Get.offNamedUntil('/uploadbook', (Route<dynamic> route) => route.isFirst);
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Obx(() => Text(_authController.user.value?.displayName ?? "User Name")),
              accountEmail: Obx(() => Text(_authController.user.value?.email ?? "email@example.com")),
              currentAccountPicture: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      'asset/images/img_3.png',
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.7),
              ),
            ),
            _buildRegisteredEmails(),
            ..._buildDrawerItems(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildSectionTitle('Featured Books'),
              const SizedBox(height: 10),
              _buildHorizontalScroll(
                items: [
                  _buildBookItem('asset/images/img.png', 'Book Title 1'),
                  const SizedBox(width: 10),
                  _buildBookItem('asset/images/img.png', 'Book Title 2'),
                  const SizedBox(width: 10),
                  _buildBookItem('asset/images/img.png', 'Book Title 3'),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Recently Published'),
              const SizedBox(height: 10),
              _buildHorizontalScroll(
                items: [
                  _buildBookItem('asset/images/img.png', 'Book Title 4'),
                  const SizedBox(width: 10),
                  _buildBookItem('asset/images/img.png', 'Book Title 5'),
                  const SizedBox(width: 10),
                  _buildBookItem('asset/images/img.png', 'Book Title 6'),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Bookmarks'),
              const SizedBox(height: 10),
              _buildHorizontalScroll(
                items: [
                  _buildBookmarkItem('Bookmark 1', () {
                    // Handle button press for Bookmark 1
                  }),
                  const SizedBox(width: 10),
                  _buildBookmarkItem('Bookmark 2', () {
                    // Handle button press for Bookmark 2
                  }),
                  const SizedBox(width: 10),
                  _buildBookmarkItem('Bookmark 3', () {
                    // Handle button press for Bookmark 3
                  }),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Selected Authors'),
              const SizedBox(height: 10),
              _buildHorizontalScroll(
                items: [
                  _buildAuthorItem('asset/images/img_1.png', 'Author 1'),
                  const SizedBox(width: 10),
                  _buildAuthorItem('asset/images/img_1.png', 'Author 2'),
                  const SizedBox(width: 10),
                  _buildAuthorItem('asset/images/img_1.png', 'Author 3'),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Categories'),
              const SizedBox(height: 10),
              _buildHorizontalScroll(
                items: [
                  _buildCategoryItem('asset/images/img_2.png', 'Category 1'),
                  const SizedBox(width: 10),
                  _buildCategoryItem('asset/images/img_2.png', 'Category 2'),
                  const SizedBox(width: 10),
                  _buildCategoryItem('asset/images/img_2.png', 'Category 3'),
                ],
              ),
              const SizedBox(height: 20),
              _buildSubscriptionItem('Premium Subscription', () {
                // Handle button press for Subscription
              }),
            ],
          ),
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
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildRegisteredEmails() {
    return Obx(() {
      final emails = _authController.registeredEmails;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: emails.map((email) => ListTile(title: Text(email))).toList(),
      );
    });
  }

  List<Widget> _buildDrawerItems() {
    return [
      _buildDrawerItem('My Books', Icons.book),
      _buildDrawerItem('Bookmarks', Icons.bookmark),
      _buildDrawerItem('Notifications', Icons.notifications),
      _buildDrawerItem('Settings', Icons.settings),
      _buildDrawerItem('Help', Icons.help),
      _buildDrawerItem('Log Out', Icons.logout, onTap: _authController.signOut),
    ];
  }

  Widget _buildDrawerItem(String title, IconData iconData, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(iconData, color: _primaryColor.withOpacity(0.5)),
      title: Text(title),
      onTap: onTap ?? () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search For Books or Authors',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildHorizontalScroll({required List<Widget> items}) {
    return SizedBox(
      height: 200, // Set a fixed height if necessary
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items,
        ),
      ),
    );
  }

  Widget _buildBookItem(String assetPath, String bookTitle) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Expanded(
            child: Image.asset(assetPath, fit: BoxFit.cover),
          ),
          const SizedBox(height: 5),
          Text(bookTitle, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildBookmarkItem(String bookmarkName, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bookmarkName,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: onPressed,
            child: const Text('Read More'),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorItem(String assetPath, String authorName) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(assetPath),
        ),
        const SizedBox(height: 5),
        Text(authorName, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildCategoryItem(String assetPath, String categoryName) {
    return Column(
      children: [
        SizedBox(
          width: 100,
          height: 100,
          child: Image.asset(assetPath, fit: BoxFit.cover),
        ),
        const SizedBox(height: 5),
        Text(categoryName, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  Widget _buildSubscriptionItem(String subscriptionName, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            subscriptionName,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _secondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: onPressed,
            child: const Text('Subscribe'),
          ),
        ],
      ),
    );
  }
}
