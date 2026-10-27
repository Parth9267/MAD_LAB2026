# Task 2: Hello World

- [Experiment report](report.pdf)
- [Output images](output/)
- [Extracted report text](report.txt)

## Dart source

- [Main app: lib/main.dart](lib/main.dart)

## Code and running

`lib/` contains the Dart source. `pubspec.yaml` contains package metadata and dependencies. Platform scaffold folders were not supplied in the PDFs. From this folder run:

```powershell
flutter create --project-name madl_task_2 .
flutter pub get
flutter run
```

Use an installed device supported by the experiment. Task 8 uses dart:io and needs Android, iOS or desktop rather than a web browser. Platform generation may add a sample test; remove or adapt that generated test for this app.
