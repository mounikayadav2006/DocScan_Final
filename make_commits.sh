#!/usr/bin/env bash
# Builds the Git history of DocScan in 33 meaningful commits (one per file/experiment).
# Run inside the project folder (Git Bash on Windows):   bash make_commits.sh
set -e
rm -rf .git
git init -q
git branch -M main
c() { msg="$1"; shift; git add -- "$@"; git commit -q -m "$msg"; echo "committed: $msg"; }

c "Initial commit: add .gitignore and lint rules"            .gitignore analysis_options.yaml
c "Add pubspec with Flutter dependencies"                    pubspec.yaml
c "Exp 1a: add one-click setup scripts for Windows/Linux/Mac" setup.bat setup.sh
c "Exp 1a: add platform permission patch tool"               tool/patch_platforms.dart
c "Exp 1a: add Flutter and Dart SDK setup screen"            lib/experiments/exp01_setup.dart
c "Exp 1b: add Dart basics console program"                  dart_basics
c "Add ScannedDocument data model"                           lib/models
c "Add SQLite database helper for local storage"             lib/services/database_helper.dart
c "Add ML Kit OCR service"                                   lib/services/ocr_service.dart
c "Add PDF export service"                                   lib/services/pdf_service.dart
c "Exp 2a/2b: basic widgets and Row/Column/Stack layouts"    lib/experiments/exp02_widgets.dart
c "Exp 3a/3b: responsive UI with LayoutBuilder and MediaQuery" lib/experiments/exp03_responsive.dart
c "Exp 4a/4b: Navigator push/pop and named routes"           lib/experiments/exp04_navigation.dart
c "Exp 5a/5b: setState counter and Provider counter"         lib/experiments/exp05_state.dart
c "Exp 5b: add AppState (ChangeNotifier) for the whole app"  lib/app_state.dart
c "Exp 6b: add light/dark ThemeData with accent colours"     lib/theme.dart
c "Exp 6a: add reusable custom widgets"                      lib/widgets
c "Exp 6a/6b: custom widget and theme demo screens"          lib/experiments/exp06_custom_theme.dart
c "Exp 7a/7b: forms and validation demo screens"             lib/experiments/exp07_forms.dart
c "Exp 7a/7b: add scan screen with validated form"           lib/screens/scan_screen.dart
c "Exp 8a/8b: explicit and implicit animation demos"         lib/experiments/exp08_animation.dart
c "Exp 8a: add animated splash screen"                       lib/screens/splash_screen.dart
c "Exp 9a/9b: REST API fetch and ListView demos"             lib/experiments/exp09_api.dart
c "Exp 9b: add scanning tips screen from REST API"           lib/screens/tips_screen.dart
c "Add home screen with responsive document grid"            lib/screens/home_screen.dart
c "Exp 4a: add document detail screen with PDF export"       lib/screens/document_detail_screen.dart
c "Exp 10b: add debugging tools screen"                      lib/experiments/exp10_testing_debugging.dart
c "Exp 10a: add unit and widget tests"                       test
c "Add Lab hub listing all 20 experiments"                   lib/screens/lab_hub_screen.dart
c "Add settings screen and bottom navigation shell"          lib/screens/settings_screen.dart lib/screens/main_shell.dart
c "Wire up app entry point, Provider and named routes"       lib/main.dart
c "Add experiment screenshots"                               screenshots
c "Add README with experiment-wise documentation"            README.md make_commits.sh
git log --oneline | cat
echo; echo "Total commits: $(git rev-list --count HEAD)"
