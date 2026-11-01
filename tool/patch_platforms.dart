// Adds the permissions DocScan needs to the Android / iOS projects that
// `flutter create` generated.  Run:  dart run tool/patch_platforms.dart
import 'dart:io';

void main() {
  // ---------- Android ----------
  final manifest = File('android/app/src/main/AndroidManifest.xml');
  if (manifest.existsSync()) {
    var xml = manifest.readAsStringSync();
    if (!xml.contains('android.permission.INTERNET')) {
      xml = xml.replaceFirstMapped(
        RegExp(r'<manifest[^>]*>'),
        (m) => '${m[0]}\n'
            '    <uses-permission android:name="android.permission.INTERNET"/>\n'
            '    <uses-permission android:name="android.permission.CAMERA"/>',
      );
      manifest.writeAsStringSync(xml);
      print('Android permissions added.');
    } else {
      print('Android permissions already present.');
    }
  } else {
    print('android/ folder not found - run "flutter create" first.');
  }

  // ---------- iOS ----------
  final plist = File('ios/Runner/Info.plist');
  if (plist.existsSync()) {
    var xml = plist.readAsStringSync();
    if (!xml.contains('NSCameraUsageDescription')) {
      xml = xml.replaceFirst(
        '<dict>',
        '<dict>\n'
            '\t<key>NSCameraUsageDescription</key>\n'
            '\t<string>DocScan needs the camera to scan documents.</string>\n'
            '\t<key>NSPhotoLibraryUsageDescription</key>\n'
            '\t<string>DocScan needs your photos to import documents.</string>',
      );
      plist.writeAsStringSync(xml);
      print('iOS permissions added.');
    }
  }
}
