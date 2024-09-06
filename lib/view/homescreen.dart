
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:read/controller/banner_image_controller.dart';
import 'package:read/controller/auth_controller.dart';
import 'package:read/view/selected_book_screen.dart';

import '../controller/book_controller.dart';
import '../model/book_model.dart'; // Import the new page

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BookController _bookController = Get.put(BookController()); // Ensure this is initialized

  int _selectedIndex = 0;
  final AuthController _authController = Get.find<AuthController>();
  final BannerImageController _bannerImageController = Get.put(BannerImageController());

  final Color _primaryColor = const Color(0xFF0A0E21);
  final Color _secondaryColor = const Color(0xFFFFA726);
  final Color _cardColor = const Color(0xFFF7F7F7); // Light color for the cards

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Get.toNamed('/home');
          break;
        case 1:
          Get.toNamed('/mybooks'); // Navigate to the new page
          break;
        case 2:
          Get.toNamed('/favorite');
          break;
        case 3:
          Get.toNamed('/profile');
          break;
      }
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
              accountName: Obx(() => Text(_authController.user?.displayName ?? "User Name")),
              accountEmail: Obx(() => Text(_authController.user?.email ?? "email@example.com")),
              currentAccountPicture: Obx(() {
                if (_authController.user?.photoURL != null) {
                  return CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.network(
                        _authController.user!.photoURL!,
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                      ),
                    ),
                  );
                } else {
                  return CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        'asset/images/user.jpg',
                        fit: BoxFit.cover,
                        width: 90,
                        height: 90,
                      ),
                    ),
                  );
                }
              }),
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
            //_buildSectionTitle('Featured Books'),
            // const SizedBox(height: 10),
            //_buildFeaturedBooks(),
            //   const SizedBox(height: 20),
            _buildSectionTitle('Recently Published'),
            const SizedBox(height: 10),
            _buildRecentlyPublishedBooks(),
            const SizedBox(height: 20),
            _buildSectionTitle('All Bo'),
            const SizedBox(height: 10),
            _buildHorizontalScroll(
              items: _bookController.recentlyPublishedBooks.map((book) {
                return Row(
                  children: [
                    _buildBookItem(book),  // Replace with the dynamic book item
                    const SizedBox(width: 10), // Space between items
                  ],
                );
              }).toList(),
            ),

            //const SizedBox(height: 20),
            // _buildSectionTitle('Categories'),
            //  const SizedBox(height: 10),
            //  _buildCategories(),
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

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Search for books...',
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  List<Widget> _buildDrawerItems() {
    return [
      ListTile(
        leading: const Icon(Icons.notifications),
        title: const Text('Notification'),
        onTap: () {
          Get.toNamed('/notification');
        },
      ),
      ListTile(
        leading: const Icon(Icons.book),
        title: const Text('Purchased Books'),
        onTap: () {
          Get.toNamed('/purchasedbook'); // Navigate to the purchased book page
        },
      ),
      ListTile(
        leading: const Icon(Icons.history),
        title: const Text('History'),
        onTap: () {
          Get.toNamed('/history');// Navigate to history screen
        },
      ),
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Logout'),
        onTap: () {
          _authController.signOut();
        },
      ),
    ];
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Get unlimited access to premium content and features.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () {
              // Handle subscription action
            },
            child: const Text('Subscribe Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _primaryColor,
      ),
    );
  }


  Widget _buildRecentlyPublishedBooks() {
    // Add a ScrollController to track scrolling
    final _scrollController = ScrollController();

    // Add a listener to update the current page based on the scroll position
    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      double maxScrollExtent = _scrollController.position.maxScrollExtent;
      // Update the progress based on the scroll position
      _scrollProgress.value = offset / maxScrollExtent;
    });

    return Obx(() {
      if (_bookController.recentlyPublishedBooks.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      // Limit to the latest 5 books
      final recentBooks = _bookController.recentlyPublishedBooks.take(5).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: recentBooks.length,
              itemBuilder: (context, index) {
                final book = recentBooks[index];

                return GestureDetector(
                  onTap: () {
                    Get.to(() => BookDetailsView(bookId: book.bookId));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 100,
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(book.coverUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          book.name,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // Horizontal progress indicator
          Obx(() {
            return LinearProgressIndicator(
              value: _scrollProgress.value, // The scroll progress
              minHeight: 3,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
            );
          }),
        ],
      );
    });
  }

  final _scrollProgress = Rx<double>(0.0); // Add this at the top of your state class





  Widget _buildBookItem(Book book) {
    return GestureDetector(
      onTap: () {
        // Navigate to the book details page when tapped
        Get.to(() => BookDetailsView(bookId: book.bookId));
      },
      child: Container(
        width: 100,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display book cover image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(book.coverUrl), // Book cover from Firestore
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 5),
            // Display book name
            Text(
              book.name,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalScroll({required List<Widget> items}) {
    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: items,
      ),
    );
  }


}
