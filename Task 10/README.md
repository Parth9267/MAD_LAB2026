# Task 10: Testing, signing and deployment

- [Experiment report](report.pdf)
- [Output images](output/)
- [Extracted report text](report.txt)

## Release workflow

`code/` contains the reported testing/build commands, keytool commands, a blank signing-properties template and the Gradle signing snippet. This folder now includes the Campus Connect Dart app from the supplied ZIP in [lib/main.dart](lib/main.dart), its dependencies in [pubspec.yaml](pubspec.yaml), and its [setup-screen test](test/setup_test.dart). The same app is used in Task 9 for Firebase integration and in Task 10 for testing and release preparation. See [SETUP.md](SETUP.md) to generate platform scaffolds and configure Firebase. Run the test/build workflow from this task folder. Firebase options are still the supplied setup placeholder. The original report states that the Android build was stopped before completion and device/AAB verification remained pending. No APK or AAB is included.

## Dart source

- [Main app](lib/main.dart)
- [Firebase configuration placeholder](lib/firebase_options.dart)
