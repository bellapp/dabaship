# Daba Delivery - Architecture Document

## Overview
This project is a monorepo containing two Flutter applications:
- **client_app**: For customers to browse products and place orders.
- **rider_app**: For delivery riders to accept and deliver orders.

Both applications share a common Firebase backend.

## Firebase Configuration
A single Firebase project should be created to host the data for both applications.
- **Project Name**: `daba-delivery` (suggested)
- **Services**: Authentication, Firestore Database, Storage (optional for images).

## Firestore Schema

### 1. Users Collection (`users`)
Stores profile information for clients.
- `uid` (string): Firebase Auth UID.
- `email` (string): User email.
- `displayName` (string): User full name.
- `phoneNumber` (string): Contact number.
- `address` (map): Default delivery address.
  - `street` (string)
  - `city` (string)
  - `zipCode` (string)
  - `lat` (number)
  - `lng` (number)
- `createdAt` (timestamp)

### 2. Riders Collection (`riders`)
Stores profile and status information for delivery riders.
- `uid` (string): Firebase Auth UID.
- `email` (string): Rider email.
- `displayName` (string): Rider name.
- `phoneNumber` (string): Contact number.
- `isAvailable` (boolean): Online/Offline status.
- `currentLocation` (geopoint): Real-time location.
- `vehicleType` (string): e.g., "bike", "scooter".
- `createdAt` (timestamp)

### 3. Products Collection (`products`)
Catalog of items available for delivery.
- `id` (string): Unique product ID.
- `name` (string): Product name.
- `description` (string): Product details.
- `price` (number): Unit price.
- `imageUrl` (string): URL to product image.
- `category` (string): Product category.
- `isAvailable` (boolean): Stock status.

### 4. Orders Collection (`orders`)
Tracks delivery orders from creation to completion.
- `id` (string): Unique order ID.
- `clientId` (string): Reference to `users` document.
- `riderId` (string, nullable): Reference to `riders` document (assigned rider).
- `status` (string): e.g., "pending", "accepted", "picked_up", "delivered", "cancelled".
- `items` (array of maps):
  - `productId` (string)
  - `quantity` (number)
  - `price` (number)
- `totalAmount` (number): Total cost.
- `deliveryAddress` (map): Copy of address at time of order.
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

## Next Steps
1. Create the Firebase project in the Firebase Console.
2. Enable Authentication (Email/Password, Phone).
3. Create the Firestore Database (start in Test Mode for development).
4. Add Android/iOS apps to the Firebase project for both `client_app` and `rider_app`.
5. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) and place them in the respective app directories.
