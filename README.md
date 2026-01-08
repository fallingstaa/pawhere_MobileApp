# PAWhere (PawHere)

PAWhere is a Flutter-based pet tracking mobile application that helps pet owners
track their pets’ location and safety using GPS devices.

The system uses:
- **Traccar** for GPS tracking & location data
- **Firebase** for authentication, app data, and notifications


## 📌 Project Status

🚧 **In Development (Initial Phase)**

- Frontend UI: **~50–60% completed**
- Backend: **Firebase + Traccar connected**
- Some screens and logic are placeholders

This repository currently focuses on **mobile app UI and core structure**.


## 🛠 Tech Stack

- Flutter (Mobile App)
- Firebase
  - Authentication
  - Firestore
  - Cloud Functions (Proxy)
- Traccar (GPS Tracking Backend)



## ✅ Features Implemented

- Flutter project setup
- Firebase initialization
- Anonymous authentication
- Bottom navigation:
  - Dashboard
  - Location (Map)
  - Notifications (placeholder)
  - Pet (Paw)
  - Profile (placeholder)
- Pet profile model
- GPS position model
- Pet-device pairing (IMEI + password)
- Firestore structure for pets per user
- Map screen displaying pet location
- Pet profile image selection


## ⏳ Not Finished Yet

- Real GPS device integration
- Geofencing (safe zones)
- Alerts & notifications logic
- Device ownership rules
- Location history playback
- Full UI polish & error handling

---

## 📂 Project Structure
Core Files
pubspec.yaml: Flutter dependencies (Firebase, maps, image picker)
README.md: Project overview
.gitignore: Excludes build files, .env, etc.
Main App Code (lib/)
main.dart: App entry with Firebase init
firebase_options.dart: Platform-specific Firebase configs
models/: Pet & Position data classes
services/: Auth, Database (Firestore), Traccar API proxy
features/: UI screens (onboarding, home, location, pets, etc.)
Backend (functions/)
index.js: Firebase Cloud Function proxying Traccar GPS API
package.json: Node.js deps (Express, Axios, Firebase Admin)
Platform Support
android/, ios/, web/, windows/, macos/, linux/: Platform-specific builds
Assets
assets/images/: App logos and icons
Build & Config
firebase.json: Firebase project config
build/: Generated artifacts (ignored)
lib/
├── main.dart                    # App entry point with Firebase init
├── firebase_options.dart        # Platform-specific Firebase configs
├── models/                      # Data models
│   ├── pet_model.dart           # Pet data structure
│   └── position_model.dart      # GPS position data
├── services/                    # Business logic & APIs
│   ├── auth_service.dart        # Firebase authentication
│   ├── database_service.dart    # Firestore operations
│   ├── traccar_service.dart     # GPS tracking API client
│   └── api_service.dart         # General API utilities
└── features/                    # Feature-based UI modules
    ├── auth/                    # Authentication screens
    ├── home/                    # Main app shell & dashboard
    ├── location/                # Map & location tracking
    ├── notification/            # Notification management
    ├── onboarding/              # Welcome & device pairing
    ├── paw/                     # Pet-related features
    ├── person/                  # User profile
    ├── pets/                    # Pet details & management
    ├── shared/                  # Shared utilities
    └── tracking/                # GPS tracking screens.

