import 'package:flutter/material.dart';
import 'package:pawhere/features/paw/models/pet_model.dart';
import 'package:pawhere/features/paw/screen/add_pet_screen.dart';
import 'package:pawhere/features/paw/screen/pet_profile_screen.dart'; // Import the new screen
import 'dart:io';

class PawScreen extends StatefulWidget {
  const PawScreen({super.key});

  @override
  State<PawScreen> createState() => _PawScreenState();
}

class _PawScreenState extends State<PawScreen> {
  final List<Pet> _pets = [
    Pet(
      name: 'Bella',
      breed: 'Australian Shepherd',
      imagePath: 'assets/images/dog.jpg',
    ),
    Pet(
      name: 'Roudy',
      breed: 'Rottweiler',
      imagePath: 'assets/images/dog2.jpg',
    ),
    Pet(
      name: 'Furry',
      breed: 'Samoyed',
      imagePath: 'assets/images/dog3.jpg',
    ),
  ];

  void _addPet(Pet newPet) {
    setState(() {
      _pets.add(newPet);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('My Pets'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _pets.length,
              itemBuilder: (context, index) {
                final pet = _pets[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    elevation: 4,
                    child: InkWell( // Make the card clickable
                      onTap: () {
                        // Navigate to the pet profile screen, passing the pet object
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PetProfileScreen(pet: pet),
                          ),
                        );
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: pet.imagePath != null
                            ? pet.imagePath!.startsWith('assets/')
                              ? AssetImage(pet.imagePath!)
                              : FileImage(File(pet.imagePath!)) as ImageProvider
                            : null,
                        ),
                        title: Text(
                          pet.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: pet.breed != null ? Text(pet.breed!) : null,
                        trailing: const Icon(Icons.link),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                final newPet = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddPetScreen()),
                );
                if (newPet != null) {
                  _addPet(newPet as Pet);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Add Pet'),
            ),
          ),
        ],
      ),
    );
  }
}