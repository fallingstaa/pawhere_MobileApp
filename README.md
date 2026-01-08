# PAWhere (PawHere)

PAWhere is a Flutter-based pet tracking mobile application that helps pet owners
track their pets’ location and safety using GPS devices.

The system uses:
- **Traccar** → GPS tracking & location data  
- **Firebase** → authentication, app data, and notifications  

---

## 📌 Project Status

🚧 **In Development (Initial Phase)**

- Frontend UI: **~50–60% completed**
- Backend: **Firebase + Traccar connected**
- Some screens and logic are still placeholders

This repository currently focuses on **mobile app UI and core app structure**.

---

## 🛠 Tech Stack

- **Flutter** (Mobile App)
- **Firebase**
  - Authentication
  - Firestore
  - Cloud Functions (Proxy)
- **Traccar**
  - GPS tracking backend

---

## ✅ Features Implemented

- Flutter project setup
- Firebase initialization
- Anonymous user authentication
- Bottom navigation with main sections:
  - Dashboard
  - Location (Map)
  - Notifications *(placeholder)*
  - Pet (Paw)
  - Profile *(placeholder)*
- Pet profile data model
- GPS position data model
- Pet-device pairing (IMEI + password)
- Firestore structure for pets per user
- Map screen displaying pet location
- Pet profile image selection

---

## ⏳ Not Finished Yet

- Real GPS device integration
- Geofencing (safe zones)
- Alerts & notification logic
- Device ownership rules
- Location history playback
- Full UI polish, error handling, and loading states

---

## ▶️ Getting Started

### Requirements
- Flutter installed
- Firebase project configured

### Run the project
```bash
flutter pub get
flutter run
Also : 
flutter run -d chrome

lib/
 ├── main.dart              # App entry point
 ├── firebase_options.dart  # Firebase configs
 ├── models/                # Data models (Pet, Position)
 ├── services/              # Firebase & Traccar logic
 └── features/              # UI screens by feature

functions/
 └── index.js               # Firebase Cloud Function (Traccar proxy)

