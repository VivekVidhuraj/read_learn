import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:read/controller/banner_image_controller.dart';
import 'package:read/controller/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final AuthController _authController = Get.find<AuthController>();
  final BannerImageController _bannerImageController = Get.put(BannerImageController());

  final Color _primaryColor = const Color(0xFF0A0E21);
  final Color _secondaryColor = const Color(0xFFFFA726);
  final Color _cardColor = const Color(0xFFF7F7F7); // Light color for the cards

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eLibrary', style: TextStyle(color: Colors.white)),
        backgroundColor: _primaryColor,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
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
            ..._buildDrawerItems(), // Use the spread operator to add items
            _buildPremiumSubscriptionItem(),
          ],
        ),
      ),
      body: Container(
        color: Colors.white, // Background color
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildBannerCarousel(),
            const SizedBox(height: 20),
            _buildSectionTitle('Featured Books'),
            const SizedBox(height: 10),
            _buildFeaturedBooks(),
            const SizedBox(height: 20),
            _buildSectionTitle('Recently Published'),
            const SizedBox(height: 10),
            _buildRecentlyPublishedBooks(),
            const SizedBox(height: 20),
            _buildSectionTitle('Bookmarks'),
            const SizedBox(height: 10),
            _buildBookmarks(),
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
            _buildCategories(),
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

  Widget _buildBannerCarousel() {
    return Obx(() {
      if (_bannerImageController.bannerImages.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      return CarouselSlider(
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 16 / 9,
          enlargeCenterPage: true,
          viewportFraction: 1.0,
          height: 150, // Adjust the height as needed
        ),
        items: _bannerImageController.bannerImages.map((bannerImage) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(bannerImage.imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            },
          );
        }).toList(),
      );
    });
  }

  Widget _buildFeaturedBooks() {
    return _buildHorizontalScroll(
      items: [
        _buildBookItem('asset/images/img.png', 'Book Title 1', '120'),
        const SizedBox(width: 10),
        _buildBookItem('asset/images/img.png', 'Book Title 2', '85'),
        const SizedBox(width: 10),
        _buildBookItem('asset/images/img.png', 'Book Title 3', '200'),
      ],
    );
  }

  Widget _buildRecentlyPublishedBooks() {
    return _buildHorizontalScroll(
      items: [
        _buildBookItem('asset/images/img.png', 'Book Title 4', '45'),
        const SizedBox(width: 10),
        _buildBookItem('asset/images/img.png', 'Book Title 5', '72'),
        const SizedBox(width: 10),
        _buildBookItem('asset/images/img.png', 'Book Title 6', '90'),
      ],
    );
  }

  Widget _buildBookmarks() {
    return _buildHorizontalScroll(
      items: [
        _buildBookmarkItem('Book Name 1', 'Page: 32'),
        const SizedBox(width: 10),
        _buildBookmarkItem('Book Name 2', 'Page: 67'),
        const SizedBox(width: 10),
        _buildBookmarkItem('Book Name 3', 'Page: 98'),
      ],
    );
  }

  Widget _buildCategories() {
    return _buildHorizontalScroll(
      items: [
        _buildCategoryItem('asset/images/img_2.png', 'Category 1'),
        const SizedBox(width: 10),
        _buildCategoryItem('asset/images/img_2.png', 'Category 2'),
        const SizedBox(width: 10),
        _buildCategoryItem('asset/images/img_2.png', 'Category 3'),
      ],
    );
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
      height: 220, // Adjusted the height to fit book covers better
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items,
      ),
    );
  }

  Widget _buildBookItem(String imagePath, String title, String pageCount) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '$pageCount pages',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkItem(String bookName, String pageNumber) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.bookmark, size: 40, color: Colors.orange),
          const SizedBox(height: 10),
          Text(
            bookName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            pageNumber,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorItem(String imagePath, String authorName) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 40,
          ),
          const SizedBox(height: 8),
          Text(
            authorName,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String imagePath, String categoryName) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 60,
            width: 60,
          ),
          const SizedBox(height: 8),
          Text(
            categoryName,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumSubscriptionItem() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor, _secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.star,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 10),
          const Text(
            'Premium Subscription',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Unlock exclusive features and content',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              // Navigate to subscription page or show subscription details
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              elevation: 3, // Slight elevation for better visual appearance
            ),
            child: const Text('Subscribe Now'),
          ),
        ],
      ),
    );
  }
}
