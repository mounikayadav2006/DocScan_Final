#!/usr/bin/env bash
# ===== DocScan one-click setup (macOS / Linux) =====
# Connect your phone (USB debugging ON) or start an emulator first.
set -e
flutter create --project-name docscan --platforms=android,ios .
dart run tool/patch_platforms.dart
flutter pub get
flutter devices
flutter run
