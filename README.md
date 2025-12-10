# Daba Delivery - Multi-App Project

A delivery platform with separate client and rider applications built with Flutter and Firebase.

## Project Structure

```
daba_delivery/
├── client_app/          # Customer-facing mobile app
├── rider_app/           # Delivery rider mobile app
├── functions/           # Firebase Cloud Functions
├── scripts/             # Utility scripts for data management
└── data/               # Data files
```

## Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Node.js and npm (for Firebase Functions)
- Firebase CLI
- iOS Simulator / Android Emulator
- Xcode (for iOS development on macOS)
- Android Studio (for Android development)

## Setup Instructions

### 1. Install Dependencies

#### Client App
```bash
cd client_app
flutter pub get
```

#### Rider App
```bash
cd rider_app
flutter pub get
```

#### Firebase Functions
```bash
cd functions
npm install
```

### 2. Firebase Configuration

Make sure you have the following Firebase configuration files (these are gitignored for security):
- `client_app/android/app/google-services.json`
- `client_app/ios/Runner/GoogleService-Info.plist`
- `rider_app/android/app/google-services.json`
- `rider_app/ios/Runner/GoogleService-Info.plist`
- `scripts/serviceAccountKey.json`

## Running the Apps

### Option 1: Run Both Apps Simultaneously (Recommended for Development)

#### Terminal 1 - Client App:
```bash
cd client_app
flutter run
```

#### Terminal 2 - Rider App:
```bash
cd rider_app
flutter run
```

**Note:** When running both apps, Flutter will prompt you to select a device for each app. Make sure to:
1. Have two simulators/emulators running, OR
2. Use one simulator and one physical device

### Option 2: Run Apps on Specific Devices

#### List Available Devices:
```bash
flutter devices
```

#### Run Client App on Specific Device:
```bash
cd client_app
flutter run -d <device-id>
```

#### Run Rider App on Specific Device:
```bash
cd rider_app
flutter run -d <device-id>
```

### Option 3: Run in Different Modes

#### Debug Mode (default):
```bash
flutter run
```

#### Release Mode:
```bash
flutter run --release
```

#### Profile Mode (for performance testing):
```bash
flutter run --profile
```

## Running on Different Platforms

### iOS Simulator
```bash
# Start iOS simulator first
open -a Simulator

# Then run the app
cd client_app  # or rider_app
flutter run
```

### Android Emulator

#### List Available Emulators:
```bash
flutter emulators
```

#### Launch Specific Emulators:
```bash
# Launch first emulator
flutter emulators --launch Medium_Phone_API_35

# Launch second emulator
flutter emulators --launch RiderDevice
```

#### Run Apps on Emulators:
Once emulators are running:

**Terminal 1 (Client App):**
```bash
cd client_app
flutter run
# Select the first emulator when prompted
```

**Terminal 2 (Rider App):**
```bash
cd rider_app
flutter run
# Select the second emulator when prompted
```

### Web (if enabled)
```bash
cd client_app  # or rider_app
flutter run -d chrome
```

## Development Workflow

### Hot Reload
While the app is running, press:
- `r` - Hot reload
- `R` - Hot restart
- `q` - Quit

### Running with Different Flavors (if configured)
```bash
flutter run --flavor dev
flutter run --flavor prod
```

## Firebase Functions

### Deploy Functions:
```bash
cd functions
npm run build
firebase deploy --only functions
```

### Test Functions Locally:
```bash
cd functions
npm run serve
```

## Useful Scripts

### Populate Catalog Data:
```bash
cd scripts
node populate_catalog.js
```

### Create Rider Account:
```bash
cd scripts
node create_rider.js
```

### Update User Password:
```bash
cd scripts
node update_user_password.js
```

## Testing Both Apps Together

1. **Start two simulators/emulators:**
   - iOS: Open two simulator instances
   - Android: Start two emulator instances with different AVDs

2. **Run Client App in Terminal 1:**
   ```bash
   cd client_app
   flutter run -d <device-1-id>
   ```

3. **Run Rider App in Terminal 2:**
   ```bash
   cd rider_app
   flutter run -d <device-2-id>
   ```

4. **Test the flow:**
   - Place an order in the client app
   - Accept the order in the rider app
   - Track delivery status in both apps

## Troubleshooting

### Port Already in Use
If you get a port conflict, kill the process:
```bash
# Find process using port
lsof -i :8080

# Kill process
kill -9 <PID>
```

### Flutter Doctor Issues
```bash
flutter doctor -v
```

### Clean Build
```bash
cd client_app  # or rider_app
flutter clean
flutter pub get
flutter run
```

### iOS Build Issues
```bash
cd client_app/ios  # or rider_app/ios
pod install
cd ..
flutter run
```

## Project Documentation

- [Architecture](architecture.md)
- [Firebase Setup Guide](firebase_setup_guide.md)
- [Cloud Functions Setup](CLOUD_FUNCTIONS_SETUP.md)
- [Maps Setup](MAPS_SETUP.md)

## Branch Strategy

- `main` - Production-ready code
- `dev` - Active development branch (use this for development)

## Contributing

1. Create a feature branch from `dev`
2. Make your changes
3. Test thoroughly
4. Create a pull request to `dev`

## Support

For issues or questions, please create an issue in the repository.
