# Validation

Checked on 27 October 2026 using the local Flutter/Dart installation.

- All ten task folders contain a README, experiment PDF, code or workflow files, and report output images.
- Task 5 contains pages 1-5 of the combined PDF; Task 6 contains pages 6-10. All ten split pages were rendered and compared pixel-for-pixel with their original pages.
- The other eight report PDFs match the original files by SHA-256.
- Dependencies resolved for Tasks 2-8. The lockfiles record the resolved versions.
- Dart formatting and static analysis passed for all source files in Tasks 2-8. Task 2 was checked with flutter analyze; Tasks 3-8 were checked with dart analyze lib.
- Task 7's printed const Semantics invocation was changed to Semantics because that constructor is not const in the installed Flutter SDK.
- Task 4's initial service value was repaired to match the dropdown options; PDF line wrapping had removed its space.
- Task 9's access-rule JSON parses. Its Dart excerpts require the missing original application context and were not analyzed as a standalone app.

No app runtime, Android build, signing operation, Firebase deployment or cloud database mutation was performed during this organization. Screenshots and historical results in the PDFs belong to the original experiments.
