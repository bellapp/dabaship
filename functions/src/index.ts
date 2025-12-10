import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

// Export the assignRider functions
export {assignRiderToOrder, onOrderDelivered} from "./assignRider";

// Mock OTP sending function (simulated for dev)
export const sendWhatsappOtp = functions.https.onCall(async (request) => {
  const {phone} = request.data;

  if (!phone) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Phone number is required"
    );
  }

  // Generate 4-digit OTP
  const otp = Math.floor(1000 + Math.random() * 9000).toString();

  // Store OTP in Firestore with expiration
  await admin.firestore().collection("otp_codes").doc(phone).set({
    code: otp,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    expiresAt: admin.firestore.Timestamp.fromMillis(
      Date.now() + 5 * 60 * 1000
    ), // 5 minutes
  });

  // TODO: In production, integrate with Twilio/Wati to send via WhatsApp
  // For now, just log it
  console.log(`OTP for ${phone}: ${otp}`);

  return {success: true, message: "OTP sent (simulated)"};
});

// Verify OTP function
export const verifyOtp = functions.https.onCall(async (request) => {
  const {phone, code} = request.data;

  if (!phone || !code) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Phone and code are required"
    );
  }

  const otpDoc = await admin
    .firestore()
    .collection("otp_codes")
    .doc(phone)
    .get();

  if (!otpDoc.exists) {
    throw new functions.https.HttpsError("not-found", "OTP not found");
  }

  const otpData = otpDoc.data();
  if (!otpData) {
    throw new functions.https.HttpsError("not-found", "OTP data not found");
  }

  // Check expiration
  const now = admin.firestore.Timestamp.now();
  if (otpData.expiresAt < now) {
    throw new functions.https.HttpsError("deadline-exceeded", "OTP expired");
  }

  // Verify code
  if (otpData.code !== code) {
    throw new functions.https.HttpsError("permission-denied", "Invalid OTP");
  }

  // Delete OTP after successful verification
  await admin.firestore().collection("otp_codes").doc(phone).delete();

  return {success: true, message: "OTP verified"};
});
