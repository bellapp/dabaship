
# Firebase Setup Guide for Daba Delivery

This guide details how to add the Android and iOS applications for `client_app` and `rider_app` to your Firebase project.

## Prerequisites
- A Firebase project created at [console.firebase.google.com](https://console.firebase.google.com/).
- The `daba_delivery` project structure on your local machine.

## 1. Add Android Apps

### Client App (Android)
1. In Firebase Console, click **Add app** and select **Android**.
2. **Android package name**: `com.example.client_app`
3. **App nickname**: `Daba Client` (optional)
4. Click **Register app**.
5. Download `google-services.json`.
6. Move the file to: `daba_delivery/client_app/android/app/google-services.json`
7. Click **Next** and follow instructions to add the Firebase SDK (usually already handled by FlutterFire CLI, but good to double check).

### Rider App (Android)
1. In Firebase Console, click **Add app** > **Android**.
2. **Android package name**: `com.example.rider_app`
3. **App nickname**: `Daba Rider` (optional)
4. Click **Register app**.
5. Download `google-services.json`.
6. Move the file to: `daba_delivery/rider_app/android/app/google-services.json`

## 2. Add iOS Apps

### Client App (iOS)
1. In Firebase Console, click **Add app** > **iOS**.
2. **Apple bundle ID**: `com.example.clientApp`
3. **App nickname**: `Daba Client` (optional)
4. Click **Register app**.
5. Download `GoogleService-Info.plist`.
6. Move the file to: `daba_delivery/client_app/ios/Runner/GoogleService-Info.plist`
   > **Important**: You must also add this file to the Xcode project. Open `ios/Runner.xcworkspace` in Xcode, right-click the `Runner` folder, select **Add Files to "Runner"**, and select the `GoogleService-Info.plist` file.

### Rider App (iOS)
1. In Firebase Console, click **Add app** > **iOS**.
2. **Apple bundle ID**: `com.example.riderApp`
   *(Note: Verify this matches your project if you changed it. Default is usually camelCase of the project name)*
3. **App nickname**: `Daba Rider` (optional)
4. Click **Register app**.
5. Download `GoogleService-Info.plist`.
6. Move the file to: `daba_delivery/rider_app/ios/Runner/GoogleService-Info.plist`
   > **Important**: Add this file to the Xcode project as well.

## 3. Flutter Configuration
After adding the files, you need to configure Flutter to use them. The easiest way is using the `flutterfire` CLI, but since you are doing this manually:

1. **Android**:
   - Ensure `android/build.gradle` has `classpath 'com.google.gms:google-services:4.3.15'` (or latest).
   - Ensure `android/app/build.gradle` has `apply plugin: 'com.google.gms.google-services'`.

2. **iOS**:
   - No extra config needed usually if `GoogleService-Info.plist` is added correctly to Xcode.

3. **Dependencies**:
   Add `firebase_core` to `pubspec.yaml` in both apps:
   ```bash
   cd client_app
   flutter pub add firebase_core
   
   cd ../rider_app
   flutter pub add firebase_core
   ```

4. **Initialization**:
   In `main.dart` for both apps, ensure you initialize Firebase:
   ```dart
   import 'package:firebase_core/firebase_core.dart';
   
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
     runApp(const MyApp());
   }
   ```
