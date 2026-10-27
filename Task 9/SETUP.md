# Campus Connect — Flutter + Firebase

A responsive Material 3 student directory with a navy/teal banner, student form, realtime record cards, search, validation, submission feedback, loading/error states, connection status, and confirmed deletion.

## Requirements

Install the current stable Flutter SDK, Android Studio (for Android), Node.js and Firebase CLI. iOS development requires macOS/Xcode. Run `flutter doctor` and address platform requirements.

This download contains the Flutter source and Firebase rules. Platform scaffolding must be generated with the command below. Repository validation: dependencies resolved, Dart static analysis passed, and the included setup-screen widget test passed on 27 October 2026. The supplied code was formatted, one missing closing parenthesis was repaired, and the dropdown parameter was updated for the installed Flutter SDK. Live Firebase operations and platform builds have not been tested. No Firebase project is connected yet; the options file intentionally shows a setup message rather than using fabricated credentials.

## 1. Prepare the project

Open a terminal in this folder:

```sh
flutter create --platforms=android,ios,web --project-name campus_connect .
flutter pub add firebase_core firebase_auth firebase_database
flutter pub get
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
```

`flutter pub add` resolves compatible current plugin versions. Keep the generated pubspec.lock for reproducible builds. If `flutter create` creates test/widget_test.dart, remove that default counter-app test; it targets a different app.

## 2. Create Firebase resources

1. Open https://console.firebase.google.com/ and create or select a Firebase project.
2. Open Build → Realtime Database → Create database. Choose the required region and locked mode. This app uses Realtime Database, not Cloud Firestore.
3. Copy the exact database URL from the Realtime Database Data tab.
4. Open Authentication → Sign-in method and enable Anonymous.
5. Run the configuration command from this folder and select your project and target platforms:

```sh
flutterfire configure
```

This registers/configures your app and replaces `lib/firebase_options.dart`. Run it after creating the Realtime Database so configuration includes the database URL. The command may need to be on PATH; follow the location reported by `dart pub global activate`.

For manual native configuration, the Android file goes at `android/app/google-services.json`, and the iOS file at `ios/Runner/GoogleService-Info.plist` (include it in the Runner Xcode target). Prefer FlutterFire CLI rather than guessing Gradle configuration. Do not share service-account private keys.

## 3. Apply database rules

Paste database.rules.json into Realtime Database → Rules and Publish. Alternatively deploy the included rules with:

```sh
firebase deploy --only database --project YOUR_PROJECT_ID
```

Each installation signs in anonymously and accesses only `users/<uid>/students`. Anonymous auth persists locally; clearing app data or reinstalling may create a new UID and make earlier records inaccessible. Use email/password or another linked permanent account if cross-device access is required. These rules do not expose student records publicly.

## 4. Run

```sh
flutter run --dart-define=DATABASE_URL=https://YOUR_EXACT_DATABASE_URL
```

Copy the URL exactly; regional databases can end in firebasedatabase.app. Do not substitute the console URL. If generated options include the correct URL, `flutter run` also works.

Android release builds need internet permission in android/app/src/main/AndroidManifest.xml directly inside `<manifest>` (outside `<application>`):

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

For web, use `flutter run -d chrome --dart-define=DATABASE_URL=https://YOUR_EXACT_DATABASE_URL`. For iOS, run on a Mac after FlutterFire configuration.

## 5. Verify the assignment

1. Enter name, email, department, and an optional note. Submit.
2. Confirm “Student saved to Firebase” and a new list card.
3. In Firebase Console, inspect `users/<anonymous-auth-uid>/students/<push-id>`.
4. Edit that record's name in the console; the card should update without refreshing.
5. Search by name/email/department; delete a record and confirm it disappears in the console.
6. Submit an empty name or invalid email to check form validation.
7. Disable network to see connection status; writes may wait for reconnection before success is acknowledged.
8. Check permission-denied reporting by temporarily denying access in a separate test project, then restore rules.

Run `dart format lib`, `flutter analyze`, and the Flutter test command below before submission:

```sh
flutter test test/setup_test.dart
```

## Assignment mapping

| Requirement | Implementation |
| --- | --- |
| Firebase initialization | Startup.connect(), Firebase.initializeApp() |
| Form and input capture | Form, TextFormField, TextEditingController |
| Write data | ref.push().set(), server timestamp |
| Read and display | ref.onValue, StreamBuilder, record cards |
| Loading and failures | startup FutureBuilder, stream and write error states |

## Troubleshooting

- Setup message: run flutterfire configure; don't leave the placeholder options file.
- operation-not-allowed: enable Anonymous authentication.
- permission-denied: apply rules to the same database selected by DATABASE_URL.
- Wrong/empty database: check exact URL and ensure it is Realtime Database.
- Lost old records after reinstall: anonymous UID has changed.
- firebase or flutterfire not found: fix CLI PATH then reopen terminal.

## Official references

- https://firebase.google.com/docs/flutter/setup
- https://firebase.google.com/docs/database/flutter/read-and-write
- https://firebase.google.com/docs/auth/flutter/anonymous-auth
- https://firebase.google.com/docs/database/security
