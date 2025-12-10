# Google Maps API Setup Guide

## Prerequisites
- Google Cloud Console account
- Firebase project (already configured)

## Steps

### 1. Enable Maps APIs
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select your Firebase project
3. Navigate to **APIs & Services** > **Library**
4. Enable these APIs:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**

### 2. Create API Key
1. Go to **APIs & Services** > **Credentials**
2. Click **Create Credentials** > **API Key**
3. Copy the API key

### 3. Restrict API Key (IMPORTANT for security)
1. Click on your new API key
2. Under **Application restrictions**:
   - Select **Android apps**
   - Add package name: `com.example.client_app`
   - Add SHA-1 fingerprint (get from Android Studio or `keytool`)
3. Under **API restrictions**:
   - Select **Restrict key**
   - Choose only **Maps SDK for Android**
4. Click **Save**

### 4. Add Key to Android

**File:** `android/app/src/main/AndroidManifest.xml`

Replace `YOUR_MAPS_API_KEY_HERE` with your actual API key:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIza...YOUR_ACTUAL_KEY"/>
```

### 5. iOS Configuration (if targeting iOS)

**File:** `ios/Runner/AppDelegate.swift`

Add at the top:
```swift
import GoogleMaps
```

In `application(_:didFinishLaunchingWithOptions:)`:
```swift
GMSServices.provideAPIKey("YOUR_MAPS_API_KEY_HERE")
```

### 6. Get SHA-1 Fingerprint (Android)

#### Debug Key:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

#### Release Key:
```bash
keytool -list -v -keystore /path/to/your-release-key.jks -alias your-alias
```

## Testing

1. Run the app: `flutter run`
2. Navigate to Checkout screen
3. Verify Maps loads without "For development purposes only" watermark
4. Test location selection

## Troubleshooting

**Map shows gray tiles:**
- Check API key is correct
- Verify Maps SDK for Android is enabled
- Check package name matches restriction

**Permission denied:**
- App will request location permission at runtime
- Check AndroidManifest has location permissions

**iOS not working:**
- Verify AppDelegate.swift configuration
- Check iOS bundle identifier matches API restriction
