
NCA Share - Flutter Starter Project
==================================

This ZIP contains a ready-to-run Flutter starter project for "NCA Share" (peer-to-peer file sharing UI with placeholders for P2P logic).
It includes:
- lib/main.dart (starter app with UI: splash, pick/send/receive UI, transfer simulation)
- pubspec.yaml (dependencies)
- assets/images/logo.png (your provided logo)

IMPORTANT: This archive contains source code only. It does not include a compiled APK. To get a working Android APK or iOS build, follow the steps below.

Build & Run (Android)
---------------------
1. Install Flutter SDK: https://docs.flutter.dev/get-started/install
2. Ensure Android toolchain is set up (Android Studio + SDK) and device/emulator available.
3. Unzip this archive and open a terminal in the project folder.
4. Run:
   flutter pub get
   flutter run   # to run on connected device / emulator
5. To build a release APK:
   flutter build apk --release
   The APK will be at: build/app/outputs/flutter-apk/app-release.apk

Build & Run (iOS)
-----------------
1. On macOS only with Xcode installed.
2. Run:
   flutter pub get
   flutter build ipa   # or use Xcode workspace for deployment

Notes on P2P functionality
--------------------------
This starter implements the UI and file picking, and simulates transfers. The actual peer-to-peer transfer logic is left as clear TODOs in lib/main.dart. Recommended approaches:
- WebRTC data channels (cross-platform): use flutter_webrtc and a lightweight signaling method (QR codes or a Node.js signaling server).
- Wi-Fi Direct / Multipeer (native offline): requires platform-specific plugins or native modules (Android/iOS).

If you'd like, I can provide:
- WebRTC data-channel send/receive example code (Flutter) plus a small Node.js signaling server.
- Guidance for adding Wi-Fi Direct native plugin for Android.

