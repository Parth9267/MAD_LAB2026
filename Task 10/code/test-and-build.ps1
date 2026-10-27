# Run from the Task 10 folder after generating platform scaffolds and configuring Firebase.
# These commands document the workflow; they have not been run by this script author.
flutter devices
flutter analyze
flutter test test/setup_test.dart
flutter doctor -v
flutter build apk --release
flutter build appbundle --release
