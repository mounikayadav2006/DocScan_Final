@echo off
REM ===== DocScan one-click setup (Windows) =====
REM Connect your phone (USB debugging ON) or start an emulator first.
call flutter create --project-name docscan --platforms=android,ios .
call dart run tool/patch_platforms.dart
call flutter pub get
call flutter devices
call flutter run
