# Run from the original Campus Connect Flutter project, after restoring its source.
# These commands document the workflow; they have not been run by this script author.
flutter devices
flutter analyze
flutter test test/setup_test.dart
flutter doctor -v
flutter build apk --release
flutter build appbundle --release
