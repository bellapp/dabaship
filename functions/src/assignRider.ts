// Firebase Cloud Function: Assign Rider to New Order
// This function triggers when a new order is created
// and assigns the nearest available rider within 2km

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';


interface RiderData {
  name: string;
  location: admin.firestore.GeoPoint;
  isAvailable: boolean;
  currentOrderId?: string;
}

interface Order {
  userId: string;
  deliveryLocation: admin.firestore.GeoPoint;
  status: string;
  riderId?: string;
}

/**
 * Calculate distance between two coordinates in kilometers
 * Using Haversine formula
 */
function calculateDistance(
  lat1: number,
  lon1: number,
  lat2: number,
  lon2: number
): number {
  const R = 6371; // Earth's radius in km
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

export const assignRiderToOrder = functions.firestore
  .onDocumentCreated('orders/{orderId}', async (event) => {
    const orderId = event.params.orderId;
    const snapshot = event.data;
    
    if (!snapshot) {
      console.log('No data found');
      return null;
    }
    
    const order = snapshot.data() as Order;

    console.log(`Processing new order: ${orderId}`);

    // Only process pending orders
    if (order.status !== 'pending') {
      console.log('Order is not pending, skipping');
      return null;
    }

    const orderLocation = order.deliveryLocation;
    const orderLat = orderLocation.latitude;
    const orderLon = orderLocation.longitude;

    try {
      // Get all available riders
      const ridersSnapshot = await admin.firestore()
        .collection('riders')
        .where('isAvailable', '==', true)
        .get();

      if (ridersSnapshot.empty) {
        console.log('No available riders found');
        return null;
      }

      // Find closest rider within 2km
      let closestRiderData: RiderData | null = null;
      let closestRiderId: string | null = null;
      let minDistance = Infinity;

      ridersSnapshot.forEach(doc => {
        const riderData = doc.data() as RiderData;
        const riderLocation = riderData.location;
        
        if (!riderLocation) {
          console.log(`Rider ${doc.id} has no location`);
          return;
        }

        const distance = calculateDistance(
          orderLat,
          orderLon,
          riderLocation.latitude,
          riderLocation.longitude
        );

        console.log(`Rider ${doc.id} distance: ${distance}km`);

        // Check if within 2km radius
        if (distance <= 2 && distance < minDistance) {
          minDistance = distance;
          closestRiderData = riderData;
          closestRiderId = doc.id;
        }
      });

      if (!closestRiderData || !closestRiderId) {
        console.log('No riders within 2km radius');
        return null;
      }

      console.log(`Assigning order to rider: ${closestRiderId} (${minDistance}km away)`);

      // Update order with rider assignment
      await snapshot.ref.update({
        riderId: closestRiderId,
        status: 'assigned',
        assignedAt: admin.firestore.FieldValue.serverTimestamp()
      });

      // Update rider availability
      await admin.firestore()
        .collection('riders')
        .doc(closestRiderId)
        .update({
          isAvailable: false,
          currentOrderId: orderId
        });

      console.log(`Order ${orderId} successfully assigned to ${closestRiderId}`);

      // TODO: Send notification to rider
      // This would require FCM (Firebase Cloud Messaging) setup
      // Example:
      // await admin.messaging().send({
      //   token: riderToken,
      //   notification: {
      //     title: 'Nouvelle commande',
      //     body: 'Une nouvelle commande vous a été attribuée'
      //   }
      // });

      return null;
    } catch (error) {
      console.error('Error assigning rider:', error);
      throw error;
    }
  });

/**
 * When
 an order is marked as delivered, free up the rider
 */
export const onOrderDelivered = functions.firestore
  .onDocumentUpdated('orders/{orderId}', async (event) => {
    const before = event.data?.before.data() as Order;
    const after = event.data?.after.data() as Order;
    
    if (!before || !after) {
      return null;
    }

    // Check if order was just delivered
    if (before.status !== 'delivered' && after.status === 'delivered') {
      console.log(`Order ${event.params.orderId} delivered`);

      if (after.riderId) {
        // Free up the rider
        await admin.firestore()
          .collection('riders')
          .doc(after.riderId)
          .update({
            isAvailable: true,
            currentOrderId: null
          });

        console.log(`Rider ${after.riderId} is now available`);
      }
    }

    return null;
  });
