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
              icon:
              Image.asset('asset/images/classes.png', height: _iconHeight),
              label: Text('Classes', style: TextStyle(color: Colors.white)),
              onPressed: () {
                // Handle classes button press
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
                    "Course: Flutter Development",
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
                      'asset/images/whatsApp_logo.png',
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
              _buildSectionTitle('Subjects'),
              SizedBox(height: 10),
              _buildHorizontalScroll(
                items: [
                  _buildSubjectIcon('asset/images/classes.png', 'Mathematics'),
                  _buildSubjectIcon('asset/images/classes.png', 'Physics'),
                  _buildSubjectIcon('asset/images/classes.png', 'Chemistry'),
                  _buildSubjectIcon('asset/images/classes.png', 'Biology'),
                  _buildSubjectIcon('asset/images/classes.png', 'History'),
                ],
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Study Materials'),
              SizedBox(height: 10),
              _buildHorizontalScroll(
                items: [
                  _buildScrollableSection(
                    'Mathematics Guide',
                    'Updated for 2024',
                    'View Guide',
                        () {
                      // Handle button press for Mathematics Guide
                    },
                  ),
                  _buildScrollableSection(
                    'Physics Handbook',
                    'Latest Edition',
                    'View Handbook',
                        () {
                      // Handle button press for Physics Handbook
                    },
                  ),
                  _buildScrollableSection(
                    'Chemistry Workbook',
                    'Revised Edition',
                    'View Workbook',
                        () {
                      // Handle button press for Chemistry Workbook
                    },
                  ),
                  _buildScrollableSection(
                    'Biology Textbook',
                    'New Release',
                    'View Textbook',
                        () {
                      // Handle button press for Biology Textbook
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Live Classes'),
              SizedBox(height: 10),
              _buildHorizontalScroll(
                items: [
                  _buildScrollableSection(
                    'Physics: Motion and Force',
                    'Starts at 5 PM',
                    'Join Class',
                        () {
                      // Handle button press for Physics: Motion and Force
                    },
                  ),
                  _buildScrollableSection(
                    'Chemistry: Atomic Structure',
                    'Starts at 6 PM',
                    'Join Class',
                        () {
                      // Handle button press for Chemistry: Atomic Structure
                    },
                  ),
                  _buildScrollableSection(
                    'Biology: Human Anatomy',
                    'Starts at 7 PM',
                    'Join Class',
                        () {
                      // Handle button press for Biology: Human Anatomy
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Assignments'),
              SizedBox(height: 10),
              _buildHorizontalScroll(
                items: [
                  _buildScrollableSection(
                    'Math Homework',
                    'Due: Tomorrow',
                    'View Homework',
                        () {
                      // Handle button press for Math Homework
                    },
                  ),
                  _buildScrollableSection(
                    'Physics Project',
                    'Due: Next Week',
                    'View Project',
                        () {
                      // Handle button press for Physics Project
                    },
                  ),
                  _buildScrollableSection(
                    'Chemistry Lab Report',
                    'Due: Friday',
                    'View Report',
                        () {
                      // Handle button press for Chemistry Lab Report
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildSectionTitle('Exams'),
              SizedBox(height: 10),
              _buildHorizontalScroll(
                items: [
                  _buildScrollableSection(
                    'Biology Midterm',
                    'Date: 15th August',
                    'View Exam',
                        () {
                      // Handle button press for Biology Midterm
                    },
                  ),
                  _buildScrollableSection(
                    'Physics Quiz',
                    'Date: 20th August',
                    'View Quiz',
                        () {
                      // Handle button press for Physics Quiz
                    },
                  ),
                  _buildScrollableSection(
                    'Chemistry Test',
                    'Date: 25th August',
                    'View Test',
                        () {
                      // Handle button press for Chemistry Test
                    },
                  ),
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
            icon: Icon(Icons.tv),
            label: 'My Course',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cabin),
            label: 'Tuition Centres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Study Materials',
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
      _buildDrawerItem('Vscor Class', 'asset/images/classes.png'),
      _buildDrawerItem('My Performance', Icons.person),
      _buildDrawerItem('Notifications', Icons.notifications),
      _buildDrawerItem('Meetings', Icons.group),
      _buildDrawerItem('Assignments', Icons.work),
      _buildDrawerItem('Fee Payments', Icons.payment),
      _buildDrawerItem('Leave Marking', Icons.leave_bags_at_home_outlined),
      _buildDrawerItem('Progress report', Icons.local_activity),
      _buildDrawerItem('Refer a Friend', Icons.share),
      _buildDrawerItem('Contact Us', Icons.help),
      _buildDrawerItem('Log Out', Icons.logout),
    ];
  }

  Widget _buildDrawerItem(String title, dynamic iconData) {
    return ListTile(
      leading: iconData is String
          ? Image.asset(iconData, height: 16)
          : Icon(iconData, color: _tealColor.withOpacity(0.5)),
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
        hintText: 'Search For Topic Name',
        prefixIcon: Icon(Icons.search),
        suffixIcon: Icon(Icons.camera_alt),
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

  // Subject icon widget
  Widget _buildSubjectIcon(String assetPath, String subjectName) {
    return Column(
      children: [
        Image.asset(assetPath, height: 50, width: 110),
        SizedBox(height: 5),
        Text(subjectName),
      ],
    );
  }

  // Scrollable section widget
  Widget _buildScrollableSection(String itemTitle, String itemSubtitle,
      String buttonText, VoidCallback onPressed) {
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
            itemTitle,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            itemSubtitle,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: onPressed,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
