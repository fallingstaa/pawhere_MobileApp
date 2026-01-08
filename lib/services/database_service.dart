import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pawhere/models/pet_model.dart';
import 'package:pawhere/services/auth_service.dart';

// Use a singleton pattern for the DatabaseService to manage the connection
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // The application ID is provided by the canvas environment as a global variable.
  static const String _appId = String.fromEnvironment('app_id', defaultValue: 'default-app-id');

  /// Helper to get the correct Firestore collection reference for the current user.
  /// The path adheres to the private data security rule:
  /// /artifacts/{appId}/users/{userId}/pets
  CollectionReference<Map<String, dynamic>> _petCollectionRef() {
    // We assume the user is authenticated at this point due to AuthService initialization
    final userId = AuthService().getCurrentUserId();

    if (userId == null) {
      // This is a critical error and should stop further execution.
      throw Exception("User not authenticated. Cannot access private pet data.");
    }

    final collectionPath = 'artifacts/$_appId/users/$userId/pets';
    // Returns a reference to the 'pets' subcollection under the user's private path
    return _db.collection(collectionPath);
  }

  /// Adds a new pet/device to the user's private collection.
  /// Returns true on success, false on failure.
  Future<bool> addLinkedPet({
    required String name, // CHANGED from accountName
    required String imei,
    required String password,
  }) async {
    try {
      final newPet = Pet(
        // Firestore will generate the ID upon saving, so we use an empty string for the object.
        id: '', 
        name: name,
        species: 'Tracker', // Default type for a new device
        status: 'Checking...',
        imagePath: 'assets/images/dog.jpg', // Default image asset path
        imei: imei,
        password: password,
      );

      // Add the document, using the toFirestore() map method
      await _petCollectionRef().add(newPet.toFirestore());
      return true;
    } catch (e) {
      // Print the error for debugging purposes in the console
      print("Error adding linked pet: $e"); 
      return false;
    }
  }

  /// Streams the list of linked pets from Firestore in real-time.
  /// The UI (MainFeatureShell) will consume this stream to update automatically.
  Stream<List<Pet>> streamLinkedPets() {
    // .snapshots() provides a stream of QuerySnapshot events in real-time
    return _petCollectionRef()
        .snapshots() 
        .map((snapshot) {
      // Map the QuerySnapshot to a List<Pet>
      return snapshot.docs.map((doc) {
        // doc.id is the unique Firestore document ID
        return Pet.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  /// **NEW METHOD:** Fetches the list of linked pets once using a Future.
  /// Used by screens that don't need real-time updates (like the map screen for a single fetch).
  Future<List<Pet>> fetchLinkedPetsFuture() async {
    try {
      final querySnapshot = await _petCollectionRef().get();
      return querySnapshot.docs.map((doc) {
        return Pet.fromFirestore(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print("Error fetching linked pets: $e");
      return [];
    }
  }
}