import 'package:flutter/material.dart';
import 'package:pawhere/features/notification/screens/notification_screen.dart';
import 'package:pawhere/features/location/screens/location_screen.dart';
import 'package:pawhere/features/paw/screen/paw_screen.dart';
import 'package:pawhere/features/person/screens/person_screen.dart';
import 'package:pawhere/features/home/screens/add_equipment_screen.dart';
import 'package:pawhere/models/pet_model.dart';
import 'package:pawhere/services/database_service.dart';

class MainFeatureShell extends StatefulWidget {
  const MainFeatureShell({Key? key}) : super(key: key);
  static const routeName = '/main-feature-shell';

  @override
  _MainFeatureShellState createState() => _MainFeatureShellState();
}

class _MainFeatureShellState extends State<MainFeatureShell> {
  int _selectedIndex = 0;

  List<Widget> get _pages => const [
        _DashboardContent(),
        NotificationScreen(),
        LocationScreen(),
        PawScreen(),
        PersonScreen(),
      ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  String get _title {
    switch (_selectedIndex) {
      case 0:
        return 'Pawhere';
      case 1:
        return 'Notifications';
      case 2:
        return 'Location';
      case 3:
        return 'Paw';
      case 4:
        return 'Profile';
      default:
        return 'Pawhere';
    }
  }

  List<Widget> _actions(BuildContext context) {
    if (_selectedIndex == 0) {
      return [
        IconButton(
          tooltip: 'Add equipment',
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddEquipmentScreen()),
          ),
        ),
      ];
    }
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF4A905),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: _actions(context),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF134694),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Paw'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({Key? key}) : super(key: key);

  void _navigateToAddEquipment(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const AddEquipmentScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final db = DatabaseService();
    return StreamBuilder<List<Pet>>(
      stream: db.streamLinkedPets(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final pets = snap.data ?? [];
        if (pets.isEmpty) return _buildNoPetsContent(context);

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: pets.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => _buildPetCard(pets[i]),
        );
      },
    );
  }

  Widget _buildNoPetsContent(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.pets, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            const Text('No trackers linked yet.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Add your first device to get started.',
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddEquipment(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF134694)),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add equipment',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetCard(Pet pet) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey[300]!)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF134694).withOpacity(0.1),
          child: const Icon(Icons.pets, color: Color(0xFF134694)),
        ),
        title: Text(pet.name ?? 'Unnamed'),
        subtitle: Text('IMEI: ${pet.imei ?? '-'}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Future: open pet details
        },
      ),
    );
  }
}
