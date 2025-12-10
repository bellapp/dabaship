# Firebase Cloud Functions Setup

## Prerequisites
- Firebase Blaze (pay-as-you-go) plan
- Node.js installed (v18 or later)
- Firebase CLI installed

## Initial Setup

### 1. Install Firebase CLI
```bash
npm install -g firebase-tools
```

### 2. Login to Firebase
```bash
firebase login
```

### 3. Initialize Functions (if not already done)
```bash
cd daba_delivery
firebase init functions
```

Select:
- **Language:** TypeScript
- **ESLint:** Yes
- **Install dependencies:** Yes

### 4. Install Dependencies
```bash
cd functions
npm install firebase-functions@latest firebase-admin@latest
```

### 5. Deploy Functions
```bash
firebase deploy --only functions
```

## Function Details

### `assignRiderToOrder`
- **Trigger:** Firestore onCreate for `orders` collection
- **Purpose:** Automatically assigns nearest available rider to new orders
- **Logic:**
  1. Fetches order location
  2. Queries all available riders
  3. Calculates distance using Haversine formula
  4. Assigns closest rider within 2km
  5. Updates order and rider status

### `onOrderDelivered`
- **Trigger:** Firestore onUpdate for `orders` collection
- **Purpose:** Frees up rider when order is delivered
- **Logic:**
  1. Detects status change to 'delivered'
  2. Updates rider to available
  3. Clears currentOrderId

## Testing Functions

### Test Rider Assignment

1. Create a test rider:
```javascript
// In Firebase Console > Firestore
// Collection: riders
// Document ID: rider_test_001
{
  "name": "Test Rider",
  "location": new firebase.firestore.GeoPoint(33.5731, -7.5898),
  "isAvailable": true,
  "phone": "+212600000000"
}
```

2. Place an order in the app
3. Check Firestore to verify:
   - Order has `riderId` and `status: 'assigned'`
   - Rider has `isAvailable: false` and `currentOrderId`

### View Function Logs
```bash
firebase functions:log
```

Or in Firebase Console > Functions > Logs

## Cost Considerations

Cloud Functions pricing (free tier):
- 2M invocations/month
- 400K GB-seconds/month
- 200K GHz-seconds/month

For low traffic, this should stay within free tier.

## Troubleshooting

**Function not triggering:**
- Check Firebase Console > Functions for deployment status
- Verify Firestore rules allow function access
- Check function logs for errors

**No riders assigned:**
- Verify riders collection has available riders
- Check rider locations are within 2km
- Verify rider documents have `location` field
- Check function logs for distance calculations

**Permission errors:**
- Ensure service account has Firestore read/write permissions
- Check Firebase rules in `firestore.rules`

## Next Steps

1. Add Firebase Cloud Messaging (FCM) for rider notifications
2. Implement order timeout logic (reassign if rider doesn't respond)
3. Add distance-based delivery fee calculation
4. Implement rider rating system
