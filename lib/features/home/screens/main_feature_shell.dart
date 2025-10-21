import 'package:flutter/material.dart';
// NOTE: Assuming these imports are correct based on your project structure
import 'package:pawhere/features/notification/screens/notification_screen.dart';
import 'package:pawhere/features/location/screens/location_screen.dart';
import 'package:pawhere/features/paw/screen/paw_screen.dart';
import 'package:pawhere/features/person/screens/person_screen.dart';
// NEW IMPORT: Required for the '+' button functionality
import 'package:pawhere/features/home/screens/add_equipment_screen.dart'; 

class MainFeatureShell extends StatefulWidget {
  const MainFeatureShell({Key? key}) : super(key: key);

  @override
  _MainFeatureShellState createState() => _MainFeatureShellState();
}

class _MainFeatureShellState extends State<MainFeatureShell> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    _DashboardContent(), // This is the home screen content
    const NotificationScreen(),
    const LocationScreen(),
    const PawScreen(),
    const PersonScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFF4A905),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Paw',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Person',
          ),
        ],
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with '+' symbol and user image
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          color: const Color(0xFFF4A905),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // '+' ICON BUTTON: Leads to AddEquipmentScreen
                IconButton(
                  icon: const Icon(
                    Icons.add, 
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // NAVIGATION: Go to the Add Equipment Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddEquipmentScreen()),
                    );
                  },
                ),
                
                // User Profile Image
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/profile.jpg'), 
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Flexible sections below the header
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // My Pets section
                _buildCard(
                  context,
                  title: 'My Pets',
                  icon: Icons.pets,
                  content: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildPetItem(
                            'Bella',
                            'assets/images/dog.jpg', // Corrected path
                          ),
                          _buildPetItem(
                            'Roudy',
                            'assets/images/dog2.jpg', // Corrected path
                            subtitle: 'More Pets',
                          ),
                          _buildPetItem(
                            'Fie',
                            'assets/images/dog3.jpg', // Corrected path
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {},
                        child: const Text('More Pets >'),
                      ),
                    ],
                  ),
                ),
                // Pet Location section
                _buildCard(
                  context,
                  title: 'Pet Location',
                  icon: Icons.location_on,
                  content: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          'assets/images/map.jpg', // Corrected path
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {},
                        child: const Text('Track Pets >'),
                      ),
                    ],
                  ),
                ),
                // Shop Now section
                _buildCard(
                  context,
                  content: Column(
                    children: [
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF134694),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Shop Now',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Image.asset('assets/images/product.jpg'), // Corrected path
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, {required Widget content, String? title, IconData? icon}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  if (icon != null) Icon(icon),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          content,
        ],
      ),
    );
  }

  Widget _buildPetItem(String name, String imagePath, {String? subtitle}) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        if (subtitle != null)
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF134694),
            ),
          ),
      ],
    );
  }
}