import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pawhere/features/paw/models/pet_model.dart';

class PetProfileScreen extends StatelessWidget {
  final Pet pet;

  const PetProfileScreen({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('My Pets'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Pet Info Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      // Use a ternary operator to handle either an asset image or a file image
                      backgroundImage: pet.imagePath != null
                          ? pet.imagePath!.startsWith('assets/')
                              ? AssetImage(pet.imagePath!)
                              : FileImage(File(pet.imagePath!)) as ImageProvider
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      pet.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Detail Rows
                    _buildDetailRow('Gender', pet.type),
                    _buildDetailRow('Date of Birth', '10/11/2025'), // Placeholder data
                    _buildDetailRow('Age', pet.age),
                    _buildDetailRow('Species', pet.breed),
                    _buildDetailRow('Breed', pet.breed),
                    _buildDetailRow('Pair With', 'N/A'), // Placeholder data
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Action Buttons
            ElevatedButton(
              onPressed: () {
                // TODO: Add logic for deleting a pet (not for this demo)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Delete Pet'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Add logic for pairing with a tracker (not for this demo)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Pair With Tracker'),
            ),
          ],
        ),
      ),
    );
  }

  // A helper method to build the detail rows
  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value ?? 'N/A'),
        ],
      ),
    );
  }
}