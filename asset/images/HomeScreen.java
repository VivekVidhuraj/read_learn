import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Constants for common styles
  final Color _tealColor = Color(0xFF008080);
  final Color _ultramarineColor = Color(0xFF3F00FF);
  final double _iconHeight = 24.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: _tealColor.withOpacity(0.7)),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: _tealColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextButton.icon(
              icon: Icon(Icons.upload, color: Colors.white),
              label: Text('Publish', style: TextStyle(color: Colors.white)),
              onPressed: () {
                // Handle publish button press
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
              accountName: Padding(
                padding: const EdgeInsets.only(top: 31),
                child: Text("Vivek V Raj"),
              ),
              accountEmail: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("vivekvraj@gmail.com"),
                  Text(
                    "Role: User",
                    style: TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
              currentAccountPicture: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image.asset(
                      'asset/images/user_avatar.png',
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: _tealColor.withOpacity(0.7),
              ),
            ),
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
              SizedBox(height: 20),
              _buildSectionTitle('Featured Books'),
              SizedBox(height: 10),
              _buildHorizontalScroll(
                items: [
                  _buildBookItem('asset/images/book1.png', 'Book Title 1'),
                  _buildBookItem('asset/images/book2.png', 'Book Title 2'),
                  _buildBookItem('asset/images/book3.png', 'Book Title 3'),
                ],
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Recently Published'),
              SizedBox(height: 10),
              _buildHorizontalScroll(
                items: [
                  _buildBookItem('asset/images/book4.png', 'Book Title 4'),
                  _buildBookItem('asset/images/book5.png', 'Book Title 5'),
                  _buildBookItem('asset/images/book6.png', 'Book Title 6'),
                ],
              ),
              SizedBox(height: 20),
              _buildSectionTitle('My Playlists'),
              SizedBox(height: 10),
              _buildHorizontalScroll(
                items: [
                  _buildPlaylistItem('Playlist 1', () {
                    // Handle button press for Playlist 1
                  }),
                  _buildPlaylistItem('Playlist 2', () {
                    // Handle button press for Playlist 2
                  }),
                  _buildPlaylistItem('Playlist 3', () {
                    // Handle button press for Playlist 3
                  }),
                ],
              ),
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
            icon: Icon(Icons.playlist_play),
            label: 'Playlists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _tealColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  // Drawer items
  List<Widget> _buildDrawerItems() {
    return [
      _buildDrawerItem('My Books', Icons.book),
      _buildDrawerItem('Playlists', Icons.playlist_play),
      _buildDrawerItem('Notifications', Icons.notifications),
      _buildDrawerItem('Settings', Icons.settings),
      _buildDrawerItem('Help', Icons.help),
      _buildDrawerItem('Log Out', Icons.logout),
    ];
  }

  Widget _buildDrawerItem(String title, IconData iconData) {
    return ListTile(
      leading: Icon(iconData, color: _tealColor.withOpacity(0.5)),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  // Search bar widget
  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search For Books or Authors',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // Section title widget
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  // Horizontal scroll widget
  Widget _buildHorizontalScroll({required List<Widget> items}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: items),
    );
  }

  // Book item widget
  Widget _buildBookItem(String assetPath, String bookTitle) {
    return Column(
      children: [
        Image.asset(assetPath, height: 150, width: 100),
        SizedBox(height: 5),
        Text(bookTitle),
      ],
    );
  }

  // Playlist item widget
  Widget _buildPlaylistItem(String playlistName, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _tealColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            playlistName,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: onPressed,
            child: Text('View Playlist'),
          ),
        ],
      ),
    );
  }
}
