class Pet {
  // Firestore Document ID / Unique Pet ID
  final String id; 
  final String name;
  final String species; // e.g., 'Dog', 'Cat', 'Tracker'
  final String status;  // e.g., 'Online', 'Offline', 'Checking...'
  final String imagePath; // Path to the local asset image

  // Real-time Location/Status Data (updated by TraccarService)
  final double latestLatitude;
  final double latestLongitude;
  final double latestSpeed; // Speed in km/h

  // Traccar Credentials (SECURELY STORED in Firestore)
  final String imei; 
  final String password; 

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.status,
    required this.imagePath,
    required this.imei,
    required this.password,
    this.latestLatitude = 0.0,
    this.latestLongitude = 0.0,
    this.latestSpeed = 0.0,
  });

  // Factory constructor to create a Pet object from a Firestore document map
  factory Pet.fromFirestore(Map<String, dynamic> data, String id) {
    return Pet(
      id: id,
      name: data['name'] ?? 'Unknown Pet',
      species: data['species'] ?? 'Unknown Species',
      status: data['status'] ?? 'Offline',
      imagePath: data['imagePath'] ?? 'assets/images/dog.jpg',
      imei: data['imei'] ?? '',
      password: data['password'] ?? '',
      // Initial values for live data
      latestLatitude: data['latestLatitude'] ?? 0.0,
      latestLongitude: data['latestLongitude'] ?? 0.0,
      latestSpeed: data['latestSpeed'] ?? 0.0,
    );
  }

  // Method to convert Pet object to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'species': species,
      'status': status,
      'imagePath': imagePath,
      'imei': imei,
      'password': password,
      'latestLatitude': latestLatitude,
      'latestLongitude': latestLongitude,
      'latestSpeed': latestSpeed,
    };
  }

  // Method to create a new Pet object with updated position data from Traccar
  Pet copyWith({
    double? latestLatitude,
    double? latestLongitude,
    double? latestSpeed,
    String? status,
  }) {
    return Pet(
      id: id,
      name: name,
      species: species,
      status: status ?? this.status,
      imagePath: imagePath,
      imei: imei,
      password: password,
      latestLatitude: latestLatitude ?? this.latestLatitude,
      latestLongitude: latestLongitude ?? this.latestLongitude,
      latestSpeed: latestSpeed ?? this.latestSpeed,
    );
  }
}

// ----------------------------------------------------
// Model for Historical/Trip Data (for the Paw Screen)
// ----------------------------------------------------

class TripHistoryItem {
  final String location;
  final DateTime timestamp;
  final double distance; // in meters
  final double maxSpeed; // in km/h
  final String activity;

  TripHistoryItem({
    required this.location,
    required this.timestamp,
    required this.distance,
    required this.maxSpeed,
    required this.activity,
  });
}