# Smart Class Check-in & Learning Reflection App

## Problem Statement
Universities need a simple way to confirm that students are physically present in class and actively participating. Traditional attendance methods do not guarantee real participation. This system allows students to check in using GPS and QR code and reflect on their learning after class.

## Target Users
- University students
- Course instructors

## Feature List
- Class Check-in
- QR Code scanning
- GPS location recording
- Mood tracking before class
- Learning reflection after class
- Class feedback submission

## User Flow
1. Student opens the app.
2. On the Home Screen, the student selects **Check-in** before class.
3. The system records GPS location and timestamp.
4. Student scans the class QR code.
5. Student fills in:
   - Previous class topic
   - Expected topic today
   - Mood before class
6. After class, the student presses **Finish Class**.
7. Student scans the QR code again.
8. GPS location is recorded again.
9. Student fills in:
   - What they learned today
   - Feedback about the class.

## Data Fields
- Student ID
- Student Name
- Timestamp
- GPS Latitude
- GPS Longitude
- Previous Topic
- Expected Topic
- Mood Score (1–5)
- Learning Reflection
- Feedback

## Mood Scale
| Score | Mood |
|---|---|
| 1 | 😡 Very negative |
| 2 | 🙁 Negative |
| 3 | 😐 Neutral |
| 4 | 🙂 Positive |
| 5 | 😄 Very positive |

## System Design
### Architecture (MVP)
- Frontend: Flutter mobile app with 3 main screens (Home, Check-in, Finish Class)
- Device Services: QR scanning and GPS location retrieval on device
- Local Persistence: SharedPreferences for offline-friendly record storage
- Optional Cloud Layer: Firebase Firestore can be added for centralized analytics and instructor dashboard

### Data Flow
1. Student opens app and chooses Check-in or Finish Class from Home.
2. App validates required form fields (Student ID, Student Name, and reflection fields).
3. App scans QR code and captures current GPS coordinates.
4. App creates a record object with timestamp + form data + QR + location.
5. App writes record to local storage.
6. App shows success feedback and returns to Home screen.

### Record Structure Examples
```json
{
   "type": "check-in",
   "student_id": "653210123-4",
   "student_name": "Jane Doe",
   "timestamp": "2026-03-13T09:02:41.112Z",
   "qr_result": "ROOM-A-0900",
   "lat": 20.0441,
   "lng": 99.8943,
   "prev_topic": "State management in Flutter",
   "expected_topic": "Firebase integration",
   "mood": 4
}
```

```json
{
   "type": "finish-class",
   "student_id": "653210123-4",
   "student_name": "Jane Doe",
   "timestamp": "2026-03-13T12:01:23.901Z",
   "qr_result": "ROOM-A-1200",
   "lat": 20.0442,
   "lng": 99.8944,
   "what_learned": "How to integrate scanner and location flow",
   "feedback": "Need 10 more minutes for Q&A"
}
```

## Tech Stack
- Flutter (Dart)
- SharedPreferences (local storage)
- Firebase Core (app initialization)
- Cloud Firestore (cloud sync)
- QR Scanner package
- Geolocator package
- Firebase Hosting (for deployment)
