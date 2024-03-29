# Thing Finder
A Flutter app for tracking stored items.

Must run `dart run build_runner build` to do initial generation of
database.g.dart or after database.dart is changed. You *may* need to delete
`database/database.g.dart` and  `pubspec.lock` on subsequent changes and
re-runs.

Use `flutter run --release -d <DEVICE NAME HERE>` to get a launchable version
running on a physical phone/tablet. On iOS 14 and above it won't run untethered
otherwise.

# iOS Building

`flutter build ipa --obfuscate --split-debug-info=/build/debug_symbols/ios`

# Android Code Signing

[Google Docs](https://docs.flutter.dev/deployment/android#signing-the-app)

This app's \[project]/android/app/build.gradle is configured with code signing
setup for the Google Play Store.

Make sure a copy of `key.properties`is in \[project]/android/key.properties.

Build the app bundle with

TODO: 2022-10-19 get obfuscation and split debug info working for Android.
`flutter build appbundle`

Output will be located at \[project]/build/app/outputs/bundle/release/app.aab

# Pre-commit Steps

Double check that `dart fix --dry-run` followed by `dart fix --apply` are run to
keep Dart fixes coming in fresh!

# Credits

Inspired by [CodingWithTashi's drift tutorial series](https://www.youtube.com/watch?v=khwi8e3fZbM).
Early versions of this project draw heavily from this example, thank you for
your lessons.