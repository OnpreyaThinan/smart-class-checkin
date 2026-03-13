# Smart Class Check-in & Learning Reflection App

## Project Description
This is a prototype mobile application built with Flutter that allows students to check in to class using GPS and QR code scanning. Students can also submit reflections about what they learned and provide feedback about the class.

## Features
- Class check-in with GPS
- QR code scanning
- Mood tracking before class
- Learning reflection after class
- Feedback submission
- Student ID and Student Name capture
- Local data storage using SharedPreferences
- Cloud sync to Firebase Firestore (when Firebase is configured)

## Submission Links
- GitHub Repository: https://github.com/your-username/your-repo
- Firebase Hosting URL: https://smart-class-check-in-5322e.web.app/

## Setup Instructions

1. Install Flutter SDK
2. Clone the repository
3. Run the following commands:

```bash
flutter pub get
flutter run
```

## How to Run (Short)

```bash
# Run on connected device or emulator
flutter run

# Build for web
flutter build web

# Build and run analyzer checks
flutter analyze

# Deploy to Firebase Hosting
firebase deploy
```

## Firebase Config

This app supports Firebase Firestore integration and Firebase Hosting deployment.

1. Install Firebase CLI: `npm install -g firebase-tools`
2. Login: `firebase login`
3. Create Firebase project in Firebase Console
4. Update project id in [.firebaserc](.firebaserc)
5. Configure FlutterFire for your app platforms (Android/iOS/Web)
6. Build web: `flutter build web`
7. Deploy: `firebase deploy`

Live URL: https://smart-class-check-in-5322e.web.app/

Firebase Console: https://console.firebase.google.com/project/smart-class-check-in-5322e/overview

## AI Usage Summary
- AI tools used: ChatGPT and GitHub Copilot
- AI helped scaffold UI, QR scanning, GPS integration, and storage patterns
- Manual implementation by student: form validation rules, student identity fields, UI refinements, and final data flow integration decisions
